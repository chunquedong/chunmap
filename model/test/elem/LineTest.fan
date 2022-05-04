//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

internal class LineTest : Test
{
  Void testGetY()
  {
    // y:=4x+1
    Line l1 := Line(4f, 1f)
    Float y1 := l1.getY(2f)
    verifyEq(y1, 9f)
  }

  Void testGetX()
  {
    // y:=4x+1
    Point p1 := Coord(1f, 5f)
    Point p2 := Coord(-1f, -3f)
    Line l1 := Line.makePoints(p1, p2)
    Float x1 := l1.getX(9f)
    verify(x1.approx(2f))
  }

  Void testHorizontal()
  {
    // y:=5
    Point p1 := Coord(1f, 5f)
    Point p2 := Coord(-1f, 5f)
    Line l1 := Line.makePoints(p1, p2)
    Float x1 := l1.getX(9f)
    verify(x1.isNaN)

    Float y1 := l1.getY(10f)
    verify(y1.approx(5f))
  }

  Void testVertical()
  {
    // x:=1
    Point p1 := Coord(1f, 5f)
    Point p2 := Coord(1f, 0.5f)
    Line l1 := Line.makePoints(p1, p2)
    Float x1 := l1.getX(9f)

    verify(x1.approx(1f))

    Float y1 := l1.getY(10f)
    verify(y1.isNaN)
  }

  Void testCritical3()
  {
    // x:=1
    Point p1 := Coord(1f, 5f)
    Line l1 := Line.makePk(p1, Float.negInf)
    Float x1 := l1.getX(9f)
    verify(x1.approx(1f))

    Float y1 := l1.getY(10f)
    verify(y1.isNaN)
  }

  Void testCritical4()
  {
    Line l1 := Line(Float.posInf , 1f)

    // System.out.println(l1.getK)
    Float x1 := l1.getX(9f)
    verify(x1.approx(1f))

    Float y1 := l1.getY(10f)
    verify(y1.isNaN)
  }

  Void testPerpendicularK()
  {
    // y:=4x+1
    Coord p1 := Coord(1f, 5f)
    Coord p2 := Coord(-1f, -3f)
    Line l1 := Line.makePoints(p1, p2)
    Float k := l1.perpendicularK

    verify(k.approx(-0.25f))
  }

  Void testCrossCoordinate2D()
  {
    // y:=4x+1
    Point p1 := Coord(1f, 5f)
    Point p2 := Coord(-1f, -3f)
    Line l1 := Line.makePoints(p1, p2)

    // y:=x-1
    Line l2 := Line(1f, -1f)
    Point p := Coord(-2f / 3f, (-2f / 3f) - 1f)
    verify(p.equals(l1.crossPoint(l2)))
    verify(p.equals(l2.crossPoint(l1)))
  }

  Void testCriticalCrossCoordinate2D()
  {
    // y:=4x+1
    Point p1 := Coord(1f, 5f)
    Point p2 := Coord(1f, 3f)
    Line l1 := Line.makePoints(p1, p2)

    // y:=x-1
    Line l2 := Line(1f, -1f)
    Point p := Coord(1f, 0f)
    verify(p.equals(l1.crossPoint(l2)))
    verify(p.equals(l2.crossPoint(l1)))
  }

  Void testDistance()
  {
    // y:=x+1
    Line l := Line(1f, 1f)
    Point p := Coord(0f, 0f)
    Float d := l.distance(p)

    verify(d.approx(2f.sqrt / 2f))
  }

}