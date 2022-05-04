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

using chunmapModel
using chunmapData
using chunmapRaster

@Js
abstract class CollectionSym : Symbolizer
{
  Symbolizer[] symbolizers = [,]
  
  protected Symbolizer[] validSyms = [,]

  override Bool beginRender(RenderEnv r) {
    validSyms.clear
    if (!super.beginRender(r)) {
        return false
    }
    symbolizers.each {
        if (it.beginRender(r)) {
            validSyms.add(it)
        }
    }
    return validSyms.size > 0
  }
  
  override Void drawElem(RenderEnv r) {
    validSyms.each { it.tryDrawElem(r) }
  }

  override Void endRender(RenderEnv r) {
    validSyms.each { it.endRender(r) }
    super.endRender(r)
  }
}

**
** Mutex Symbolizer
**
@Js
abstract class MutexSym : CollectionSym
{
  override Void drawElem(RenderEnv r)
  {
    validSyms.find |sym|
    {
      return sym.tryDrawElem(r)
    }
  }
}