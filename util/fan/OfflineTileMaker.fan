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
using chunmapView
using vaseGraphics
using vaseWindow
using chunmapModel
using util
using chunmapRaster

**
** fan /home/yangjiandong/code/chunmap2/chunmap/util/fan/OfflineTileMaker.fan /home/yangjiandong/code/data/t/map4linux.cmp
**
class OfflineTileMaker : AbstractMain
{
  @Arg { help = "cmp file path" }
  File? path

  @Opt { help = "zoom level"; aliases=["l"] }
  Int level := 6

  @Opt { help = "out path"; aliases=["r"] }
  Str root := "./chunmapTiles/"

  Int width := 512

  private CMap? map
  private Grid? grid

  override Int run()
  {
    //using AWT
    //Gfx2.setEngine("AWT")
    //ToolkitEnv.init

    in := path.in
    layers := in.readObj
    in.close

    Envelope envelope := layers->envelope
    h := width * envelope.height / envelope.width
    size := Size(width, h.toInt)
    // renderMap
    map = CMap(size, 1, 1)
    map.layers = layers
    grid = Grid(envelope)

    level.times
    {
      echo("******************$level")
      saveRasterSet(grid.envelope, it)
    }

    return 0
  }

  private Void saveRasterSet(Envelope envelope, Int z)
  {
    list := grid.findTiles(envelope, z)
    list.each |tile|
    {
      echo(tile)
      save(tile)
    }
  }

  private Void save(Tile tile)
  {
    Str path := "$root$tile.z/$tile.x/"
    dir := path.toUri.toFile
    if (!dir.exists) dir.create

    image := getImage(tile)

    type := MimeType.forExt("png")

    file := "$path${tile.y}.png".toUri.toFile
    out := file.out
    image.save(out, "png")
    out.close
  }

  private Image getImage(Tile tile)
  {
    map.view.envelope = grid.tileEnvelope(tile)
    //map.fullView
    map.renderToImg
    return map.image
  }
}