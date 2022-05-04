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
using chunmapRaster

**
** General Symbolizer
**
@Js
class GeneralSym : Symbolizer
{
  RasterSym rasterSym := RasterSym{}
  SimplePointSym pointSym := SimplePointSym{}
  SimpleLineSym lineSym := SimpleLineSym{}
  SimplePolygonSym polygonSym := SimplePolygonSym{}
  
  override Bool beginRender(RenderEnv r) {
    rasterSym.beginRender(r)
    pointSym.beginRender(r)
    lineSym.beginRender(r)
    polygonSym.beginRender(r)
    return super.beginRender(r)
  }
  
  override Void endRender(RenderEnv r) {
    rasterSym.endRender(r)
    pointSym.endRender(r)
    lineSym.endRender(r)
    polygonSym.endRender(r)
  }

  override Void drawElem(RenderEnv r)
  {
    if(r.data is Shape)
    {
      Shape shape := r.data
      drawGeometry(shape.geometry, r)
    }
    else if(r.data is Raster)
    {
      rasterSym.drawElem(r)
    }
  }

//////////////////////////////////////////////////////////////////////////
// Draw Geometry
//////////////////////////////////////////////////////////////////////////

  private Void drawGeometry(Geometry geo, RenderEnv r) { selectDraw(geo, r) }

  private Void selectDraw(Geometry geo, RenderEnv r)
  {
    if (geo is GeoPoint) pointSym.drawGeometry(geo, r)
    else if (geo is LineString) lineSym.drawGeometry(geo, r)
    else if (geo is Polygon) polygonSym.drawGeometry(geo, r)
    else if (geo is GeometryCollection)
    {
      GeometryCollection geoCollection := geo
      geoCollection.each { drawGeometry(it, r) }
    }
    else throw UnsupportedErr()
  }
}