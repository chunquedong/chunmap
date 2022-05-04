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
** Earth ellipsoid
**
@Js
const class Spheroid
{
  const Str name
  const Float a
  const Float b
  const Float e
  const Float e2

  new make(Str name, Float a, Float b)
  {
    if (a < b) throw ArgErr("a must lagger then b")

    this.name = name
    this.a = a
    this.b = b

    e = calculateE
    e2 = calculateE2
  }

  private Float calculateE()
  {
    (1f - (b / a).pow(2f)).sqrt
  }

  private Float calculateE2()
  {
    ((a / b).pow(2f) - 1f).sqrt
  }
}