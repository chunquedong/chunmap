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
** MoveToCommand
**
@Js
class MoveToCommand : CCommand
{
  private Float x
  private Float y
  private Float ox
  private Float oy
  private MapCtrl map

  new make(MapCtrl map, Float x, Float y)
  {
    this.map = map
    this.x = x
    this.y = y

    ox = map.view.center.x
    oy = map.view.center.y
  }

  override Void execute()
  {
    map.view.center = Coord(x,y)
  }

  override Void undo()
  {
    map.view.center = Coord(ox, oy)
  }

}

