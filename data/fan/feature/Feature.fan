//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using chunmapModel

**
** Feature represents a record of dataset. It's a super inteface of Shape and Raster
**
@Js
mixin Feature
{
  abstract Envelope envelope()
  abstract Obj? id()
}

