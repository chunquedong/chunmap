//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using concurrent
using vaseGraphics
using vaseGui
using vaseWindow

using chunmapCtrl
using chunmapModel
using chunmapUtil
using chunmapView
using chunmapRaster

const class Main
{
  Void main()
  {
    //FwtToolkitEnv.init
    map := MapCanvas()

    unsafeMap := Unsafe<MapCanvas>(map)
    |->| callback := |->|{Toolkit.cur.callLater(0) |->| { unsafeMap.val.ctrl.refresh; }}

    //r := "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png"
    r := "http://webrd01.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=8&x={x}&y={y}&z={z}"
    //r := "https://rt2.map.gtimg.com/tile?z={z}&x={x}&y={y}&type=vector&styleid=3"
    //r := "http://webst04.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}"
    layer := RasterLayer.makeDataSource(GDataSource{ name = "gaode"; uri = r; onLoaded = callback })
    map.ctrl.layers.add(layer)
    layer.bindPreferScale(map.ctrl.view)

    map.ctrl.fullView

    Frame
    {
      name = "chunmap"
      EdgeBox
      {
        center = map
        bottom = Button{ text = "reset"; onClick { map.ctrl.fullView.refresh }}
      },
    }.show
  }
}