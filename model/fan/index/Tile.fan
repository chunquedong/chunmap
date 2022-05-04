//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

**
** Tile
**
@Serializable
@Js
const class Tile
{
  const Int x
  const Int y
  const Int z

  new make(Int x, Int y, Int z)
  {
    this.x = x
    this.y = y
    this.z = z
  }

  override Int hash()
  {
    x.hash.xor(y.hash.shiftl(8)).xor(z.hash.shiftl(16))
  }

  override Bool equals(Obj? obj)
  {
    if (this === obj)  return true
    that := obj as Tile
    if (that == null) return false
    return this.x == that.x && this.y == that.y && this.z == that.z
  }

  override Str toStr() { "${x}_${y}_${z}" }

//////////////////////////////////////////////////////////////////////////
// key
//////////////////////////////////////////////////////////////////////////

  **
  ** get the Hilbert-curve key
  **
  Str toKey()
  {
    quadKey := StrBuf()
    for (i := z; i > 0; i--)
    {
      digit := '0'
      Int mask := 1.shiftl(i - 1)
      if ((x.and(mask)) != 0)
      {
        ++digit
      }
      if ((y.and(mask)) != 0)
      {
        ++digit
        ++digit
      }
      quadKey.add(digit.toChar)
    }
    return quadKey.toStr
  }

  **
  ** get tile by  Hilbert-curve key.
  **
  static Tile fromKey(Str key)
  {
    tileX := 0
    tileY := 0
    levelOfDetail := key.size
    for (Int i := levelOfDetail; i > 0; i--)
    {
      Int mask := 1.shiftl(i - 1)
      switch (key[levelOfDetail - i])
      {
        case '1':
          tileX = tileX.or(mask)

        case '2':
          tileY = tileY.or(mask)

        case '3':
          tileX = tileX.or(mask)
          tileY = tileY.or(mask)

        default:
          throw ArgErr("Invalid QuadKey digit sequence.")

        case '0':
      }
    }

    return Tile(tileX , tileY, levelOfDetail)
  }

}