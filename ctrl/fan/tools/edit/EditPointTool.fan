//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2012-05-12  Jed Young  Creation
//

using vaseGraphics
using vaseGui::DisplayMetrics
using chunmapModel
using chunmapData
using chunmapUtil
using chunmapView
using slanRecord

**
** Edit the point geometry
**
@Js
class EditPointTool : Tool
{
  private Bool draging := false
  Int tolerance := DisplayMetrics.cur.dpToPixel(14.0)
  Float snapTolerance := DisplayMetrics.cur.dpToPixel(8.0).toFloat
  |Int,Int|? onPointEdited
  |->|? onMissEdit

  Int x
  Int y
  Shape? shapeFeature
  
  private Void snap(CEvent e) {
    point := Coord(e.x.toFloat, e.y.toFloat)
    
    for (i := map.layers.size-1; i>=0; --i) {
        lyr := map.layers.get(i) as VectorLayer
        if (lyr == null) continue
        res := lyr.snap(map.map.view, point, snapTolerance, shapeFeature.geometry)
        if (res != null) {
            e.x = res.x.toInt
            e.y = res.y.toInt
            break
        }
    }
  }

  override Void actionEvent(CEvent e)
  {
    switch (e.type)
    {
      case EventType.press: mousePressed(e)
      case EventType.release: mouseReleased(e)
      case EventType.move: mouseDragged(e)
      default: return
    }
  }

  private Void mouseDragged(CEvent e)
  {
    if (draging)
    {
      snap(e)
      map.paintOverlay |g|
      {
        g.drawLine(x, y, e.x, e.y)
      }
      e.consumed = true
      map.repaint
    }
  }

  private Void mousePressed(CEvent e)
  {
    if ((e.x-x).abs < tolerance && (e.y-y).abs < tolerance)
    {
      draging = true
      e.consumed = true
    }
    else
    {
      onMissEdit?.call
      draging = false
    }
  }

  private Void mouseReleased(CEvent e)
  {
    if (draging && (e.x != x || e.y != y))
    {
      snap(e)
      onPointEdited?.call(e.x, e.y)
      x = e.x
      y = e.y
      draging = false
    }
  }
}