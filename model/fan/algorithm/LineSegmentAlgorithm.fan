//
// Copyright (c) 2009-2022, chunquedong
//
// This file is a part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-13  Jed Young  Creation
//

**
** LineSegment algorithm
**
@Js
class LineSegmentAlgorithm
{
  **
  ** compute intersection
  ** Return Point, Point[] or null
  **
  static Obj? intersection(LineSegment me , LineSegment other)
  {
    if (!me.intersects(other)) return null

    // If collinear
    if (me.toVector.parallelogramArea(other.toVector) == 0f)
      return joinLinePart(me, other)

    // to Line
    line1 := me.toLine
    line2 := other.toLine

    // boundary check
    if (me.onBorder(other.endPoint)) return other.endPoint
    else if (me.onBorder(other.startPoint)) return other.startPoint
    else if (other.onBorder(me.endPoint)) return me.endPoint
    else if (other.onBorder(me.startPoint)) return me.startPoint

    // compute cross point
    px := line1.crossPoint(line2)

    // assert
    if (px == null) { throw Err("unreachableCode") }

    // normalization
    if (!me.envelope.containsPoint(px) || !other.envelope.containsPoint(px))
    {
      Point[] ps := [ me.startPoint, me.endPoint, other.startPoint, other.endPoint ]
      px = getNearPoint(px, ps)
    }
    return px
  }

  private static Point getNearPoint(Point p, Point[] ps)
  {
    k := 0
    d := Float.posInf

    ps.each |cp, i|
    {
      dd := p.distance2D(cp)
      if (dd < d)
      {
        d = dd
        k = i
      }
    }
    return ps[k]
  }

//////////////////////////////////////////////////////////////////////////

  **
  ** compute communal part when collinear
  **
  private static Obj joinLinePart(LineSegment me , LineSegment other)
  {
    Point[] points :=
    [
      me.startPoint,
      me.endPoint,
      other.startPoint,
      other.endPoint,
    ]
    points.sort // sort!

    if (points[1].equals(points[2])) return points[1]

    return [points[1], points[2]]
  }

}