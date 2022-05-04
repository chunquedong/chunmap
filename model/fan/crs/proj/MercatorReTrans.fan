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
** MercatorReTrans
**
@Js
internal const class MercatorReTrans
{
  private const Float k
  private const Float l0
  private const Float e

  new make(Float a, Float b, Float e, Float e2, Float b0, Float l0)
  {
    this.k = Mercator.calculateK(a, b, e2, b0)
    this.l0 = l0
    this.e = e
  }

  Point convert(Point p)
  {
    B := calculateB(p.y)
    L := getL(p.x)

    b := B.toDegrees //longitude
    l := L.toDegrees //latitude

    return Coord(l, b)
  }

  private Float calculateB(Float x)
  {
    b := getB(0f, x)
    for (i := 0; i < 20; i++)
    {
      Float bb := getB(b, x)
      if ((bb - b).abs < 0.01f) return bb
      b = bb
    }
    return b
  }

  private Float getB(Float b, Float x)
  {
    B := (Float.pi/2) - 2 * exp(b,x).atan
    return B
  }

  private Float exp(Float b, Float x)
  {
    (-(x / k)).exp
           * (
                (e / 2)* (
                          (1 - e * b.sin)
                          / (1 + e * b.sin)
                         ).log
             ).exp
  }

  private Float getL(Float y) { (y / k) + l0 }

  const |Point p->Point| trans := #convert.func.bind([this])
}