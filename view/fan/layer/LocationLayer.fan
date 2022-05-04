//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using chunmapModel
using chunmapData
using chunmapRaster
using slanRecord

**
** LocationLayer display an GPS point
**
@Js
class LocationLayer : Layer
{
  ShapeFeature? position
  TableDef schema

  new make()
  {
    b := TableDefBuilder("Location", ShapeFeature#)
    {
      addColumn("bearing", Float#)
      addColumn("speed", Float#)
      addColumn("accuracy", Float#)
      addColumn("provider", Str#)
    }
    schema = b.build
  }

  override Envelope envelope() { Envelope(0f,0f,0f,0f) }

  override protected Void renderLayer(Int i, RenderEnv r)
  {
    if (position == null) return
    r.data = position
    r.symbolizer.tryDrawElem(r)
  }

  Void setLocation(Float x, Float y, Float z := 0f, Obj?[] attri := [,])
  {
    position = ShapeFeature(schema)
    {
      values = attri
      geometry = GeoPoint(Coord3D(x, y, z))
    }
  }
}