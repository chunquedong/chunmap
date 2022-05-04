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
** ExtentCommand
**
@Js
class ExtentCommand : CCommand
{
  private Envelope oldEnvelope
  private Envelope envelope
  private MapCtrl map

  new make(MapCtrl map, Envelope envelope)
  {
    this.map = map
    this.envelope = envelope
    oldEnvelope = map.view.envelope
  }

  override Void execute()
  {
    map.view.envelope = envelope
  }

  override Void undo()
  {
    map.view.envelope = oldEnvelope
  }

}

