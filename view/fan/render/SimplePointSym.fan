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
** simple draw point
**
@Js
class SimplePointSym : GeometrySym
{
  Int style := 0
  static const Int styleCircle := 0
  static const Int styleSquare := 1

  new make() {
    stroke = false
    deCollection = false
  }

  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    Float cx
    Float cy
    if (geom is GeoPoint) {
        GeoPoint p = geom
        cx = p.x
        cy = p.y
    }
    else {
        p := geom.envelope.center
        cx = p.x
        cy = p.y
    }

    size := pixelSize
    half := size / 2f
    x := r.view.x2Screen(cx) - half
    y := r.view.y2Screen(cy) - half

    g := r.g

    if (style == styleCircle)
    {
      if (fill)
      {
        if (g.brush != brush) g.brush = brush
        g.fillOval(x.toInt, y.toInt, size, size)
      }

      if (stroke)
      {
        if (g.brush != strokeBrush) g.brush = strokeBrush
        if (g.pen != pen) g.pen = pen
        g.lineWidth = pixelLineWidth
        g.drawOval(x.toInt, y.toInt, size, size)
      }
    }
    else if (style == styleSquare)
    {
      if (fill)
      {
        if (g.brush != brush) g.brush = brush
        g.fillRect(x.toInt, y.toInt, size, size)
      }

      if (stroke)
      {
        if (g.brush != strokeBrush) g.brush = strokeBrush
        if (g.pen != pen) g.pen = pen
        g.lineWidth = pixelLineWidth
        g.drawRect(x.toInt, y.toInt, size, size)
      }
    }
  }
}