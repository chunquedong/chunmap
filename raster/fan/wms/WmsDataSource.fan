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
using concurrent

**
** Web Map Service DataSource
**
@Js
@Serializable { simple = true }
class WmsDataSource : RasterDataSource
{
  private const Uri uri
  private const Str version := "1.1.1"
  private const |->|? onLoaded
  private const ImageCache cache
  override const Str name = "wms"

  new make(Uri uri, |->|? onLoaded := null) { this.cache = MemCache(); this.uri = uri; this.onLoaded = onLoaded }

  override Str toStr() { uri.toStr }
  static WmsDataSource fromStr(Str s)
  {
    uri := s.toUri
    |->|? onLoaded := Actor.locals["chunmapTaster.TileDataSource.callback"]
    return WmsDataSource(uri, onLoaded)
  }

  override Void each(Condition condition, |Feature| f)
  {
    f(getRaster(condition.envelope, condition.w, condition.h))
  }

  private Raster getRaster(Envelope envelop, Int w, Int h)
  {
    raster := ImageRaster
    {
      it.image = getImage(envelop, w, h)
      it.id = envelop.toStr + w.toStr + h.toStr
      it.envelope = envelop
    }
    return raster
  }

  private Image? getImage(Envelope envelop, Int w, Int h)
  {
    parameters := "${uri}?SERVICE=WMS&VERSION=${version}&REQUEST=GetMap&BBOX=${envelop2String(envelop)}"+
                  "&FORMAT=image/png&WIDTH=${w}&HEIGHT=${h}"

    name := parameters
    image := cache.get(name)
    if (image != null) return image
    if (cache.contains(name)) return null

    cache.set(name, null)
    uri := parameters.toUri

    //TODO fix it
    //Gfx2.setEngine("SWT")
    image = Image.fromUri(uri)
    {
      cache.set(name, it)
      if(onLoaded != null) onLoaded()
    }
    return null
  }

  private Str envelop2String(Envelope env) {
    return "" + env.minX + "," + env.minY + "," + env.maxX + "," + env.maxY
  }

  override Envelope envelope()
  {
    // TODO wms envelope
    return Envelope(92.37175137842411f, 31.01897163866643f, 108.8716402641172f, 44.2188827472209f)
  }
}