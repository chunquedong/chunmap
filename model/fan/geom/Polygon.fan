//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

**
** Geometry Polygon
**
@Js
class Polygon : Geometry
{
  Ring shell { private set }
  Ring[] holes { private set }

  new make(Ring shell, Ring[] holes := [,])
  {
    this.shell = shell
    this.holes = holes
  }

  ** all ring of this Polygon
  Int ringCount() { holes.size + 1 }

  **
  ** each ring
  **
  Void each(|Ring, Bool isShell| f)
  {
    f(shell, true)
    holes.each { f(it, false) }
  }

//////////////////////////////////////////////////////////////////////////
// Geometry
//////////////////////////////////////////////////////////////////////////

  override once Envelope envelope() { shell.envelope }

  override Geometry transform(|Point->Point| transf)
  {
    Ring lr := shell.transform(transf)
    Ring[] rs := holes.map { it.transform(transf) }
    return Polygon(lr, rs)
  }

  override Obj? eachPoint(|Point->Obj?| trace)
  {
    r := shell.eachPoint(trace)
    if (r != null) return r

    for (i:=0; i<holes.size; i++)
    {
      r2 := holes[i].eachPoint(trace)
      if (r2 != null) return r2
    }
    return null
  }

  override GeometryType geometryType() { GeometryType.polygon }

  override Geometry? getBoundary()
  {
    ps := holes.dup.insert(0, shell)
    return MultiLineString(ps)
  }

  override once Bool isValid()
  {
    if (!shell.isValid) return false

    allValid := holes.all { it.isValid }
    if (!allValid) return false

    hoelsNotContians := holes.any { !shell.containLineStringIn(it) }
    if (hoelsNotContians) return false

    n := holes.size
    for (i := 0; i < n; i++)
    {
      for (j := i + 1; j < n; j++)
      {
        r1 := holes[i]
        r2 := holes[j]

        if (r1.intersects(r2)) return false

        if (r1.containIn(r2.startPoint) || r2.containIn(r1.startPoint))
        {
          return false
        }
      }
    }
    return true
  }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  override Str toStr()
  {
    return "POLYGON " + toMyString
  }

  internal Str toMyString()
  {
    str := StrBuf()
    str.add("(")
    str.add(shell.toMyString)
    holes.each
    {
      str.add("," + it.toMyString)
    }
    str.add(")")
    return str.toStr
  }

  override Bool equals(Obj? obj)
  {
    if (this === obj) return true

    other := obj as Polygon
    if (other == null) return false

    if (!this.shell.equals(other.shell)) return false
    //TODO fixed the Obj[] == Ring[]
    return this.holes.equals(other.holes)
  }

  override Int hash() { shell.hash.xor(holes.hash.shiftl(16)) }
}

