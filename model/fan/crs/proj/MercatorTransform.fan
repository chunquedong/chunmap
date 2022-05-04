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
** MercatorTransform
**
@Js
internal const class MercatorTransform
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
    b := p.y.toRadians //latitude
    l := p.x.toRadians //longitude

    y := k * lntan(b, e)
    x := k * (l - l0)

    //limit
    if (y > Mercator.maxDis)
    {
      y = Mercator.maxDis
    }
    else if (y < -Mercator.maxDis)
    {
      y = -Mercator.maxDis
    }

    return Coord(x, y)
  }

  private Float lntan(Float b, Float e)
  {
    d := (Float.pi / 4 + b / 2).tan *
         ((1 - e * b.sin) / (1 + e * b.sin)).pow(e / 2)
    return d.log
  }

  const |Point p->Point| trans := #convert.func.bind([this])
}