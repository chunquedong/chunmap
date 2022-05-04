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
** LayerList
**
@Js
@Serializable { collection = true }
class LayerList
{
  @Transient
  private Layer[] layers := [,]
  @Transient
  Layer? decorateLayer
  @Transient
  Layer? selectedLayer
  @Transient
  Envelope? envelope { private set }

  This add(Layer layer)
  {
    if (layers.containsSame(layer)) return this
    while (findIndex(layer.name) != -1) layer.name += "\$"
    layers.add(layer)
    recalcuEnvelope
    return this
  }

  Void remove(Layer layer)
  {
    layers.remove(layer)
    recalcuEnvelope
  }
  
  Void moveLayer(Layer from, Layer to, Bool before) {
    layers.remove(from)
    pos := layers.indexSame(to)
    if (before) {
        layers.insert(pos, from)
    }
    else {
        layers.insert(pos+1, from)
    }
  }

  Void moveTo(Layer layer, Int order)
  {
    if (order > size-1) order = size-1
    if (order < 0) order = 0
    layers.remove(layer)
    layers.insert(order, layer)
  }

  Int index(Layer layer) { layers.index(layer) }

  Int findIndex(Str name)
  {
    i := layers.findIndex { it.name == name }
    return i
  }

  Layer get(Int i) { layers[i] }
  Int size() { layers.size }

  Void each(|Layer, Int| act) { layers.each(act) }
  Void eachr(|Layer, Int| act) { layers.eachr(act) }

//////////////////////////////////////////////////////////////////////////
// Render
//////////////////////////////////////////////////////////////////////////

  Void render(RenderEnv r)
  {
    LabelSym.reset
    layers.each { it.render(r) }
    if (selectedLayer != null) selectedLayer.render(r)
    if (decorateLayer != null) decorateLayer.render(r)
    LabelSym.reset
  }

//////////////////////////////////////////////////////////////////////////
// reComputeEnvelop
//////////////////////////////////////////////////////////////////////////

  Void recalcuEnvelope()
  {
    env := EnvelopeBuilder.makeNone
    layers.each |lyr|
    {
      env.merge(lyr.envelope)
    }
    envelope = env.toEnvelope
  }
}