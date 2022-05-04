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
** simple draw polygon
**
@Js
class SimplePolygonSym : GeometrySym
{
  new make() {
    alpha = 180
  }
  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    if (geom isnot Polygon) return
    Polygon pg := geom

    g := r.g

    ls := pg.shell
    //TODO as result of holes, will change to path

    ps := DrawHelper.toIntArray(ls, r)
    if (fill)
    {
      if (g.brush != brush) g.brush = brush
      g.fillPolygon(ps)
    }

    if (stroke)
    {
      if (g.brush != strokeBrush) g.brush = strokeBrush
      if (g.pen != pen) g.pen = pen
      g.lineWidth = pixelLineWidth
      g.drawPolyline(ps)
    }
  }
}

