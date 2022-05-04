//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

internal class TriangleTest : Test
{
  Void testComputeArea2()
  {
    Point p1 := Coord(2f, 2f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(2f, 0f)
    Triangle tria := Triangle(p1, p2, p3)
    Float are := tria.area

    verify(are.approx(2f))
  }

  Void testComputeOuterCenter()
  {
    Point p1 := Coord(2f, 2f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(2f, 0f)
    Triangle tria := Triangle(p1, p2, p3)
    Point p := tria.exteriorCenter
    Point ep := Coord(1f, 1f)
    verify(p.equals(ep))
  }

  Void testComputeCenter()
  {
    Point p1 := Coord(-1f, 0f)
    Point p2 := Coord(1f, 0f)
    Point p3 := Coord(0f, 2f)
    Triangle tria := Triangle(p1, p2, p3)
    Point p := tria.coordCenter
    Point ep := Coord(0f, 2f / 3f)
    verify(p.equals(ep))
  }
}