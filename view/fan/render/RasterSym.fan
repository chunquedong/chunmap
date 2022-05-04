//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-30  Jed Young  Creation
//

using vaseGraphics

using chunmapModel
using chunmapData
using chunmapRaster

**
** draw raster
**
@Js
class RasterSym : Symbolizer
{
  Bool debug = false

  override Void drawElem(RenderEnv r)
  {
    if (r.data isnot Raster) return

    Raster tile := r.data
    env := tile.envelope.translate(r.view.world2Screen)
    image := tile.image
    g := r.g

    if ( image != null && image.isReady)
    {
      x := (env.minX-0.5f).toInt
      y := (env.minY-0.5f).toInt
      w := (env.width+1.5f).toInt
      h := (env.height+1.5f).toInt
      //echo("env: $env")

      src := Rect(0, 0, image.size.w, image.size.h)
      dest := Rect(x, y, w, h)
      g.copyImage(image, src, dest)
      
    }

    if (debug) {
      x := (env.minX).toInt
      y := (env.minY).toInt
      w := (env.width).toInt
      h := (env.height).toInt
      g.brush = Color.black
      g.drawRect(x, y, w, h)
    }
  }
}