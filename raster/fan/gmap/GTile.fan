//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using vaseGraphics
using chunmapData
using chunmapModel

@Js
class GTile : Raster
{
  private GDataSource? datasource
  Tile tile

  ** for load the image
  Tile? proxy

  new make(Int x, Int y, Int z)
  {
    tile = Tile(x, y, z)
  }

  Void setDataSource(GDataSource datasource)
  {
    this.datasource = datasource
  }

  override Envelope envelope() { datasource.getEnvelope(this.tile) }

  override Image? image() { datasource.getImage(proxy ?: tile) }

  override Obj? id() { toStr }

}