//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using chunmapView
using vaseGraphics

**
** MapCanvas is a map widget
**
@Js
class MapCtrl
{
  CMap? map
  Bool useRenderCache := true
  private MapCanvas? mapCanvas
  private Bool mapDirty = true

  Transform2D? transform

  |Graphics|[] overlays := [,]

  OperateManager operateManager := OperateManager(this)

  new make(MapCanvas? mapCanvas, Size size := Size(50, 50))
  {
    this.mapCanvas = mapCanvas
    map = CMap(size, 0 , 0)
  }

//////////////////////////////////////////////////////////////////////////
// paint
//////////////////////////////////////////////////////////////////////////

  **
  ** paint the buffer to the graphics
  **
  Void onPaint(Graphics g)
  {
    g.antialias = true
    g.brush = Color.white
    g.antialias = true
    g.fillRect(0, 0, map.size.w, map.size.h)
    g.push
    
    isDirty := mapDirty
    if (mapDirty) {
        mapDirty = false
        overlays.clear
        transform = null
    }
    
    if (transform != null) g.transform(transform)

    if (useRenderCache) {
      if (isDirty) {
        map.renderToImg
      }
      g.drawImage(map.image, -map.xBuffer, -map.yBuffer)
    }
    else {
      map.render(g)
    }

    g.pop
    
    g.brush = Color.black
    overlays.each |f| {
      g.push
      f(g)
      g.pop
    }

    g.font = Font(12)
    g.brush = Color.black
    scale := (1.0/map.view.scale).toInt
    g.drawText("chunmap, scale 1:$scale", 15, map.size.h-15)
  }

  **
  ** change the size of map
  **
  Bool resetSize(Size size)
  {
    if (size.w != map.view.width || size.h != map.view.height)
    {
      map.resetSize(size, 300, 300)
      mapDirty = true
      return true
    }
    return false
  }

  Void clearOverlay() { overlays.clear }
  
  Void repaint() { mapCanvas.repaint }

  **
  ** renderMap and repaint the mapObserver
  **
  Void refresh() { mapDirty = true; mapCanvas.repaint }

  **
  ** paint on buffer
  **
  Void paintOverlay(|Graphics g| f, Bool isClear = true)
  {
    if (isClear) clearOverlay
    overlays.add(f)
  }

//////////////////////////////////////////////////////////////////////////
// getter
//////////////////////////////////////////////////////////////////////////

  ViewPort view() { map.view }

  LayerList layers() { map.layers }

//////////////////////////////////////////////////////////////////////////
// proxy
//////////////////////////////////////////////////////////////////////////

  Void onEvent(CEvent e) { operateManager.onEvent(e) }

  **
  ** set layer extent to the current viewPort
  **
  This fullView() { map.fullView; return this }

  Void setCurrentTool(Tool plug) { operateManager.currentTool = plug }
  Void executeCommand(CCommand cmd) { operateManager.executeCommand(cmd) }
  Void undo() { operateManager.undo }
  Void redo() { operateManager.redo }
}

