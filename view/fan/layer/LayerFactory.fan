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
//using chunmapView
using chunmapData
using slanRecord

**
** LayerFactory
**
@Js
class LayerFactory
{

//////////////////////////////////////////////////////////////////////////
// createGeometryLayer
//////////////////////////////////////////////////////////////////////////

  static VectorLayer createGeometryLayer(Geometry[] gs, GeometryType type)
  {
    //if (gs.size == 0) return null

    // get Envelope
    eb := EnvelopeBuilder.makeNone
    gs.each |g|
    {
      eb.merge(g.envelope)
    }

    table := TableDefBuilder("Geometry", ShapeFeature#)
    table.addColumn("id", Int#)
    table.addColumn("name", Str#)
    table.addColumn("value", Int#)
    schema := table.build
    
    fc := FeatureList(eb.toEnvelope, schema)

    fc.metadata = Metadata
    {
      it.name = "unknown"
      it.type = type
      it.crs = SpatialRef.defVal
    }

    gs.each |g, i|
    {
      Feature f := ShapeFeature(schema)
      {
        geometry = g
        id = i
      }
      fc.add(f)
    }

    return VectorLayer.makeFeatureSet(fc)
  }

  static Void addGeometryToLayer(VectorLayer geomLayer, Geometry g, Obj?[]? values := null)
  {
    FeatureSet ds := geomLayer.dataSource
    Feature f := ShapeFeature(ds.schema)
    {
      if (values != null) it.values = values
      geometry = g
    }
    ds.add(f)
  }
}