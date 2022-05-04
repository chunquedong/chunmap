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
class LineTool : Tool
{
  protected Bool draging := false

  Color color := Color.black
  protected CoordSeqBuf lse := CoordSeqBuf()
  |Geometry|? onCreateFinish
  
  VectorLayer? editLayer
  
  Float snapTolerance := DisplayMetrics.cur.dpToPixel(8.0).toFloat

  override Void actionEvent(CEvent e)
  {
    switch (e.type)
    {
      case EventType.press:
        if (e.button != 3) mousePressed(e)
      case EventType.release:
        if (e.count == 2) mouseReleased(e)
      case EventType.move: mouseMove(e)
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

  protected virtual Void mouseMove(CEvent e)
  {
    if (!draging) return
    snap(e)
    map.paintOverlay |g|
    {
      g.brush = color
      g.lineWidth = 2.0
      g.drawPolyline(toIntArray(e.x, e.y))
    }
    e.consumed = true
    map.repaint
  }

  protected virtual PointArray toIntArray(Int x, Int y)
  {
    ps := PointArray((lse.size+1))
    n := lse.size
    i:=0
    for (; i<n; ++i)
    {
      p := lse.get(i)
      ps.setX(i, map.view.x2Screen(p.x).toInt)
      ps.setY(i, map.view.y2Screen(p.y).toInt)
    }
    k := n
    ps.setX(k, x)
    ps.setY(k, y)
    return ps
  }

  private Void mousePressed(CEvent e)
  {
    draging = true
    snap(e)
    x := e.x
    y := e.y
    lse.add(map.view.screen2World.call(Coord(x.toFloat, y.toFloat)))
  }

  private Void mouseReleased(CEvent e) {
    if (draging)
    {
      // reset
      draging = false
      snap(e)
      lse.deleteOverPoint(1e-8f)
      finished(lse)
      lse = CoordSeqBuf()
    }
  }

  protected virtual Void finished(CoordSeqBuf lse)
  {
    if (lse.size > 1)
    {
      ls := LineString(lse.toCoordSeq)
      onCreateFinish?.call(ls)
      
        if (editLayer != null) {
            FeatureSet ds := editLayer.dataSource
            Feature f := ShapeFeature(ds.schema)
            {
              geometry = ls
            }
            cmd := CreateCommand(map, editLayer, f)
            map.executeCommand(cmd)
            map.refresh
        }
    }
  }
}