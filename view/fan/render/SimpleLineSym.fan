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
** simple draw line
**
@Js
class SimpleLineSym : GeometrySym
{

  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    LineString? ls
    if (geom is LineString) {
        ls = geom
    }
    else if (geom is Polygon) {
        ls = (geom as Polygon).shell
    }
    else {
        return
    }

    g := r.g
    if (g.brush != strokeBrush) g.brush = strokeBrush
    if (g.pen != pen) g.pen = pen
    g.lineWidth = pixelLineWidth

    g.drawPolyline(DrawHelper.toIntArray(ls, r))
  }
}