//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using chunmapModel
using slanRecord

**
** Shape is a feature with geometry
**
@Js
mixin Shape : Feature
{
  abstract Geometry? geometry()
  abstract Obj? get(Int i)
  //abstract Obj? renderer
}

**
** ShapeFeature
**
@Js
class ShapeFeature : ArrayRecord, Shape
{
  override Obj? id
  override Envelope envelope() { geometry.envelope }

  override Geometry? geometry
  //override Obj? renderer

  new make(TableDef s) : super(s)
  {
  }
}