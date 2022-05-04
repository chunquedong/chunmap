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
** draw the node of geometry
**
@Js
class GeometryNodeSym : GeometrySym
{
  new make() { brush = Color.blue; size = 10; }

  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    g := r.g
    if (g.brush != brush) g.brush = brush
    if (g.pen != pen) g.pen = pen
    g.lineWidth = pixelLineWidth
    half := pixelSize / 2f

    geom.eachPoint |chunmapModel::Point p->Obj?|
    {
      x := r.view.x2Screen(p.x) - half
      y := r.view.y2Screen(p.y) - half
      g.drawRect(x.toInt, y.toInt, pixelSize, pixelSize)
      return null
    }
  }
}