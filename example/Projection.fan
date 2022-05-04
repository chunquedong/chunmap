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
using vaseGui
using vaseWindow

using chunmapCtrl
using chunmapModel
using chunmapUtil
using chunmapView
using chunmapRaster
using chunmapData

class Main
{
  Void main()
  {
    //FwtToolkitEnv.init

    map := MapCanvas()

    layer0 := VectorLayer.makeUri(`data/cntry02/cntry02.shp`)
    map.ctrl.layers.add(layer0)

    blLayer := Graticules.createGrid
    map.ctrl.layers.add(blLayer)
    map.ctrl.fullView

    Bool mocator := false

    Frame
    {
      name = "chunmap"
      EdgeBox
      {
        center = map
        bottom = Button{ text = "reset"; onClick { map.ctrl.fullView.refresh }}
        top = Button{ text = "reprojection"; onClick
        {
          if (!mocator)
          {
            //cr := SpatialRef{ srid = 1234; name="temp"; projection = Mercator{ name ="mercator" }}
            cr := Gcj02.gcj02Mercator
            Reprojection.changeMapCrs(map.ctrl.layers, cr)
            map.ctrl.fullView.refresh
            mocator = true
          }
          else
          {
            Reprojection.changeMapCrs(map.ctrl.layers, SpatialRef.defVal)
            map.ctrl.fullView.refresh
            mocator = false
          }
        }}
      },
    }.show
  }
}