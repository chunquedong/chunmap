//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using vaseGraphics

using chunmapModel
using chunmapData


**
** RenderEnv
**
@Js
class RenderEnv
{
  Graphics? g
  Feature? data
  ViewPort? view
  Symbolizer? symbolizer
}