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


**
** show the Distance
**
@Js
class DistanceTool : LineTool
{
  Bool isMercator = true
  
  override protected Void mouseMove(CEvent e)
  {
    if (!draging) return

    map.paintOverlay |g|
    {
      g.lineWidth = 2.0
      g.drawPolyline(toIntArray(e.x, e.y))
      dis := getLength(e.x, e.y)
      Str? text
      if (dis < 1000.0) {
        text = dis.toLocale("0.0")+"m"
      }
      else if (dis < 10000.0) {
        dis = dis / 1000
        text = dis.toLocale("0.0")+"km"
      }
      else {
        dis = dis / 1000
        text = dis.toLocale("0")+"km"
      }

      font := Font(15)
      offset := font.ascent + font.leading
      g.font = font
      g.brush = Color.black
      g.fillRect(e.x, e.y-20-offset, font.width(text)+20, font.height)

      g.brush = Color.white
      g.drawText(text, e.x+5, e.y-20)
    }
    e.consumed = true
    map.repaint
  }

  private Float getLength(Int x, Int y)
  {
    p := map.view.screen2World.call(Coord(x.toFloat, y.toFloat))
    dup := lse.dup
    dup.add(p)
    
    coordSeq := dup.toCoordSeq
    if (isMercator) {
        coordSeq = coordSeq.map(Mercator().getReverseTransform)
    }
    return LinearReference.getWorldLength(coordSeq)
  }
}

@Js
class MeasuringAreaTool : AreaTool {
  override protected Void mouseMove(CEvent e)
  {
    if (!draging) return

    map.paintOverlay |g|
    {
      g.lineWidth = 2.0
      g.drawPolygon(toIntArray(e.x, e.y))
      dis := getArea(e.x, e.y)
      Str? text
      if (dis < 1000.0*1000.0) {
        text = dis.toLocale("0.0")+"m^2"
      }
      else if (dis < 10000.0*10000.0) {
        dis = dis / (1000*1000)
        text = dis.toLocale("0.0")+"km^2"
      }
      else {
        dis = dis / (1000*1000)
        text = dis.toLocale("0")+"km^2"
      }

      font := Font(15)
      offset := font.ascent + font.leading
      g.font = font
      g.brush = Color.black
      g.fillRect(e.x, e.y-20-offset, font.width(text)+20, font.height)

      g.brush = Color.white
      g.drawText(text, e.x+5, e.y-20)
    }
    e.consumed = true
    map.repaint
  }

  private Float getArea(Int x, Int y)
  {
    if (lse.size < 2) return 0.0
    p := map.view.screen2World.call(Coord(x.toFloat, y.toFloat))
    dup := lse.dup
    dup.add(p)
    dup.add(lse.first)
    return Ring(dup.toCoordSeq).area
  }
}