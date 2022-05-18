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
using chunmapData

**
** Symbolizer
**
@Js
@Serializable
abstract class Symbolizer
{
  Float minScale := 1E-6f
  Float maxScale := 1E8f

  Int alpha := 255
  Bool antialias := true
  
  RenderFilter[] filters := [,]

  Bool tryDrawElem(RenderEnv r)
  {
    pass := filters.all |f| { f.isPass(r.data) }
    if (!pass) return false
    drawElem(r)
    return true
  }

  abstract Void drawElem(RenderEnv r)

  virtual Bool beginRender(RenderEnv r) {
    if (r.view.scale < this.minScale) return false
    if (r.view.scale > this.maxScale) return false
    
    if (r.g.alpha != this.alpha) r.g.alpha = this.alpha
    if (r.g.antialias != this.antialias) r.g.antialias = this.antialias
    
    return true
  }

  virtual Void endRender(RenderEnv r) {
  }
}