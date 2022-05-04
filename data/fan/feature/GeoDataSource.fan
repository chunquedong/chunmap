//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-12-07  Jed Young  Creation
//

using chunmapModel
using slanRecord

**
** GeoDataSource
**
@Js
mixin GeoDataSource
{
  abstract Void each(Condition condition, |Feature| filter)
  abstract Feature? find(Condition condition, |Feature->Bool| filter)

  abstract Envelope envelope()
  abstract Metadata metadata()
  abstract TableDef schema()
}

@Js
const class Condition
{
  static const Condition empty := Condition {}
  const Envelope? envelope
  const Float? scale
  const Int? w
  const Int? h

  new make(|This| f) { f(this) }
}

