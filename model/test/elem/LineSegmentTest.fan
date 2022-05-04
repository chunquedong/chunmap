//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

internal class LineSegmentTest : Test
{
  Void testIntersection()
  {
    Point p1 := Coord(10f, 10f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(0f, 10f)
    Point p4 := Coord(10f, 0f)
    Point p5 := Coord(5f, 5f)
    Point p6 := Coord(-1f, -1f)
    Point p7 := Coord(-1f, 7f)

    LineSegment lseg1 := LineSegment(p1, p2)

    LineSegment lseg2 := LineSegment(p3, p4)
    Point p := (Point)lseg1.intersection(lseg2)
    Point ep := Coord(5f, 5f)
    verify(p.equals(ep))

    LineSegment lseg3 := LineSegment(p5, p6)
    Point[] l := (Point[])lseg1.intersection(lseg3)
    verifyEq(l, (Point[Coord(0f, 0f), Coord(5f, 5f)]))

    LineSegment lseg4 := LineSegment(p6, p7)
    verify(lseg1.intersection(lseg4) == null)
  }

  Void testIntersection2()
  {
    Point p1 := Coord(3f, 1f)
    Point p2 := Coord(4f, 0f)
    Point p3 := Coord(1f, 0.5f)
    Point p4 := Coord(3f, 0.5f)

    LineSegment lseg1 := LineSegment(p1, p2)
    LineSegment lseg2 := LineSegment(p3, p4)

    verify(lseg1.intersection(lseg2) == null)

  }

  Void testOnLineSegment()
  {
    Point p1 := Coord(10f, 10f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(0f, 10f)
    Point p4 := Coord(10f, 10f)
    Point p5 := Coord(5f, 5f)

    LineSegment lseg1 := LineSegment(p1, p2)

    Bool b1 := lseg1.onLineSegment(p5)
    Bool b2 := lseg1.onLineSegment(p3)
    Bool b3 := lseg1.onLineSegment(p4)
    verify(b1)
    verify(!b2)
    verify(b3)
  }

  Void testDingBiFenDian()
  {
    Point p1 := Coord(10f, 10f)
    Point p2 := Coord(20f, 20f)
    Point p3 := Coord(12f, 12f)
    LineSegment lseg1 := LineSegment(p1, p2)

    verify(lseg1.middlePoint.equals(lseg1.separatedPoint(1f)))
    verify(p3.equals(lseg1.separatedPoint(0.25f)))
  }

  Void testContainLineSegment()
  {
    Point p1 := Coord(10f, 10f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(5f, 5f)
    LineSegment lseg1 := LineSegment(p1, p2)
    LineSegment lseg2 := LineSegment(p2, p3)
    verify(lseg1.containsLineSegment(lseg2))
    verify(lseg1.containsLineSegment(lseg1))
  }

  Void testDistance2D()
  {
    Point p1 := Coord(10f, 10f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(5f, 5f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 0f)
  }

  Void testDistance2D2()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(10f, 0f)
    Point p3 := Coord(5f, 0f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 0f)
  }

  Void testDistance2D3()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(10f, 0f)
    Point p3 := Coord(5f, 1f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 1f)
  }

  Void testDistance2D4()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(0f, 10f)
    Point p3 := Coord(0f, 1f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 0f)
  }

  Void testDistance2D5()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(0f, 10f)
    Point p3 := Coord(1f, 1f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 1f)
  }

  Void testDistance2D6()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(0f, 10f)
    Point p3 := Coord(-1f, 0f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 1f)
  }

  Void testDistance2D7()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(10f, 0f)
    Point p3 := Coord(15f, 0f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 5f)
  }

  Void testDistance2D8()
  {
    Point p1 := Coord(0f, 0f)
    Point p2 := Coord(10f, 10f)
    Point p3 := Coord(6f, 6f)
    LineSegment lseg1 := LineSegment(p1, p2)
    dis := lseg1.distance2D(p3)
    verify(dis == 0f)
  }
}