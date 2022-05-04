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
using chunmapData
using chunmapUtil
using chunmapView
using slanRecord


**
** Pick and pan
**
@Js
class PickTool : SelectTool
{

  private Int x
  private Int y
  private PanTool panTool := PanTool()


  override Void onAdd(MapCtrl context)
  {
    super.onAdd(context)
    panTool.onAdd(context)
  }

  override Void actionEvent(CEvent e)
  {
    panTool.actionEvent(e)

    switch (e.type)
    {
      case EventType.press:
        x = e.x
        y = e.y
      case EventType.release:
        if ((e.x - x).abs < tolerance.toInt && (e.y - y).abs < tolerance.toInt)
        {
          clicked(e)
          x = -1
          y = -1
        }
      default: return
    }
  }

}