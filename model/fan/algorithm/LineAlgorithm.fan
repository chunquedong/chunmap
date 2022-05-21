//
// Copyright (c) 2009-2022, chunquedong
//
// This file is a part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

**
** Line Algorithm
**
@Js
class LineAlgorithm
{

//////////////////////////////////////////////////////////////////////////
// Contains
//////////////////////////////////////////////////////////////////////////

  **
  ** contains lineString
  **
  static Bool containLineString(CoordSeq points, CoordSeq other)
  {
    //break
    tLine := CoordSeqBuf.makeCoordSeq(other)
    points.each
    {
      tLine.tryPutPointExactly(it)
    }

    // try to find the not contain
    r := tLine.findSegment |lsg|
    {
      if (!containSegment(points, lsg)) return true
      return false
    }
    return r == null
  }

  **
  ** direct include, dont consider straddle over node
  **
  static private Bool containSegment(CoordSeq points, LineSegment lseg)
  {
    n := points.size - 1
    for (i := 0; i < n; i++)
    {
      lseg2 := LineSegment(points[i], points[i + 1])
      if (lseg2.containsLineSegment(lseg)) return true
    }
    return false
  }

  static Bool onLineString(CoordSeq points, Point p)
  {
    n := points.size - 1
    for (i := 0; i < n; i++)
    {
      lseg := LineSegment(points[i], points[i + 1])
      if (lseg.onLineSegment(p))
        return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Intersection
//////////////////////////////////////////////////////////////////////////

  **
  ** compute the intersection
  **
  static PointLineBag intersection(CoordSeq me, CoordSeq l2)
  {
    bag := PointLineBag()
    chains1 := getMonotonyChains(me)
    chains2 := getMonotonyChains(l2)
    chains1.each |chain1|
    {
      chains2.each |chain2|
      {
        bag.addAll(chain1.intersection(chain2))
      }
    }
    return bag
  }

  static Bool intersects(CoordSeq l1, CoordSeq l2)
  {
  /*temp fix
    bag := PointLineBag()
    chains1 := getMonotonyChains(me)
    chains2 := getMonotonyChains(l2)
    r := chains1.find |chain1|
    {
      r0 := chains2.find |chain2|
      {
        chain1.intersects(chain2)
      }
      return r0 != null
    }
    return r != null
   */

    list1 := toLineSegmentList(l1)
    list2 := toLineSegmentList(l2)

    Int n1 := list1.size
    Int n2 := list2.size
    for (i1 := 0; i1 < n1; ++i1)
    {
      ls1 := list1.get(i1)
      for (i2 := 0; i2 < n2; ++i2)
      {
        ls2 := list2.get(i2)
        if (ls1.intersects(ls2)) return true
      }
    }
    return false
  }

  private static LineSegment[] toLineSegmentList(CoordSeq l1)
  {
    list := LineSegment[,]
    Int n1 := l1.size
    for (i1 := 1; i1 < n1; ++i1)
    {
      p1 := l1.get(i1-1)
      p2 := l1.get(i1)
      if (p1 == p2) continue
      
      ls1 := LineSegment(p1, p2)
      list.add(ls1)
    }
    return list
  }

//////////////////////////////////////////////////////////////////////////
// MonotonyChain
//////////////////////////////////////////////////////////////////////////

  **
  ** decompose to MonotonyChain
  **
  private static MonotonyChain[] getMonotonyChains(CoordSeq points)
  {
    MonotonyChain[] chains := [,]

    forward := true // forward direction
    if (points.size > 1 && points.first.x > points[1].x) forward = false

    n := points.size
    i := 0

    while (i < n)
    {
      if (forward)
      {
        i = extractPositiveChain(points, chains, i)
        forward = false
      }
      else
      {
        i = extractNegativeChain(points, chains, i)
        forward = true
      }
    }
    return chains
  }

  private static Int extractPositiveChain(CoordSeq points, MonotonyChain[] chains, Int from)
  {
    chain := MonotonyChain()
    n := points.size
    for (i := from; i < n; i++)
    {
      Point p := points[i]
      if (!chain.add(p))
      {
        chains.add(chain)
        return i - 1
      }
    }
    chains.add(chain)
    return n
  }

  private static Int extractNegativeChain(CoordSeq points, MonotonyChain[] chains, Int from)
  {
    chain := MonotonyChain()
    n := points.size
    for (i := from; i < n; i++)
    {
      Point p := points[i]
      if (!chain.insert(p))
      {
        chains.add(chain)
        return i - 1
      }
    }
    chains.add(chain)
    return n
  }

//////////////////////////////////////////////////////////////////////////
// Valid
//////////////////////////////////////////////////////////////////////////

  **
  ** simple meant no self intersection
  **
  static Bool isSimple(CoordSeq points)
  {
    if (!checkOverPoint(points)) return false

    n := points.size - 1;
    for (i := 0; i < n; i++)
    {
      for (j := i + 1; j < n; j++)
      {
        ls1 := LineSegment(points[i], points[i + 1])
        ls2 := LineSegment(points[j], points[j + 1])
        Obj? g := ls1.intersection(ls2)

        if (g == null) continue
        else if (g is Point[]) return false
        else if (g is Point)
        {
          Point p := g
          if (!isNodePoint(ls1, ls2, p)) return false
        }
      }
    }
    return true
  }

  **
  ** point is two linesegment intersection
  **
  private static Bool isNodePoint(LineSegment ls1, LineSegment ls2, Point p)
  {
    isBorder1 := ls1.onBorder(p)
    isBorder2 := ls2.onBorder(p)

    if (isBorder1 && isBorder2)
    {
      return true
    }
    return false
  }

  **
  ** check there is overlap point
  **
  private static Bool checkOverPoint(CoordSeq points)
  {
    set := Point:Point[:]

    if (points.size < 4) return !hasOverPoint(points)

    n := points.size - 1
    for (i := 1; i < n; i++)
    {
      p := points[i]
      if (set.containsKey(p)) return false
      else set.add(p, p)
    }

    if (existPointAt(points, 1))
    {
      if (points.first.equals(points[1])) return false
    }
    if (existPointAt(points, points.size - 2))
    {
      if (points.last.equals(points[points.size - 2])) return false
    }

    return true
  }

  **
  ** cover each
  **
  private static Bool hasOverPoint(CoordSeq points)
  {
    set := Point:Point[:]

    r := points.find |p|
    {
      if (set.containsKey(p)) return true
      set.add(p, p)
      return false
    }
    return r != null
  }

  private static Bool existPointAt(CoordSeq points, Int i)
  {
    if ((i < points.size) && i >= 0) return true
    return false
  }
}