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
** BoxZoomInTool
**
@Js
class BoxZoomInTool : RectangleTool
{
  protected override Void finished(Envelope envelope)
  {
    if (envelope.width < 7f || envelope.height < 7f)
    {
      map.repaint
      return
    }

    newEnv := envelope.translate(map.view.screen2World)
    cmd := ExtentCommand(map, newEnv)
    map.executeCommand(cmd)
    map.refresh
  }
}

