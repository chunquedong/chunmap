//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using chunmapModel
using chunmapData
using chunmapRaster

@Js
class RasterLayer : Layer
{
  RasterDataSource? dataSource

  new makeDataSource(RasterDataSource ds)
  {
    isEditable = false
    isSelectable = false
    dataSource = ds
    symbolizers = [RasterSym{}]
    name = ds.name
  }

  Void bindPreferScale(ViewPort view)
  {
    Bool isUsing := false
    view.onViewChanged = |ViewPort v|
    {
      if (isUsing) return
      nscale := dataSource.preferScale(v.scale)
      if (nscale != v.scale)
      {
        isUsing = true
        try
          v.scale = nscale
        finally
          isUsing = false
      }
    }
  }

  new make() {
    isEditable = false
    isSelectable = false
  }

  override Envelope envelope() { dataSource.envelope }

  override protected Void renderLayer(Int i, RenderEnv r)
  {
    cond := Condition
    {
      it.envelope = r.view.envelope
      scale = r.view.scale
      w = r.view.width
      h = r.view.height
    }
    dataSource.each(cond) |f|
    {
      r.data = f

//      if (f is Shape)
//      {
//        Renderer? rdr := (f as Shape)?.renderer
//        if (rdr != null && i < rdr.times)
//        {
//          rdr.drawElem(r, i)
//        }
//      }
      r.symbolizer.tryDrawElem(r)
    }
  }
}