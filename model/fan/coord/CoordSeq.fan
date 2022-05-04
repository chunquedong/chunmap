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
** Coordnate sequence is a list of points
**
@Js
@Serializable { simple = true }
mixin CoordSeq
{
  @Operator
  abstract Point get(Int i)

  abstract Point[] toList()

  abstract Int size()

  Point first() { get(0) }

  Point last() { get(size - 1) }

  **
  ** Create a new list which is the result of calling c for every item in this list
  **
  abstract CoordSeq map(|Point->Point| f)

  **
  ** iteration
  **
  abstract Void each(|Point,Int| f)

  **
  ** find first return true
  **
  abstract Point? find(|Point,Int->Bool| f)

  **
  ** Approximately equals
  ** see `sys::Float.approx`
  **
  virtual Bool approx(CoordSeq other, Float? tolerance := null)
  {
    if (this == other) return true
    if (this.size != other.size) return false

    for (i := this.size-1; i >= 0; i--)
    {
      if (!this.get(i).approx(other.get(i), tolerance)) return false
    }
    return true
  }

  override Bool equals(Obj? obj)
  {
    if (this === obj) return true

    that := obj as CoordSeq
    if (that == null) return false
    if (this.size != that.size) return false

    for (i := this.size-1; i >= 0; i--)
    {
      if (!this.get(i).equals(that.get(i))) return false
    }
    return true
  }

  ** prepare for WKT
  abstract internal Str toMyString()
}