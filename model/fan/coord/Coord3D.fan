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
** `Coord` width three coordinate
**
@Js
@Serializable { simple = true }
const class Coord3D : Point
{
  ** X coordinate
  const override Float x

  ** X coordinate
  const override Float y

  ** Z coordinate
  const override Float z

  ** has z coordinate
  override Bool is3D() { true }

  ** Default instance is 0, 0, 0.
  const static Coord3D defVal := Coord3D(0f, 0f, 0f)

  ** Construct with x, y, z.
  new make(Float x, Float y, Float z)
  {
    this.x = x
    this.y = y
    this.z = z
  }

  **
  ** Approximately equal
  ** see `sys::Float.approx`
  **
  override Bool approx(Point other, Float? tolerance := null)
  {
    r := other as Coord3D
    if (this == r) return true;
    return x.approx(r.x, tolerance) &&
           y.approx(r.y, tolerance) &&
           z.approx(r.z, tolerance)
  }

  **
  ** the distance 3D
  **
  Float distance3D(Point other)
  {
    dx := (this.x - other.x).pow(2f)
    dy := (this.y - other.y).pow(2f)
    dz := (this.z - other.z).pow(2f)

    return (dx + dy + dz).sqrt
  }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static Coord3D? fromStr(Str s, Bool checked := true)
  {
    try
    {
      ss := s.split(',')
      return make(ss[0].toFloat, ss[1].toFloat, ss[2].toFloat)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Coord3D: $s")
    return null
  }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  ** Return hash of x , y and z.
  override Int hash() { super.hash.xor(z.hash.shiftl(16)) }

  ** Return if obj is same Point value.
  override Bool equals(Obj? obj)
  {
    if (this === obj)  return true

    that := obj as Coord3D
    if (that == null) return false
    return this.x == that.x && this.y == that.y && this.z == that.z
  }

  override Int compare(Obj obj)
  {
    that := obj as Point
    c := this.x <=> that.x
    if (c != 0) return c
    cy := this.y <=> that.y
    if (cy != 0) return cy
    return this.z <=> that.z
  }

  ** Return '"x,y,z"'
  override Str toStr() { "$x,$y,$z" }
}