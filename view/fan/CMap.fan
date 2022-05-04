//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using vaseGraphics
using concurrent

using chunmapModel
using chunmapData

**
** Map is a core that manage the render.
**
@Js
class CMap
{
  ** extend some buffer region
  Int xBuffer { private set }
  Int yBuffer { private set }

  ** current viewport
  ViewPort view { private set }

  ** image be used to paint
  Image image { private set }

  ** map data
  LayerList layers := LayerList()

  Size size

  new make(Size size, Int xBuffer := 0, Int yBuffer := 0)
  {
    this.xBuffer = xBuffer
    this.yBuffer = yBuffer
    view = ViewPort(size.w, size.h, (xBuffer+1).toFloat, (yBuffer+1).toFloat)
    image = Image(Size(size.w + xBuffer + xBuffer, size.h + yBuffer + yBuffer))
    this.size = size
  }

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  ** set activeView's envelope to layers's envelope
  Void fullView() { view.envelope = layers.envelope }

  ** rerender the map
  Void renderToImg()
  {
    g := image.graphics
    g.brush = Color.white
    g.antialias = true
    g.fillRect(0, 0, image.size.w, image.size.h)
    g.transform(Transform2D.makeIndentity.translate(xBuffer.toFloat, yBuffer.toFloat))

    renv := RenderEnv()
    renv.g = g
    renv.view = view
    layers.render(renv)

    g.dispose
  }

  Void render(Graphics g)
  {
    g.brush = Color.white
    g.antialias = true
    g.fillRect(0, 0, image.size.w, image.size.h)

    renv := RenderEnv()
    renv.g = g
    renv.view = view
    layers.render(renv)
  }

  ** modify the size of map
  Void resetSize(Size size, Int xBuffer := 0, Int yBuffer := 0)
  {
    this.xBuffer = xBuffer
    this.yBuffer = yBuffer
    view.resetSize(size.w, size.h, (xBuffer+1).toFloat, (yBuffer+1).toFloat)
    image = Image(Size(size.w + xBuffer + xBuffer, size.h + yBuffer + yBuffer))
    this.size = size
  }
}