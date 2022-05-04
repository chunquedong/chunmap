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
using vaseWindow
using vaseGui

**
** MapCanvas is a map widget
**
@Js
class MapCanvas : Widget
{
  MapCtrl ctrl

  new make()
  {
    ctrl = MapCtrl(this)
    //bindEvent
    //focusable = true
    dragAware = true
    layout.height = Layout.matchParent
  }

  override Void doPaint(Rect clip, Graphics g)
  {
    ctrl.resetSize(Size(this.width, this.height))
    ctrl.onPaint(g)
  }

  override Void motionEvent(MotionEvent e)
  {
    if (e.consumed) return
    super.motionEvent(e)
    if (e.type == MotionEvent.pressed) { onEvent(e, CEvent.mouseDown) }
    //if (e.type == MotionEvent.pressed) { onEvent(it, CEvent.mouseEnter) }
    //if (e.type == MotionEvent.pressed) { onEvent(it, CEvent.mouseExit) }
    //if (e.type == MotionEvent.pressed) { onEvent(it, CEvent.mouseHover) }
    if (e.type == MotionEvent.moved || e.type == MotionEvent.mouseMove) { onEvent(e, CEvent.mouseMove) }
    if (e.type == MotionEvent.released) { onEvent(e, CEvent.mouseUp) }
    if (e.type == MotionEvent.wheel) { onEvent(e, CEvent.mouseWheel) }
  }

  private Void onEvent(MotionEvent e, Int id)
  {
    CEvent ce := CEvent(id)
    ce.x = e.relativeX - this.x
    ce.y = e.relativeY - this.y
    ce.button = e.button
    ce.count = e.count
    ce.delta = e.delta
    ce.rawEvent = e
    ctrl.onEvent(ce)
  }
}

