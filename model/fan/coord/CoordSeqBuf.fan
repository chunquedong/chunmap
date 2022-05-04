//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-10  Jed Young  Creation
//

**
** Edit the `CoordSeq`
**
@Js
class CoordSeqBuf
{
  ** list of `Point`
  private Point[] points

  ** make from Point list
  new make(Point[] pointList := [,])
  {
    points = pointList
  }

  ** make from `CoordSeq`
  new makeCoordSeq(CoordSeq coordSeq)
  {
    points = [,]
    coordSeq.each{ points.add(it) }
  }

  override Str toStr() { "CoordSeqBuf $points" }

  **
  ** the bound box fo these points.
  **
  private Envelope envelope()
  {
    env := EnvelopeBuilder.makeNone()
    points.each
    {
      env.extends(it)
    }
    return env.toEnvelope
  }

//////////////////////////////////////////////////////////////////////////
// get
//////////////////////////////////////////////////////////////////////////

  ** first point
  Point first() { get(0) }

  ** last point
  Point last() { return get(size - 1) }

  **
  ** Return the first item in the list for which c returns true.
  ** If c returns false for every item, then return null.
  ** index is LineSegment's first point position, so range is (0...size-1).
  **
  LineSegment? findSegment(|LineSegment,Int index->Bool| c)
  {
    n := size -1
    for (i := 0; i < n; i++)
    {
      lseg := LineSegment(get(i), get(i + 1))
      if (c(lseg, i)) return lseg
    }
    return null
  }


  ** The number of items in the list
  Int size(){ points.size }

  ** get Point by index
  Point get(Int index) { return points[index] }

  This set(Int index, Point p) { points[index] = p; return this }

  ** convenience `CoordArray.make`
  CoordSeq toCoordSeq() { CoordArray(points) }

  CoordSeqBuf dup() { CoordSeqBuf(points.dup) }

//////////////////////////////////////////////////////////////////////////
// Modify
//////////////////////////////////////////////////////////////////////////

  **
  ** try to insert point.
  ** if point is not on the line ,do nothing.
  ** return index when success. else return null
  **
  Int? tryPutPointExactly(Point p)
  {
    if (!envelope.containsPoint(p)) return null

    Int? index := null
    r := findSegment |lseg,i->Bool|
    {
      if ( !lseg.onLineSegment(p) || lseg.onBorder(p) ) return false

      insert(i + 1, p)
      index = i+1
      return true
    }
    return index
  }

  **
  ** try to insert point.
  ** if point is not on the line ,do nothing.
  ** return index when success. else return null
  **
  Int? tryPutPoint(Point p, Float tolerance)
  {
    Int? index := null
    r := findSegment |lseg,i->Bool|
    {
      if ( tolerance < lseg.distance2D(p) || lseg.onBorder(p) ) return false

      insert(i + 1, p)
      index = i+1
      return true
    }
    return index
  }

  **
  ** delete the point by position
  **
  Void removeAt(Int index)
  {
    points.removeAt(index)
  }

  **
  ** close to a circle.
  ** add point at last, if necessary.
  **
  Void close()
  {
    if (isClose) return

    if (points[0].approx(last))
    {
      points.removeAt(size - 1)
    }
    add(points[0])
  }

  **
  ** delete a point that exist another point have same coordinate.
  **
  Void deleteOverPoint(Float? tolerance := null)
  {
    Point[] ps := [,]
    points.each |p|
    {
      if (!containPoint(ps, p, tolerance))
      {
        ps.add(p)
      }
    }
    points = ps
  }

  ** helper for deleteOverPoint
  static private Bool containPoint(Point[] ps, Point point, Float? tolerance := null)
  {
    r := ps.find |p->Bool| { p.approx(point, tolerance) }
    return r != null
  }

  ** return true if fist point same to last point
  Bool isClose() { first.equals(last) }

  ** add point to last
  Void add(Point p)
  {
    points.add(p)
  }

  ** Insert the item at the specified index.
  Void insert(Int index, Point p)
  {
    points.insert(index, p)
  }

  ** Return if size == 0.
  Bool isEmpty() { size == 0 }

  ** add all CoordSeq to last
  Void addAll(CoordSeq lineString)
  {
     points.addAll(lineString.toList)
  }

  **
  ** insert all CoordSeq to front
  **
  Void insertAll(CoordSeq lineString)
  {
    tpoints := Point[,]
    lineString.each
    {
       tpoints.add(it)
    }
    points.insertAll(0, tpoints)
  }

  **
  ** Reverse the order of the items.
  **
  Void reverse()
  {
    pointList := Point[,]
    for (i := size - 1; i >= 0; i--)
    {
      pointList.add(get(i))
    }
    points = pointList
  }

//////////////////////////////////////////////////////////////////////////
// Join
//////////////////////////////////////////////////////////////////////////

  **
  ** Did the line is first-end join?
  **
  Bool canJoin(CoordSeq l2)
  {
    if (isEmpty) return true

    if ( (last.equals(l2.first))  || (last.equals(l2.last)) ||
         (first.equals(l2.first)) || (first.equals(l2.last)) )
    {
      return true
    }
    else
    {
      return false
    }
  }

  **
  ** link together.
  ** if cann't join thorw ArgErr.
  **
  Void join(CoordSeq l2)
  {
    if (this.isEmpty)
    {
      addAll(l2)
    }
    else if (last.equals(l2.first))
    {
      directAddJoin(l2)
    }
      else if (this.last.equals(l2.last))
    {
      directAddJoin(reverseIt(l2))
    }
     else if (this.first.equals(l2.first))
    {
      this.reverse
      directAddJoin(l2)
    }
    else if (this.first.equals(l2.last))
    {
      directInsertJoin(l2)
    }
    else
    {
      throw ArgErr("no join part")
    }
  }

  static private CoordSeq reverseIt(CoordSeq ls)
  {
    le := CoordSeqBuf.makeCoordSeq(ls)
    le.reverse
    return le.toCoordSeq
  }

  private Void directAddJoin(CoordSeq line)
  {
    n := line.size
    for (i := 1;  i < n; i++)
    {
      points.add(line.get(i))
    }
  }

  private Void directInsertJoin(CoordSeq line)
  {
    pointList := Point[,]
    n := line.size - 1
    for (i := 0; i < n; i++)
    {
      pointList.add(line.get(i))
    }
    points.insertAll(0, pointList)
  }
}