#! /usr/bin/env fan
//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

class Build : build::BuildPod
{
  new make()
  {
    podName = "chunmapCtrl"
    summary = "chunmap Ctrl"
    depends =
    [
      "sys 2.0", "std 1.0",
      "chunmapView 1.0",
      "chunmapModel 1.0",
      "chunmapData 1.0",
      "chunmapUtil 1.0",
      "slanRecord 1.0",
      "vaseMath 1.0",
      "vaseGraphics 1.0",
      "vaseWindow 1.0",
      "vaseGui 1.0",
    ]
    srcDirs =
    [
      `fan/`,
      `fan/command/`,
      `fan/tools/navigate/`,
      `fan/tools/create/`,
      `fan/tools/edit/`,
      `fan/tools/`,
    ]
  }
}