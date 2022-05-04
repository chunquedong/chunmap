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
** MemCache
**
@Js
const class MemCache : ImageCache
{
  const Unsafe<Cache> cache
  const Lock lock = Lock()

  new make(Int capacity := 200)
  {
    c := Cache(capacity)
    this.cache = Unsafe<Cache>(c)
  }

  Void setMaxSize(Int capacity) {
    lock.sync {
      if (capacity > cache.val.maxSize) {
        echo("cache maxSize:$capacity")
        cache.val.maxSize = capacity
      }
      lret null
    }
  }

  override Image? get(Str name)
  {
    lock.sync {
      cache.val.get(name)
    }
  }

  override Void set(Str name, Image? img)
  {
    lock.sync {
      cache.val.set(name, img)
      lret null
    }
  }

  override Bool contains(Str key) {
    lock.sync {
      cache.val.containsKey(key)
    }
  }

  override Void remove(Str key) {
    lock.sync {
      cache.val.remove(key)
      lret null
    }
  }

  override Void clear() {
    lock.sync {
      cache.val.clear
      lret null
    }
  }
}