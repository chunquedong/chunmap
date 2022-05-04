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
using vaseClient
using chunmapModel
using chunmapData
using concurrent
using web

**
** OSM datasource
**
@Js
class GDataSource : RasterDataSource
{
  ** global envelope
  @Transient
  override const Envelope envelope := Envelope(-Mercator.maxDis,
    -Mercator.maxDis, Mercator.maxDis, Mercator.maxDis)

  @Transient
  private const TileCache cache

  const Str uri
  override const Str name

  @Transient
  private const Str:Str requestHeaders

  @Transient
  private const ActorPool? actorPool

  @Transient
  const |->|? onLoaded

  @Transient
  private const Bool loadByStream

  const Bool isTms := false

  new make(|This| f)
  {
    f(this)
    this.cache = TileCache(`./$name/`)
    this.loadByStream = Actor.locals["chunmapTaster.GDataSource.loadByStream"] ?: false
    requestHeaders = this.typeof.pod.props(`requestHeaders.props`, 1min)

    if (onLoaded == null) {
      onLoaded = Actor.locals["chunmapTaster.TileDataSource.callback"]
    }
    if (onLoaded == null) {
      throw ArgErr("onLoaded is not setting")
    }

    if (!Env.cur.isJs) actorPool = ActorPool { maxThreads = 2 }
  }

  override Str toStr() { uri.toStr }

  ** get the tile envelope
  internal Envelope getEnvelope(Tile tile) { GEncode.getEnvelope(tile) }

  internal Image? getImage(Tile tile)
  {
    if (cache.contains(tile)) return cache.get(tile)

    cache.set(tile, null)
    uri := getUri(tile.x, tile.y, tile.z)

    //Gfx2.setEngine("SWT")
    if (!Env.cur.isJs) ImageLoader.init
    //echo("loadByStream:$loadByStream: uri:${uri}")
    test := cache.contains(tile)
    //echo("load $tile.x,$tile.y,$tile.z $test")

    Int x := tile.x
    Int y := tile.y
    Int z := tile.z
    if (!loadByStream)
    {
      [Str:Obj?]? options := null
      cCache := cache
      cOnLoaded := onLoaded
      img := Image.fromUri(uri, options)
      {
        cCache.set2(x, y, z, it)
        if(cOnLoaded != null) cOnLoaded()
      }
    }
    else
    {
      loadImage(tile, uri)
    }

    return null
  }

  private Void loadImage(Tile tile, Uri uri)
  {
    actor := Actor(actorPool) |msg|
    {
      c := WebClient(uri)
      c.reqMethod = "GET"
      requestHeaders.each |v, k|
      {
        c.reqHeaders[k] = v
      }
      c.writeReq
      c.readRes
      if (c.resCode == 200)
      {
        in := c.resIn
        img := Image.fromStream(in)
        cache.set(tile, img)
        if(onLoaded != null) onLoaded()
      }
      else
      {
        echo("request fail: $uri")
      }
      return null
    }
    actor.send("load image")
  }

  override Void each(Condition condition, |Feature| f)
  {
    list := GEncode.getTileSet(condition.envelope, condition.scale)
    cache.setMaxSize((list.size*2).toInt)
    list.each
    {
      it.setDataSource(this)
      f(it)
    }
  }

  private Uri getUri(Int x, Int y, Int z)
  {
    if (isTms) {
      y = Math.pow(2.0, z.toFloat).toInt - 1 - y
    }
    str := uri.toStr.replace("{x}", x.toStr).replace("{y}", y.toStr).replace("{z}", z.toStr)
    return str.toUri
  }

  override Float preferScale(Float scale) { GEncode.preferScale(scale) }

  static GDataSource fromStr(Str s)
  {
    GDataSource { uri = s; name = s }
  }
}