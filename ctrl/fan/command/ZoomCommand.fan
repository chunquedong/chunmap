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
using chunmapModel
using vaseGraphics

**
** ZoomCommand
**
@Js
class ZoomCommand : CCommand
{
  private Float s
  private Float x
  private Float y
  private MapCtrl map

  new make(MapCtrl map, Float s, Float x, Float y)
  {
    this.map = map
    this.s = s
    this.x = x
    this.y = y
  }

  override Void execute()
  {
    map.view.zoom(s, x, y)
  }

  override Void undo()
  {
    map.view.zoom(1f / s, x, y)
  }

}

