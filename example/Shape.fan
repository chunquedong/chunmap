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
using chunmapData
using chunmapRaster

class Main
{
  Void main()
  {
    //Gfx2.setEngine("AWT")
    //FwtToolkitEnv.init

    map := MapCanvas()

    uri := (`data/cntry02/cntry02.shp`)
    layer0 := VectorLayer.makeUri(uri)
    map.ctrl.layers.add(layer0)
    map.ctrl.fullView

    Frame
    {
      name = "chunmap"
      EdgeBox
      {
        center = map
        bottom = Button
        {
          text = "reset";
          onClick
          {
            map.ctrl.fullView.refresh
            /*
            lyr := layer0 as VectorLayer
            lyr.dataSource.each(Condition.empty) |f|
            {
              buf := StrBuf()
              buf.out.writeObj(f, ["indent":2])
              echo(buf.toStr)
            }
            */
          }
        }
      },
    }.show
  }
}