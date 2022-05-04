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
** Coord(Coordinate) is light weight point
**
@Js
@Serializable { simple = true }
const class Coord : Point
{
  ** X coordinate
  const override Float x

  ** X coordinate
  const override Float y

  ** Z coordiante. If not be supperted will throw UnsupportedErr
  override Float z() { throw UnsupportedErr("z coordiante not supperted") }

  ** has Z coordinate
  override Bool is3D() { false }

  ** Default instance is 0, 0.
  const static Coord defVal := Coord(0f, 0f)

  ** Construct with x, y.
  new make(Float x, Float y)
  {
    this.x = x
    this.y = y
  }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static Coord? fromStr(Str s, Bool checked := true)
  {
    try
    {
      comma := s.index(",")
      return make(s[0..<comma].trim.toFloat, s[comma+1..-1].trim.toFloat)
    }
    catch {}
    if (checked) throw ParseErr("Invalid Coord: $s")
    return null
  }

//////////////////////////////////////////////////////////////////////////
// override
//////////////////////////////////////////////////////////////////////////

  **
  ** Approximately equal
  ** see `sys::Float.approx`
  **
  override Bool approx(Point r, Float? tolerance := null)
  {
    if (this == r) return true
    return x.approx(r.x, tolerance) && y.approx(r.y, tolerance)
  }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  ** Return hash of x and y.
  override Int hash() { x.hash.xor(y.hash.shiftl(16)) }

  ** Return if obj is same Point value.
  override Bool equals(Obj? obj)
  {
    if (this === obj)  return true

    that := obj as Point
    if (that == null) return false
    return this.x == that.x && this.y == that.y
  }

  override Int compare(Obj obj)
  {
    that := obj as Point
    c := this.x <=> that.x
    if (c != 0) return c
    return this.y <=> that.y
  }

  ** Return '"x,y"'
  override Str toStr() { "$x,$y" }
}