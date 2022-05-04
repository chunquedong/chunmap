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
** Spatial Reference System
**
@Js
const class SpatialRef
{
  const Str name
  const Int srid
  const Datum? datum
  const Spheroid? spheroid
  const Projection? projection
  const Int? unit

  new make(|This| f) { f(this) }

//////////////////////////////////////////////////////////////////////////
// constant value
//////////////////////////////////////////////////////////////////////////

  static const SpatialRef webMercator := SpatialRef { srid = 3857; name = "WebMercator"; projection = Mercator() }
  static const SpatialRef wgs84 := SpatialRef { srid = 4326; name = "WGS84" }
  static const SpatialRef unknown := SpatialRef { srid = 0; name = "unknown" }
  static const SpatialRef defVal := wgs84
}