#! /usr/bin/env fan
//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-10  Jed Young  Creation
//

class Build : build::BuildPod
{
  new make()
  {
    podName = "chunmapModel"
    summary = "chunmap model"
    depends =
    [
      "sys 2.0", "std 1.0",
      "util 1.0"
    ]
    srcDirs =
    [
      `fan/`,
      `fan/algorithm/`,
      `fan/coord/`,
      `fan/crs/`,
      `fan/crs/proj/`,
      `fan/elem/`,
      `fan/geom/`,
      `fan/io/`,
      `fan/index/`,
      `test/`,
      `test/elem/`,
      `test/geom/`,
      `test/algorithm/`,
      `test/io/`,
      `test/index/`,
    ]
  }
}