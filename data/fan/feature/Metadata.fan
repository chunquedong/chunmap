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

**
** Metadata
**
@Js
class Metadata
{
  Str name
  GeometryType type
  SpatialRef crs

  new make(|This| f) { f(this) }

  static Metadata defVal() {
    Metadata
    {
      it.name = "unknown"
      it.type = GeometryType.none
      it.crs = SpatialRef.wgs84
    }
  }
}