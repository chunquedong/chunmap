//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-05  Jed Young  Creation
//


**
** Tool is a interactive object with map
**
@Js
abstract class Tool
{
  MapCtrl? map

  virtual Void onAdd(MapCtrl context) { map = context }

  virtual Void onRemove() {}

  Str id := "" //Uuid().toStr

  Bool isActive := true

  abstract Void actionEvent(CEvent e)
}

