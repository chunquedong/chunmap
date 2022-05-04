//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**
** Monotony Chain for compute lineString intersection
**
@Js
internal class MonotonyChain
{
  private Point[] points := [,]
  private Int cursor := 0
  private Int direction := 0

//////////////////////////////////////////////////////////////////////////
// convenience
//////////////////////////////////////////////////////////////////////////

  private Point first() { points[0] }
  private Point last() { points[size - 1] }
  private Int size() { points.size }
  private Point get(Int i) { points[i] }

  private Void resetCursor() { cursor = 0 }
  private Point currentPoint() { get(cursor) }
  private Void increaseCursor() { cursor++ }
  private Void reduceCursor() { cursor-- }

  private Bool hasPre() { cursor > 0 }
  private Point getPrePoint() { get(cursor - 1) }
  private LineSegment getPreLineSegment()
  {
    LineSegment(get(cursor - 1), get(cursor))
  }
  private Bool hasNext() { cursor < this.size - 1 }
  private Point getNextPoint() { get(cursor + 1) }
  private LineSegment getNextLineSegment()
  {
    LineSegment(get(cursor), get(cursor + 1))
  }

//////////////////////////////////////////////////////////////////////////
// Construct
//////////////////////////////////////////////////////////////////////////

  **
  ** add at last
  **
  Bool add(Point p)
  {
    if (size == 0)
    {
      points.add(p)
      return true
    }
    else if (p.x >= last.x)
    {
      if (!checkDirection(last, p)) return false
      setDirection(last, p)

      points.add(p)
      return true
    }
    return false
  }

  **
  ** Insert at first
  **
  Bool insert(Point p)
  {
    if (size == 0)
    {
      points.add(p)
      return true
    }
    else if (p.x <= first.x)
    {
      if (!checkDirection(p, last)) return false
      setDirection(p, last)

      points.insert(0, p)
      return true
    }
    return false
  }

  Void setDirection(Point oldP, Point newP)
  {
    if (direction != 0) return

    direction = newP.y <=> oldP.y
  }

  Bool checkDirection(Point oldP, Point newP)
  {
    if (direction == 0) return true
    c := newP.y <=> oldP.y
    if (c == 0) return true

    if (c == direction) return true
    else return false
  }

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  **
  ** connect with other
  **
  Bool join(MonotonyChain other)
  {
    Point p1 := this.last
    Point p2 := other.first
    if (p1.x >= p2.x && this.direction == other.direction)
    {
      points.addAll(other.points)
      return true
    }
    return false
  }

  //LineStr toLineString() { LineString(points) }

  Envelope envelope()
  {
    minY := first.y
    maxY := first.y

    points.each |p|
    {
      y := p.y
      if (y < minY)
      {
        minY = y
      }
      else if (y > maxY)
      {
        maxY = y
      }
    }
    return Envelope(first.x, minY, last.x, maxY)
  }

//////////////////////////////////////////////////////////////////////////
// Intersection
//////////////////////////////////////////////////////////////////////////

  **
  ** Get the Intersection
  **
  PointLineBag intersection(MonotonyChain other)
  {
    geometrys := PointLineBag()
    intersectionSub(other, geometrys, true)
    return geometrys
  }

  **
  ** Has intersection
  **
  Bool intersects(MonotonyChain other)
  {
    geometrys := PointLineBag()
    return intersectionSub(other, geometrys, false)
  }

  private Bool intersectionSub(MonotonyChain other, PointLineBag bag, Bool findAll)
  {
    // empty
    if (this.size == 0 || other.size == 0) return false
    // envelope test
    if (!this.envelope.intersects(other.envelope)) return false

    // init
    this.initBeginCursor(other)
    other.initBeginCursor(this)

    // compare Y coordinate
    Int compare := compareY(other)

    mustHasIntersection := false

    // calculat intersection
    while (true)
    {
      Int nowCompare := compareY(other)

      //location change
      if (mustHasIntersection || (nowCompare == 0 || nowCompare != compare))
      {
        Obj? g := getIntersection(other)
        if (g != null)
        {
          bag.add(g)
          if (!findAll) return true
          compare = nowCompare
          mustHasIntersection = false
        }
        else
        {
          mustHasIntersection = true
        }

      }

      // increase
      if (!increase(other)) break
    }
    return bag.size>0
  }

  ** go forward
  private Bool increase(MonotonyChain other)
  {
    if (this.currentPoint.x < other.currentPoint.x)
    {
      if (this.hasNext)
        this.increaseCursor
      else
        return false
    }
    else if (this.currentPoint.x > other.currentPoint.x)
    {
      if (other.hasNext)
        other.increaseCursor
      else
        return false
    }
    else
    {
      if (this.hasNext)
        this.increaseCursor
      else if (other.hasNext)
        other.increaseCursor
      else
        return false
    }
    return true
  }

  private Void initBeginCursor(MonotonyChain other)
  {
    resetCursor

    minX := other.currentPoint.x
    while (this.hasNext && getNextPoint.x < minX )
    {
      this.increaseCursor
    }
  }

  private Int compareY(MonotonyChain other)
  {
    this.currentPoint.y <=> other.currentPoint.y
  }

//////////////////////////////////////////////////////////////////////////
// LineSegment Intersection
//////////////////////////////////////////////////////////////////////////

  **
  ** Other intersect previous linesegment
  **
  private Obj? getIntersection(MonotonyChain other)
  {
    if (hasPre)
      return other.getLineIntersection(getPreLineSegment)
    else
      return other.getPointIntersection(this.currentPoint)
  }

  **
  ** previous linesegment intersect linesegment
  **
  private Obj? getLineIntersection(LineSegment ls)
  {
    if (hasPre)
      return getPreLineSegment.intersection(ls)
    else
      return linePointIntersection(ls, this.currentPoint)
  }

  **
  ** previous linesegment intersect point
  **
  private Obj? getPointIntersection(Point p)
  {
    if (hasPre)
      return linePointIntersection(getPreLineSegment, p)
    else
      return p.equals(this.currentPoint)? p : null
  }

  **
  ** intersection of point and line
  **
  private static Point? linePointIntersection(LineSegment ls, Point p)
  {
    ls.onLineSegment(p) ? p : null
  }

  override Str toStr() { "MonotonyChain: $points" }
}