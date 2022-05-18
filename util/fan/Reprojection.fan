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
using chunmapView
using chunmapData

**
** Reprojection
**
@Js
class Reprojection
{

  static Void changeCrs(FeatureSet fc, SpatialRef target)
  {
    source := fc.metadata.crs
    if (source.srid == target.srid) return

    chain := TransformChain()

    if (source.srid != 0 && source.projection != null)
      chain.add(source.projection.getReverseTransform)
    if (target.srid != 0 && target.projection != null)
      chain.add(target.projection.getTransform)

    fc.each(Condition.empty) |Feature f|
    {
      s := f as ShapeFeature
      if (s != null)
      {
        s.geometry = s.geometry.transform(chain.trans)
      }
    }

    fc.metadata = Metadata
    {
       name = fc.metadata.name
       type = fc.metadata.type
       crs = target
    }
    fc.recalcuEnvelope
  }

  static Void changeMapCrs(LayerList layers, SpatialRef target)
  {
    layers.each |layer|
    {
      if (layer is VectorLayer)
      {
        VectorLayer vl := layer
        changeCrs(vl.dataSource, target)
      }
    }
    layers.recalcuEnvelope
  }
}