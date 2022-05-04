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
using chunmapModel::Point as CPoint

**
** Edit the node of line string
**
@Js
class EditLineNodeTool : Tool
{
  private Bool draging := false
  private Int? x
  private Int? y

  Float tolerance := DisplayMetrics.cur.dpToPixel(14.0).toFloat
  Float snapTolerance := DisplayMetrics.cur.dpToPixel(8.0).toFloat
  |CoordSeqBuf|? onNodeEdited
  |->|? onMissEdit

  LineString? curLine
  {
    set
    {
      &curLine = it
      if (it != null) {
        coordSeqBuf = CoordSeqBuf(it.points)
      }
    }
  }
  
  Shape? shapeFeature

  protected Int? curNodeIndex
  protected CoordSeqBuf? coordSeqBuf



//////////////////////////////////////////////////////////////////////////
// Event dispatching
//////////////////////////////////////////////////////////////////////////

  override Void actionEvent(CEvent e)
  {
    if (curLine == null) return

    switch (e.type)
    {
      case EventType.press:
        mousePressed(e)
      case EventType.release:
        mouseReleased(e)
      case EventType.move:
        mouseDragged(e)
      default: return
    }
  }
  
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

//////////////////////////////////////////////////////////////////////////
// Edit node
//////////////////////////////////////////////////////////////////////////

  private Void mousePressed(CEvent e)
  {
    draging = true
    x = e.x
    y = e.y
    e.consumed = true

    wp := map.view.screen2World.call(Coord(x.toFloat, y.toFloat))
    r := selectGeometryNode(wp)
    if (!r)
    {
      curNodeIndex = coordSeqBuf.tryPutPoint(wp, map.view.dis2World(tolerance))
      //echo(curNodeIndex)
    }
  }

  private Bool selectGeometryNode(CPoint wp)
  {
    size := coordSeqBuf.size
    curNodeIndex = null
    for (i:=0; i<size; ++i)
    {
      p := coordSeqBuf.get(i)
      dis := p.distance2D(wp)
      if (dis < map.view.dis2World(tolerance*1.5))
      {
        curNodeIndex = i
        break
      }
    }
    if (curNodeIndex == null) return false
    return true
  }

  private Void mouseDragged(CEvent e)
  {
    if (draging && curNodeIndex != null)
    {
      snap(e)
      x := e.x
      y := e.y
      point := (map.view.screen2World.call(Coord(x.toFloat, y.toFloat)))
      coordSeqBuf.set(curNodeIndex, point)

      map.paintOverlay |g|
      {
        g.drawPolyline(toIntArray(coordSeqBuf))
      }
      e.consumed = true
      map.repaint
    }
  }

  protected virtual PointArray toIntArray(CoordSeqBuf coordSeqBuf)
  {
    ps := PointArray((coordSeqBuf.size))
    n := coordSeqBuf.size
    i:=0
    for (; i<n; ++i)
    {
      p := coordSeqBuf.get(i)
      ps.setX(i, map.view.x2Screen(p.x).toInt)
      ps.setY(i, map.view.y2Screen(p.y).toInt)
    }
    return ps
  }

  private Void mouseReleased(CEvent e)
  {
    if (x == e.x && y == e.y)
    {
      if (curNodeIndex == null)
      {
        onMissEdit?.call
      }
      else if (e.count == 2)
      {
        coordSeqBuf.removeAt(curNodeIndex)
        finished(coordSeqBuf)
        //echo("delete node")
      }
    }
    else if (draging && curNodeIndex != null)
    {
      coordSeqBuf.deleteOverPoint(1e-8f)
      finished(coordSeqBuf)
    }

    curNodeIndex = null
    draging = false
    x = null
    y = null
  }

  protected virtual Void finished(CoordSeqBuf coordSeqBuf)
  {
    if (coordSeqBuf.size > 1)
    {
      onNodeEdited?.call(coordSeqBuf)
    }
  }
}