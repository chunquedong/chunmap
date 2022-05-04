//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

internal class AngleTest : Test
{
  Void testComputeAngle()
  {
    Point p1 := Coord(2f, 2f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(2f, 0f)

    Angle a := Angle(p1, p2, p3)
    Float d := a.calculateAngle
    verify(d.toDegrees.approx(45f))

    Angle a2 := Angle(p3, p2, p1)
    Float d2 := a2.calculateAngle
    verify(d2.toDegrees.approx(-45f))
  }

  Void testComputeAngle2()
  {
    Point p1 := Coord(1f, 0f)
    Point p2 := Coord(0f, 0f)
    Point p3 := Coord(2f, 0f)

    Angle a := Angle(p1, p2, p3)
    Float d := a.calculateAngle
    verify(d.toDegrees.approx(0f))

    Angle a2 := Angle(p2, p1, p3)
    Float d2 := a2.calculateAngle
    verify(d2.toDegrees.approx(180f))

  }
}