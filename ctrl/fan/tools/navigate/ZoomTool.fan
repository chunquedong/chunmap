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

**
** ZoomTool
**
@Js
class ZoomTool : Tool
{
  Float minLimit := 1e-5f
  Float maxLimit := 1E7f

  override Void actionEvent(CEvent e)
  {
    if (e.id != CEvent.mouseWheel) return
    mouseWheelMoved(e)
  }

  private Void mouseWheelMoved(CEvent e)
  {
    x := map.view.x2World(e.x.toFloat)
    y := map.view.y2World(e.y.toFloat)

    if (e.delta == null || e.delta == 0) return
    s := (e.delta < 0) ? 2f : 0.5f

    if (s > 1f && map.view.scale*s > maxLimit) return
    if (s < 1f && map.view.scale*s < minLimit) return

    cmd := ZoomCommand(map, s, x, y)
    map.executeCommand(cmd)

    e.consumed = true
    map.refresh
  }
}

