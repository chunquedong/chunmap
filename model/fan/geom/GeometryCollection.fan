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
** GeometryCollection
**
@Js
class GeometryCollection : Geometry
{
  Geometry[] geometrys  { private set }

  new make(Geometry[] geometrys) { this.geometrys = geometrys }

  Int size() { geometrys.size }

  Geometry get(Int i) { geometrys[i] }

  Void each(|Geometry, Int| f) { geometrys.each(f) }

//////////////////////////////////////////////////////////////////////////
// Geometry
//////////////////////////////////////////////////////////////////////////

  override Geometry transform(|Point->Point| transf)
  {
    rs := geometrys.map { it.transform(transf) }
    return make(rs)
  }

  override Obj? eachPoint(|Point->Obj?| trace)
  {
    Int size := geometrys.size
    for (i:=0; i<size; ++i)
    {
      r := get(i).eachPoint(trace)
      if (r != null) return r
    }
    return null
  }

  override once Envelope envelope()
  {
    ep := EnvelopeBuilder.makeNone()
    geometrys.each { ep.merge(it.envelope) }
    return ep.toEnvelope
  }

  override Geometry? getBoundary()
  {
    rs := geometrys.map { it.getBoundary }
    return make(rs)
  }

  override GeometryType geometryType() { GeometryType.geometryCollection }

  override once Bool isValid()
  {
    return geometrys.all { it.isValid }
  }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  protected Str toMyString(Str name, |Geometry->Str| f)
  {
    str := StrBuf()
    str.add(name)
    str.add("(")
    each |g|
    {
      str.add(f(g) + ",")
    }
    str.remove(-1)
    str.add(")")
    return str.toStr
  }

  override Str toStr() { toMyString("GEOMETRYCOLLECTION ", |g| { g.toStr } ) }

  override Bool equals(Obj? obj)
  {
    if (this === obj) return true

    p := obj as GeometryCollection
    if (p == null) return false

    return this.geometrys.equals(p.geometrys)
  }

  override Int hash() { geometrys.hash }
}

