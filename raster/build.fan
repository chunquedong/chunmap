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
    podName = "chunmapRaster"
    summary = "chunmap raster"
    depends =
    [
      "sys 2.0", "std 1.0",
      "concurrent 1.0",
      "vaseGraphics 1.0",
      "web 1.0",
      "slanRecord 1.0",
      "chunmapModel 1.0",
      "chunmapData 1.0",
      "vaseClient 1.0",
    ]
    srcDirs =
    [
      `fan/`,
      `fan/gmap/`,
      `fan/wms/`,
      `fan/tile/`,
      `fan/cache/`
    ]
    resDirs =
    [
      `requestHeaders.props`
    ]
  }
}