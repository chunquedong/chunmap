//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

**
** Triangle
**
@Js
const class Triangle
{
  ** point1
  const Point p1

  ** point2
  const Point p2

  ** point3
  const Point p3

  **
  ** make from three point
  **
  new make(Point p1, Point p2, Point p3)
  {
    this.p1 = p1
    this.p2 = p2
    this.p3 = p3
  }

  **
  ** compute algebra area
  **
  Float area()
  {
    v1 := Vector.makePoints(p1, p2)
    v2 := Vector.makePoints(p1, p3)
    Float a := v1.parallelogramArea(v2)
    return a / 2f
  }

  **
  ** exterior circle center
  **
  Point exteriorCenter()
  {
    l1 := getVerticalLine(p1, p2)
    l2 := getVerticalLine(p2, p3)

    return l1.crossPoint(l2)
  }

  **
  ** simple coordinate average value
  **
  Point coordCenter()
  {
    x := (p1.x + p2.x + p3.x) / 3f
    y := (p1.y + p2.y + p3.y) / 3f
    return Coord(x, y)
  }

  private Line getVerticalLine(Point p1, Point p2)
  {
    s1 := LineSegment(p1, p2)
    l1 := s1.toLine
    k1 := l1.perpendicularK
    p := s1.middlePoint
    vl1 := Line.makePk(p, k1)

    return vl1
  }
}