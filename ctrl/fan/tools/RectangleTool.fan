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

using chunmapModel

**
** Draw Rectangle Tool
**
@Js
abstract class RectangleTool : Tool
{
  private Int x := 0
  private Int y := 0
  private Bool draging := false
  protected Envelope? envelope
  Color color := Color.black

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
    if (!draging) return

    envelope = Envelope(x.toFloat, y.toFloat, e.x.toFloat, e.y.toFloat)
    minx := envelope.minX.toInt
    miny := envelope.minY.toInt
    width := envelope.width.toInt
    height := envelope.height.toInt

    map.paintOverlay |g|
    {
      g.drawRect(minx, miny, width, height)
    }

    e.consumed = true
    map.repaint
  }

  private Void mousePressed(CEvent e)
  {
    draging = true
    x = e.x
    y = e.y
    e.consumed = true
    envelope = null
  }

  private Void mouseReleased(CEvent e)
  {
    if (draging)
    {
      if (envelope != null && (e.x != x || e.y != y))
      {
        finished(envelope)
      }
      else
      {
        clicked(e)
      }

      //reset
      draging = false
      x = 0
      y = 0
      envelope = null
      e.consumed = true
    }
  }

  protected abstract Void finished(Envelope envelope)

  protected virtual Void clicked(CEvent e) {}
}

