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
** ImageCache
**
@Js
const mixin ImageCache
{
  abstract Image? get(Str name)

  abstract Void set(Str name, Image? img)

  abstract Bool contains(Str key)

  abstract Void remove(Str key)

  abstract Void clear()
}