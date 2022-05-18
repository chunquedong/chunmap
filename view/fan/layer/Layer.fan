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

**
** Layer
**
@Js
@Serializable
abstract class Layer
{
  Bool isVisible := true
  Bool isEditable := true
  Bool isSelectable := true
  Str name := ""
  
  Float minScale := 1E-6f
  Float maxScale := 1E8f

  Symbolizer[] symbolizers = [,]

  abstract Envelope envelope()

  Void render(RenderEnv r)
  {
    if (!isVisible) return
    if (r.view.scale < this.minScale) return
    if (r.view.scale > this.maxScale) return
    
    for (i:=0; i<symbolizers.size; ++i) {
        r.g.push
        sym := symbolizers[i]
        if (sym.beginRender(r)) {
            r.symbolizer = sym
            renderLayer(i, r)
            sym.endRender(r)
        }
        r.g.pop
    }
  }

  protected abstract Void renderLayer(Int step, RenderEnv r)

  override Str toStr() { name }
}