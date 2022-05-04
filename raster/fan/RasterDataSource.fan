//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using chunmapData
using slanRecord
using vaseGraphics
using chunmapModel

**
** RasterDataSource
**
@Js
@Serializable { simple = true }
abstract class RasterDataSource : GeoDataSource
{
  override Feature? find(Condition condition, |Feature->Bool| filter) { throw UnsupportedErr() }

  override Metadata metadata = Metadata { it.name = "Raster"; type = GeometryType.none; it.crs = SpatialRef.webMercator }
  override TableDef schema = TableDefBuilder("Raster", ShapeFeature#).build

  virtual Float preferScale(Float scale) { return scale }

  abstract Str name()
}