//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-30  Jed Young  Creation
//

using vaseGraphics
using vaseGui::DisplayMetrics
using chunmapModel
using chunmapData
using chunmapRaster

**
** draw geometry
**
@Js
abstract class GeometrySym : Symbolizer
{
  Pen pen := Pen.defVal
  Brush brush := DrawHelper.randomColor
  Brush strokeBrush := DrawHelper.randomColor

  Float lineWidth := 3.0
  Bool fill := true
  Bool stroke := true
  Bool deCollection := true

  Int size := 15
  
  @Transient protected Float pixelLineWidth
  @Transient protected Int pixelSize

  override Bool beginRender(RenderEnv r) {
    pixelLineWidth = DisplayMetrics.cur.dpToPixel(lineWidth).toFloat
    pixelSize = DisplayMetrics.cur.dpToPixel(size.toFloat)
    return super.beginRender(r)
  }

  override Void drawElem(RenderEnv r)
  {
    if(r.data isnot Shape) return
    Shape shp := r.data

    geom := shp.geometry
    if (deCollection && geom is GeometryCollection)
    {
      (geom as GeometryCollection).each { drawGeometry(it, r) }
    }
    else
    {
      drawGeometry(geom, r)
    }
  }

  abstract Void drawGeometry(Geometry geom, RenderEnv r)
}