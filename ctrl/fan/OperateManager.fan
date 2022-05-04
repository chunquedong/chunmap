//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using chunmapView
using vaseGraphics

**
** OperateManager
**
@Js
class OperateManager
{
  private Tool[] backTools := [,]
  Tool currentTool { set { ((Tool?)&currentTool)?.onRemove; &currentTool = it; &currentTool.onAdd(mapBox) } }
  private MapCtrl mapBox
  private CommandStack stack := CommandStack()

//////////////////////////////////////////////////////////////////////////
// paint
//////////////////////////////////////////////////////////////////////////

  new make(MapCtrl mapBox)
  {
    this.mapBox = mapBox

    pan := PanTool()
    pan.mustRightButton = true
    addBackTool(TouchZoomTool())
    addBackTool(pan)
    addBackTool(ZoomTool())
    currentTool = PanTool()
  }

//////////////////////////////////////////////////////////////////////////
// Command
//////////////////////////////////////////////////////////////////////////

  Void executeCommand(CCommand cmd)
  {
    cmd.execute
    stack.push(cmd)
  }

  Void undo() { stack.undo }

  Void redo() { stack.redo }

//////////////////////////////////////////////////////////////////////////
// Plugs
//////////////////////////////////////////////////////////////////////////

  Void setAllInactive()
  {
    backTools.each |p|
    {
      p.isActive = false
    }
  }

  Void onEvent(CEvent e)
  {
    r := backTools.find |p|
    {
      if (p.isActive)
      {
        p.actionEvent(e)
        if (e.consumed) return true
      }
      return false
    }

    if (r == null)
    {
      currentTool.actionEvent(e)
    }
  }

  Void addBackTool(Tool p)
  {
    backTools.add(p)
    p.onAdd(mapBox)
  }

  Void removeBackTool(Tool p)
  {
    backTools.remove(p)
    p.onRemove
  }

  Tool? getBackTool(Str id)
  {
    backTools.find { it.id == id }
  }
}

