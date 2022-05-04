//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-29  Jed Young  Creation
//

using vaseGraphics

using chunmapModel
using chunmapView
using vaseGui::DisplayMetrics
using chunmapData

@Js
class PointTool : Tool
{
  |GeoPoint|? onCreateFinish
  private Int x := 0
  private Int y := 0
  private Bool click := false
  
  Float snapTolerance := DisplayMetrics.cur.dpToPixel(8.0).toFloat
  
  VectorLayer? editLayer

  override Void actionEvent(CEvent e)
  {
    switch (e.type)
    {
      case EventType.press:
        x = e.x
        y = e.y
        click = true
      case EventType.release:
        if (click && x == e.x && y == e.y)
        {
          mouseClicked(e)
        }
      case EventType.move:
        if (x != e.x || y != e.y)
        {
          click = false
        }
      default: return
    }
  }
  
  private Void snap(CEvent e) {
    point := Coord(e.x.toFloat, e.y.toFloat)
    
    for (i := map.layers.size-1; i>=0; --i) {
        lyr := map.layers.get(i) as VectorLayer
        if (lyr == null) continue
        res := lyr.snap(map.map.view, point, snapTolerance, null)
        if (res != null) {
            e.x = res.x.toInt
            e.y = res.y.toInt
            break
        }
    }
  }

  private Void mouseClicked(CEvent e)
  {
    snap(e)
    map.paintOverlay |g|
    {
      g.drawOval(x, y, 5, 5)
    }
    e.consumed = true
    map.repaint

    p := GeoPoint(map.view.x2World(x.toFloat),map.view.y2World(y.toFloat))
    finish(p)
  }

  private Void finish(GeoPoint p)
  {
    onCreateFinish?.call(p)
    
    if (editLayer != null) {
        FeatureSet ds := editLayer.dataSource
        Feature f := ShapeFeature(ds.schema)
        {
          geometry = p
        }
        cmd := CreateCommand(map, editLayer, f)
        map.executeCommand(cmd)
        map.refresh
    }
  }
}