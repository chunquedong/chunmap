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
** Line with tow Points
**
@Js
const class LineSegment
{
  const Point startPoint
  const Point endPoint

  new make(Point startPoint, Point endPoint)
  {
    if (startPoint == endPoint)
      throw ArgErr("need tow different points to make one line")
    this.startPoint = startPoint
    this.endPoint = endPoint
  }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  Float length2D() { startPoint.distance2D(endPoint) }

  Float length3D()
  {
    Coord3D p := startPoint
    return  p.distance3D(endPoint)
  }

  Float taxiLength()
  {
    x1 := startPoint.x
    y1 := startPoint.y
    x2 := endPoint.x
    y2 := endPoint.y

    return (x1 - x2).abs + (y1 - y2).abs
  }

  Float distance2D(Point point)
  {
    line := toLine
    vertical := Line.makePk(point, line.perpendicularK)
    Point crossP := line.crossPoint(vertical)

    if ((crossP.x < startPoint.x && crossP.x < endPoint.x )
      || (crossP.x > startPoint.x && crossP.x > endPoint.x )
      || (crossP.y < startPoint.y && crossP.y < endPoint.y )
      || (crossP.y > startPoint.y && crossP.y > endPoint.y ))
    {
      dis2 := point.distance2D(startPoint)
      dis3 := point.distance2D(endPoint)
      return dis2.min(dis3)
    }
    else
    {
      return point.distance2D(crossP)
    }

  }

  Envelope envelope()
  {
    Envelope.makePoints(startPoint, endPoint)
  }

  Point middlePoint()
  {
    x := (startPoint.x + endPoint.x) / 2f
    y := (startPoint.y + endPoint.y) / 2f
    return Coord(x, y)
  }

//////////////////////////////////////////////////////////////////////////
// Intersect
//////////////////////////////////////////////////////////////////////////

  **
  ** has Intersection with other lineSegment
  **
  Bool intersects(LineSegment other)
  {
    if (!this.envelope.intersects(other.envelope))
      return false
    if (this.straddle(other) && other.straddle(this))
      return true
    return false
  }

  **
  ** straddle on other lineSegment
  **
  private Bool straddle(LineSegment other)
  {
    v1 := Vector.makePoints(this.startPoint, other.startPoint)
    v2 := Vector.makePoints(other.endPoint, other.startPoint)
    v3 := Vector.makePoints(this.endPoint, other.startPoint)

    ji1 := v1.parallelogramArea(v2)
    ji2 := v3.parallelogramArea(v2)

    he := ji1 * ji2
    return he <= 0f
  }

  **
  ** compute intersection
  ** Return Point, Point[] or null
  **
  Obj? intersection(LineSegment other)
  {
    LineSegmentAlgorithm.intersection(this, other)
  }

//////////////////////////////////////////////////////////////////////////
// util
//////////////////////////////////////////////////////////////////////////

  Bool onLineSegment(Point p)
  {
    if (!this.envelope.containsPoint(p)) return false

    if (onBorder(p)) return true

    v1 := Vector.makePoints(p, startPoint)
    v2 := Vector.makePoints(endPoint, startPoint)
    ji := v1.parallelogramArea(v2)
    if (ji.approx(0f)) return true
    return false
  }

  Bool onBorder(Point p)
  {
    if (p.equals(startPoint) || p.equals(endPoint)) return true
    return false
  }

  Bool containsLineSegment(LineSegment lseg2)
  {
    hasI := this.envelope.intersects(lseg2.envelope)
    if (!hasI) return false

    if (this.onLineSegment(lseg2.startPoint)
        && this.onLineSegment(lseg2.endPoint))
    {
      return true
    }

    return false
  }

  Bool equalsIgnoreOrder(LineSegment lseg)
  {
    if (this.equals(lseg))
      return true
    if (this.startPoint.equals(lseg.endPoint)
        && this.endPoint.equals(lseg.startPoint))
      return true
    return false
  }

  Line toLine() { Line.makePoints(startPoint, endPoint) }

  Vector toVector() { Vector.makePoints(startPoint, endPoint) }

  CoordSeqBuf toLineString()
  {
    pointList := Point[,]
    pointList[0] = startPoint
    pointList[1] = endPoint
    return CoordSeqBuf.makeCoordSeq(CoordArray(pointList))
  }

  override Str toStr() { "LineSegment: $startPoint , $endPoint" }

  **
  ** definite proportional division point in vector algebra
  **
  Point separatedPoint(Float lamuda)
  {
    if (lamuda == -1f) throw ArgErr()
    x := (startPoint.x + endPoint.x * lamuda) / (1 + lamuda)
    y := (startPoint.y + endPoint.y * lamuda) / (1 + lamuda)

    return Coord(x, y)
  }
}