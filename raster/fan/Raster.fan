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
using vaseGraphics
using chunmapModel

**
** Raster
**
@Js
mixin Raster : Feature
{
  abstract Image? image()
}

**
** Image Raster
**
@Js
class ImageRaster : Raster
{
  override Image? image
  override Obj? id
  override Envelope envelope

  new make(|This| f) { f(this) }
}