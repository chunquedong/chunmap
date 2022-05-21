//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-29  Jed Young  Creation
//

using vaseGraphics
using chunmapModel
using chunmapData
using chunmapUtil
using chunmapView
using slanRecord


**
** Abstract Select Tool
**
@Js
abstract class SelectTool : Tool
{
  **
  ** tolerance of select
  **
  Float tolerance := 12f

  **
  ** Call back on selected change
  **
  |Feature[]|? onSelectChange

  **
  ** filter the layer
  **
  |Layer->Bool| layerFilter := |Layer layer->Bool|
  {
    return (layer.isSelectable)
  }

  **
  ** Can select multi feature
  **
  Bool multiSelect := true

  **
  ** Style of selected feature
  **
  Symbolizer[] symbolizers
  
  
  Layer? mainSelectedLayer


  new make()
  {
    sym := GeneralSym
    {
      pointSym = SimplePointSym { brush = Color.makeRgb(255, 0, 255); strokeBrush = Color.makeRgb(255, 0, 255); size = 20 }
      lineSym = SimpleLineSym { lineWidth = 7.0; strokeBrush = Color.makeRgb(255, 0, 255) }
      polygonSym = SimplePolygonSym { lineWidth = 7.0; fill = false; strokeBrush = Color.makeRgb(255, 0, 255) }
    }
    symbolizers = [sym, ArrowSym()]
  }

  Void clicked(CEvent e)
  {
    Float minx := e.x - tolerance
    Float miny := e.y - tolerance
    Float maxx := e.x + tolerance
    Float maxy := e.y + tolerance
    env := Envelope(minx, miny, maxx, maxy)
    env2 := env.transform(map.view.screen2World)
    select(env2.envelope)
  }

  Void select(Envelope env)
  {
    mainSelectedLayer = null
    features := Feature[,]
    cond := Condition
    {
      it.envelope = env
    }
    map.layers.eachr |lyr|
    {
      if (lyr.isVisible && lyr is VectorLayer && layerFilter(lyr))
      {
        VectorLayer vl := lyr
        vl.dataSource.each(cond) |f|
        {
          try {
            if (!multiSelect && features.size >0) {}
            else
            {
              shp := f as Shape
              if (shp != null)
              {
                if (env.intersectsGeometry(shp.geometry)) {
                  if (mainSelectedLayer == null) mainSelectedLayer = lyr
                  features.add(f)
                }
              }
            }
          } catch (Err e) {
            e.trace
          }
        }
      }
    }

    finish(features)
    onSelectChange?.call(features)
    map.refresh
  }

  private Void finish(Feature[] features)
  {
    if (features.size == 0)
    {
      map.layers.selectedLayer = null
      return
    }

    fc := FeatureList(features.first.envelope, TableDefBuilder("Features", ShapeFeature#).build, features)
    layer := VectorLayer.makeFeatureSet(fc)
    layer.symbolizers = symbolizers
    map.layers.selectedLayer = layer
  }

}