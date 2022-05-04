//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using chunmapModel
using chunmapData
using vaseGraphics
using concurrent

**
** TileCache
**
@Js
const class TileCache
{
  const MemCache cache
  const FileCache? fileCache

  new make(Uri root := `./chunmapTiles/`)
  {
    cache = MemCache()
    //if (!Env.cur.isJs) fileCache = FileCache(root)
  }

  private Str toPath(Tile t)
  {
    "$t.z/$t.x/$t.y" + ".png"
  }

  Void setMaxSize(Int capacity) {
    cache.setMaxSize(capacity)
  }

  Image? get(Tile t)
  {
    k := t.toStr
    if (cache.contains(k)) {
      //echo("hit cache")
      return cache.get(k)
    }

    if (fileCache != null) {
      k2 := toPath(t)
      if (fileCache.contains(k2))
      {
        tile := fileCache.get(k2)
        cache.set(k, tile)
        return tile
      }
    }
    return null
  }

  Void set(Tile t, Image? img)
  {
    cache.set(t.toStr, img)
    if (img != null)
      fileCache?.set(toPath(t), img)
  }

  Void set2(Int x, Int y, Int z, Image? img)
  {
    t := Tile(x, y, z)
    cache.set(t.toStr, img)
    if (img != null)
      fileCache?.set(toPath(t), img)
  }

  Bool contains(Tile t)
  {
    k := t.toStr
    if (cache.contains(k)) return true

    if (fileCache != null) {
      k2 := toPath(t)
      if (fileCache.contains(k2)) return true
    }
    return false
  }
}