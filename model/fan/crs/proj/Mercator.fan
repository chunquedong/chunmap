//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**
** Mercator Projection
**
@Js
const class Mercator : Projection
{
  **
  ** maximum latitude equals to half of width
  **
  const static Float maxDis := 20037508.3427892f

  ** radius of earth
  const static Float r := 6378137f

  new make() : super.make("Mercator")
  {
  }

  override |Point->Point| getReverseTransform()
  {
     s := spheroid
     return MercatorReTrans(s.a, s.b, s.e, s.e2, 0f, 0f).trans
  }

  override |Point->Point| getTransform()
  {
     s := spheroid
     return MercatorTransform(s.a, s.b, s.e, s.e2, 0f, 0f).trans
  }

  private Spheroid spheroid()
  {
    if (cs != null && cs.spheroid != null) return cs.spheroid
    else return Spheroid("circle", r, r)
  }

  static Float calculateK(Float a, Float b, Float e2, Float b0)
  {
    fz := a.pow(2f) / b
    fm := (1 + e2.pow(2f) * b0.cos.pow(2f)).sqrt
    r := (fz / fm) * b0.cos
    return r
  }
}