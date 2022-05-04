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
using chunmapModel
using chunmapData
using web
using concurrent

**
** TileDataSource
**
@Js
@Serializable
class TileDataSource : RasterDataSource
{
  const Uri uri
  @Transient const |->|? onLoaded
  @Transient private const TileCache cache
  @Transient private const Grid grid
  //private const Size size
  @Transient private const Float originLevelScale
  override const Str name

  new make(|This| f)
  {
    f(this)
    this.cache = TileCache(`./$name/`)
    Str metadata := WebClient(uri).getStr
    Str[] metas := metadata.split(';')
    this.grid = Grid.fromStr(metas[0])
    size := Size(metas[1])

    xScale := size.w / grid.width
    yScale := size.h / grid.height
    originLevelScale = xScale.min(yScale)

    if (onLoaded == null) {
      onLoaded = Actor.locals["chunmapTaster.TileDataSource.callback"]
    }
    if (onLoaded == null) {
      throw ArgErr("onLoaded is not setting")
    }
  }

  new makeMeta(Str name, Uri uri, Size size, Envelope env, |->|? onLoaded := null)
  {
    this.name = name
    this.cache = TileCache()
    this.uri = uri
    this.onLoaded = onLoaded
    this.grid = Grid(env)

    xScale := size.w / grid.width
    yScale := size.h / grid.height
    originLevelScale = xScale.min(yScale)
  }

  override Str toStr() { uri.toStr }

  override Void each(Condition condition, |Feature| f)
  {
    z := Grid.scaleTozoom(condition.scale, originLevelScale)
    list := grid.findTiles(condition.envelope, z)
    list.each |tile|
    {
      raster := ImageRaster
      {
        it.image = getImage(tile)
        //it.id = key
        it.envelope = grid.tileEnvelope(tile)
      }
      f(raster)
    }
  }

  private Image? getImage(Tile tile)
  {
    if (cache.contains(tile)) return cache.get(tile)

    cache.set(tile, null)
    uri := `${this.uri}?z=$tile.z&x=$tile.x&y=$tile.y`

    //Gfx2.setEngine("SWT")

    Int x := tile.x
    Int y := tile.y
    Int z := tile.z
    img := Image.fromUri(uri)
    {
      cache.set2(x, y, z, it)
      if(onLoaded != null) onLoaded()
    }
    return null
  }

  override Envelope envelope()
  {
    grid.envelope
  }

  override Float preferScale(Float scale) { Grid.preferScale(scale, originLevelScale) }
}