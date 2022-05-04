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
** FileCache
**
const class FileCache : ImageCache
{
  const Uri path

  new make(Uri path)
  {
    if (!path.isDir) throw ArgErr("path must be dir")
    file := path.toFile
    if (!file.exists) file.create
    this.path = path
  }

  override Image? get(Str name)
  {
    uri := path.plusName(name)
    return Image.fromUri(uri)
  }

  override Void set(Str name, Image? img)
  {
    if (img == null) return
    file := path.plusName(name).toFile
    out := file.out
    img->save(out)
    out.close
  }

  override Bool contains(Str key)
  {
    file := path.plusName(key).toFile
    return file.exists
  }

  override Void remove(Str key)
  {
    file := path.plusName(key).toFile
    file.delete
  }

  override Void clear()
  {
    path.toFile.listFiles.each { it.delete }
  }
}