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
** Point represent a coordinate in space
**
@Js
@Serializable { simple = true }
const mixin Point
{
  ** X coordinate
  abstract Float x()

  ** X coordinate
  abstract Float y()

  ** Z coordinate. if not be supperted will throw UnsupportedErr
  abstract Float z()

  ** has z coordinate
  abstract Bool is3D()

  **
  ** Approximately equal
  ** see `sys::Float.approx`
  **
  abstract Bool approx(Point r, Float? tolerance := null)

  **
  ** the distance of this to other
  **
  Float distance2D(Point other)
  {
    d1 := (this.x - other.x).pow(2f)
    d2 := (this.y - other.y).pow(2f)

    return (d1 + d2).sqrt
  }

  **
  ** this to p angle width x axis
  **
  Float angle(Point p)
  {
    dx := p.x - x
    dy := p.y - y
    if ( dx == 0f)
    {
      if (dy > 0f) return Float.pi / 2
      else return -Float.pi / 2
    }

    angle := (dy / dx).atan
    if (dx < 0f)
    {
      if (angle >0f) return -Float.pi + angle
      else if (angle <0f) return Float.pi + angle
    }
    return angle
  }
}