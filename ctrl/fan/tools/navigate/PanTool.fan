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
using vaseWindow

**
** Tool
**
@Js
class PanTool : Tool
{
  private Int x := 0
  private Int y := 0
  private Bool draging := false

  Bool mustRightButton := false

  override Void actionEvent(CEvent e)
  {
    if (mustRightButton && e.button != 3 && e.type != EventType.move) return

    if (e.id == CEvent.touchEvent)
    {
      MotionEvent me := e.rawEvent
      if (me.pointers != null && me.pointers.size > 1)
      {
        draging = false
        x = 0
        y = 0
        return
      }
    }

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
      dx := e.x - x
      dy := e.y - y

      map.transform = Transform2D.makeTranslate(dx.toFloat, dy.toFloat)
      e.consumed = true
      map.repaint
    }
  }

  private Void mousePressed(CEvent e)
  {
    draging = true
    x = e.x
    y = e.y
    e.consumed = true
  }

  private Void mouseReleased(CEvent e)
  {
    if (draging)
    {
      view := map.view

      dx := e.x - x
      dy := e.y - y

      w := view.width / 2f - dx
      h := view.height / 2f - dy

      xx := view.x2World(w)
      yy := view.y2World(h)

      cmd := MoveToCommand(map, xx, yy)
      map.executeCommand(cmd)

      draging = false

      map.refresh
      e.consumed = true
    }
    x = 0
    y = 0
  }
}

