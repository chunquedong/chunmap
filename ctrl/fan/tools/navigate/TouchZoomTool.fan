//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-05  Jed Young  Creation
//

using vaseGraphics
using vaseMath
using vaseWindow
using chunmapModel

**
** TouchZoom
**
@Js
class TouchZoomTool : Tool
{
  Float startDis := -1f
  Float lastDis := -1f
  Float startX := -1f
  Float startY := -1f

  private Void reset()
  {
    startDis = -1f
    lastDis = -1f
    startX = -1f
    startY = -1f
  }

  override Void actionEvent(CEvent ce)
  {
    if (ce.id != CEvent.touchEvent) return

    MotionEvent? e := ce.rawEvent as MotionEvent
    if (e == null || e.pointers == null) return
    if (e.pointers.size == 2)
    {
      if (!(e.pointers[0].id == MotionEvent.moved) && !(e.pointers[1].id == MotionEvent.moved))
      {
        if (lastDis < 0f) startZoom(e.pointers)
        else endZoom(e)
        e.consumed = true
      }
      else
      {
        multiTouchZoom(e.pointers)
        e.consumed = true
      }
    }
  }

  private Void startZoom(MotionEvent[] e)
  {
    p1_x := e[0].x
    p1_y := e[0].y
    p2_x := e[1].x
    p2_y := e[1].y

    //distance
    d1 := (p1_x - p2_x).pow(2).toFloat
    d2 := (p1_y - p2_y).pow(2).toFloat
    startDis = (d1 + d2).sqrt

    //center point
    startX = (p1_x + p2_x)/2f
    startY = (p1_y + p2_y)/2f
  }

  private Void endZoom(MotionEvent e)
  {
    s := lastDis / startDis
    x := map.view.x2World(startX.toFloat)
    y := map.view.y2World(startY.toFloat)

    echo("$s, $x, $y")
    cmd := ZoomCommand(map, s, x, y)
    map.executeCommand(cmd)

    map.refresh
    reset
  }

  private Void multiTouchZoom(MotionEvent[] e)
  {
    p1_x := e[0].x
    p1_y := e[0].y
    p2_x := e[1].x
    p2_y := e[1].y

    //distance
    d1 := (p1_x - p2_x).pow(2).toFloat
    d2 := (p1_y - p2_y).pow(2).toFloat
    lastDis = (d1 + d2).sqrt

    //scale
    s := lastDis / startDis

    //draw
    map.transform = Transform2D.makeTranslate(startX, startX) *
                         Transform2D.makeScale(s, s) * 
                         Transform2D.makeTranslate(-startX, -startX)
    map.repaint
  }
}