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
** Vector is a direction with length
**
@Js
const class Vector
{
  **
  ** from origin point to this point
  **
  const private Coord3D point

  **
  ** make from coordinate
  **
  new make(Float x, Float y, Float z)
  {
    point = Coord3D(x, y, z)
  }

  **
  ** make from points
  **
  new makePoints(Point p1, Point p2)
  {
    x := p2.x - p1.x
    y := p2.y - p1.y

    z := 0f
    if (p1.is3D && p2.is3D)
      z = p2.z - p1.z

    point = Coord3D(x, y, z)
  }

  Float x() { point.x }

  Float y() { return point.y }

  Float z() { return point.z }

  override Str toStr() { "Vector(point.x point.y)" }

//////////////////////////////////////////////////////////////////////////
// arithmetic
//////////////////////////////////////////////////////////////////////////

  **
  ** The parallelogram algebra area
  **
  Float parallelogramArea(Vector v2)
  {
    Vector v1 := this
    return v1.x * v2.y - v2.x * v1.y // a1b2-a2b1
  }

  **
  ** addition
  **
  Vector add(Vector v2)
  {
    x := this.x + v2.x
    y := this.y + v2.y
    z := this.z + v2.z

    return Vector(x, y, z)
  }

  **
  ** scalar multiplication
  **
  Vector scalarMultiply(Float n)
  {
    x := n * x
    y := n * y
    z := n * z

    return Vector(x, y, z)
  }

  **
  ** included angle
  **
  Float angle(Vector v2)
  {
    Point p := Coord(0f, 0f)
    angle := Angle(point, p, v2.point)
    return angle.calculateAngle
  }

  **
  ** general product
  **
  Vector outerProduct(Vector v2)
  {
    x := y * v2.z - v2.y * this.z // b1c2-b2c1
    y := this.z * v2.x - this.x * v2.z // c1a2-a1c2
    z := this.x * v2.y - v2.x * this.y // a1b2-a2b1

    return Vector(x, y, z)
  }

  **
  ** scalar product
  **
  Float innerProduct(Vector v2)
  {
    x := this.x * v2.x
    y := this.y * v2.y
    z := this.z * v2.z

    return x + y + z
  }
}