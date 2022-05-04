//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-09  Jed Young  Creation
//

**
** Angle contains three point
**
@Js
const class Angle
{
  ** start point
  const Point p1

  ** corner point
  const Point p2

  ** end point
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
  ** Angle of three points.
  ** clockwise return positive value,
  ** anticlockwise return negative value,
  ** other return 0
  **
  Float calculateAngle()
  {
    Float a := F2(p1.x, p2.x, p3.x, p1.y, p2.y, p3.y)

    if (clockwise >= 0) return a
    else return -a
  }

  **
  ** the ring(p1,p3,p2)
  ** clockwise return 1,
  ** anticlockwise return -1,
  ** collinear return 0
  **
  Int clockwise()
  {
    v1 := Vector.makePoints(p2, p1)
    v2 := Vector.makePoints(p2, p3)
    d := v1.parallelogramArea(v2)

    if (d > 0f)// clockwise
      return -1
    else if (d == 0f)// collinear
      return 0
    else // anticlockwise
      return 1
  }


//////////////////////////////////////////////////////////////////////////
// Helper
//////////////////////////////////////////////////////////////////////////

  // |
  // | author: chunquedong 2009-05
  // |

  **
  ** distance of two points
  **
  private Float F1(Float x1, Float x2, Float y1, Float y2)
  {
    d1 := (x1 - x2).pow(2f)
    d2 := (y1 - y2).pow(2f)
    d  := (d1 + d2).sqrt
    return d
  }

  **
  ** Angle of three points
  **
  private Float F2(Float x1, Float x2, Float x3, Float y1, Float y2, Float y3)
  {
    FenZi := F201(x1, x2, x3, y1, y2, y3)
    FenMu := F202(x1, x2, x3, y1, y2, y3)

    if (FenMu == 0f) return 0f

    b := FenZi / FenMu
    if (b.abs > 1f) return 0f

    return b.acos
  }

  private Float F201(Float x1, Float x2, Float x3, Float y1, Float y2, Float y3)
  {
    r1 := F2011(x1, x2, x3)
    r2 := F2011(y1, y2, y3)
    return r1 + r2
  }

  private Float F2011(Float a1, Float a2, Float a3)
  {
    return (a1 - a2) * (a3 - a2)
  }

  private Float F202(Float x1, Float x2, Float x3, Float y1, Float y2, Float y3)
  {
    r1 := F1(x1, x2, y1, y2)
    r2 := F1(x3, x2, y3, y2)
    return r1 * r2
  }
}