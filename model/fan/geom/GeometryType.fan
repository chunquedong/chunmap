//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-17  Jed Young  Creation
//

**
** Type of Geometry
**
@Js
enum class GeometryType
{
  none(-1),
  point(0),
  lineString(1),
  polygon(2),
  multiPoint(0),
  multiLineString(1),
  multiPolygon(2),
  geometryCollection(3)

//////////////////////////////////////////////////////////////////////////

  **
  ** dimensionality
  **
  const Int dim

  private new make(Int dim) { this.dim = dim }
}

