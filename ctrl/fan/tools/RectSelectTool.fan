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
** Rect Select Proxy
**
@Js
internal class RectSelectToolProxy : RectangleTool
{
  private RectSelectTool tool
  new make(SelectTool tool) { this.tool = tool }
  protected override Void finished(Envelope envelope) { tool.finished(envelope) }
  protected override Void clicked(CEvent e) { tool.clicked(e) }
}

**
** Box Select the feature
**
@Js
class RectSelectTool : SelectTool
{

  private RectSelectToolProxy tool := RectSelectToolProxy(this)

  override Void onAdd(MapCtrl context)
  {
    super.onAdd(context)
    tool.onAdd(context)
  }

  override Void actionEvent(CEvent e)
  {
    tool.actionEvent(e)
  }

  internal Void finished(Envelope envelope)
  {
    env2 := envelope.transform(map.view.screen2World)
    select(env2.envelope)
  }
}