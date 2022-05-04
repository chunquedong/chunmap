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
** Float number precision
**
@Js
@Serializable
const class Precision
{
  **
  ** float precision scale.
  ** the min unit will be 1/scale.
  **
  const Float? scale

  static const Precision none := makeNone()
  private new makeNone() {}

  new make(Float scale) { this.scale = scale }

  Bool isNone() { scale == null }

  ** new value will be calculate by '(d * scale).round / scale'
  Float format(Float d)
  {
    if (d.isNaN) return d
    if (scale != null) return (d * scale).round / scale
    return d
  }

  **
  ** Transform p to this precision
  **
  const |Point p->Point| trans := |Point p->Point|
  {
    if (p.is3D) return Coord3D(format(p.x), format(p.y), format(p.z))
    return Coord(format(p.x), format(p.y))
  }

  ** compare the precision scale
  override Int compare(Obj obj)
  {
    if (this.scale == null)
    {
      if ((obj as Precision).scale == null) return 0
      else return 1
    }
    else return scale <=> obj
  }
}