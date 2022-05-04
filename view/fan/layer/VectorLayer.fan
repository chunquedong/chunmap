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
using chunmapData

**
** VectorLayer
**
@Js
class VectorLayer : Layer
{
  GeoDataSource? dataSource { private set }

  new makeFeatureSet(FeatureSet fc)
  {
    dataSource = fc
    name = fc.schema.name
    dim := fc.metadata.type.dim
    switch (dim)
    {
    case 0:
      symbolizers = [SimplePointSym{}]
    case 1:
      symbolizers = [SimpleLineSym{}]
    case 2:
      symbolizers = [SimplePolygonSym{}]
    default:
      symbolizers = [GeneralSym{}]
    }
  }
  
  new make() {
  }

  static VectorLayer makeUri(Uri uri)
  {
    VectorLayer.makeFeatureSet(FeatureList.fromStr(uri.toStr))
  }

  protected override Void renderLayer(Int i, RenderEnv r)
  {
    cond := Condition
    {
      it.envelope = r.view.getBufferEnvelope
    }

    dataSource.each(cond) |f|
    {
      r.data = f
      r.symbolizer.tryDrawElem(r)
    }
  }

  override Envelope envelope() {
    dataSource.envelope
  }
  
  Point? snap(ViewPort viewPort, Point point, Float tolerance, Geometry? except = null)
  {
    features := Feature[,]
    cond := Condition
    {
      it.envelope = viewPort.envelope
    }
    lyr := this
 
    if (!lyr.isVisible) return null
    
    woldPoint := Coord(viewPort.x2World(point.x), viewPort.y2World(point.y))
    
    Point? found
    dataSource.each(cond) |f| {
      shp := f as Shape
      if (shp != null && shp.geometry != null)
      {
        if (found != null) return
        if (shp.geometry == except) return
        found = shp.geometry.eachPoint |p|{
            dis := woldPoint.distance2D(p)
            if (viewPort.dis2Screen(dis) < tolerance) {
                return p
            }
            return null
        }
      }
    }

    if (found != null) {
        return Coord(viewPort.x2Screen(found.x), viewPort.y2Screen(found.y))
    }
    return null
  }
}