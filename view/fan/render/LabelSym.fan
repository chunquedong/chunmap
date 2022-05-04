//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using concurrent
using vaseGraphics
using vaseMath
using vaseGui::DisplayMetrics

using chunmapModel
using chunmapData

**
** Label Symbolizer
**
@Js
class LabelSym : Symbolizer
{
  @Transient
  private static Ring[]? labeledRegion() { Actor.locals["chunmapView.labeledRegion"] }
  static Void reset() { Actor.locals["chunmapView.labeledRegion"] = Ring[,] }

  Brush brush := Color.black
  Int xOffset := 10
  Int yOffset := 0
  Int fieldIndex := 0
  Int fontSize = 25 {
    set {
        &fontSize = it
        fontCache = null
    }
  }

  @Transient
  private Font? fontCache
  
  new make() {
  }
  
  override Bool beginRender(RenderEnv r) {
    rc := super.beginRender(r)
    //pixelMinDis = DisplayMetrics.cur.dpToPixel(minDis).toFloat
    return rc
  }
  
  private Font font() {
    if (fontCache == null) {
        fontCache = Font(DisplayMetrics.cur.dpToPixel(fontSize.toFloat))
    }
    return fontCache
  }

  override Void drawElem(RenderEnv r)
  {
    shape := r.data as Shape
    if (shape == null) return

    value := shape.get(fieldIndex)
    if (value == null) return
    text := value.toStr.trim
    if (text == "") return

    drawForGeometry(text, shape.geometry, r)
  }

  private Void drawForGeometry(Str text, Geometry geom, RenderEnv r)
  {
    if (geom is LineString)
    {
      drawForLine(text, geom, r)
    }
    else if (geom is GeometryCollection)
    {
      GeometryCollection gs := geom
      gs.each
      {
        drawForGeometry(text, it, r)
      }
    }
    else
    {
      drawAtCenter(text, geom, r)
    }
  }

  private Void drawAtCenter(Str text, Geometry geom, RenderEnv r)
  {
    chunmapModel::Point? point
    if (geom isnot GeoPoint)
      point = geom.envelope.center
    else
      point = ((GeoPoint)geom).point

    if (!r.view.getBufferEnvelope.containsPoint(point)) return
    
    w := font.width(text)
    h := font.height
    
    if (geom is Polygon) {
        if (r.view.dis2Screen(geom.envelope.width) < w.toFloat) return
    }

    x := r.view.x2Screen(point.x) + xOffset
    y := r.view.y2Screen(point.y) + yOffset

    envelope := Envelope(x, y, x+w, y+h)
    for(i:=labeledRegion.size-1; i != -1; i--)
    {
      e := labeledRegion[i]
      if (envelope.intersects(e.envelope)) return
    }
    labeledRegion.add(envelope.toRing)

    g := r.g
    if (g.brush != brush) g.brush = brush
    if (g.font != font) g.font = font
    g.drawText(text, x.toInt, y.toInt)
  }

  private Void drawForLine(Str text, LineString lineString, RenderEnv r)
  {
    //length
    length := lineString.length
    halfLength := length / 2f

    //middle point
    middlePoint := lineString.refPoint(halfLength)
    if (!r.view.getBufferEnvelope.containsPoint(middlePoint)) return

    //font size
    w := font.width(text)
    h := font.height

    //distance
    d := r.view.dis2World(w / 2f)
    minD := halfLength-d
    maxD := halfLength+d
    if (minD < 0f) return
    if (maxD > length) return

    //start and end points
    p0 := lineString.refPoint(minD)
    p1 := lineString.refPoint(maxD)
    if (p0.x > p1.x)
    {
      temp := p0
      p0 = p1
      p1 = temp
    }

    //angle
    angle := p0.angle(p1)

    //position
    x := r.view.x2Screen(p0.x)
    y := r.view.y2Screen(p0.y)

    //transform
    trans := Transform2D.makeIndentity.rotate(-angle.toDegrees, x, y)

    //envelope
    envelope := Envelope(x, y, x+w, y+h)
    region := envelope.transform |chunmapModel::Point p->chunmapModel::Point|
    {
      Float[] xy := [p.x, p.y]
      trans.transform(xy)
      return Coord(xy[0], xy[1])
    }

    //overlay test
    for(i:=labeledRegion.size-1; i != -1; i--)
    {
      e := labeledRegion[i]
      if (region.envelope.intersects(e.envelope)) return
    }
    labeledRegion.add(region)

    //style
    g := r.g
    if (g.brush != brush) g.brush = brush
    if (g.font != font) g.font = font

    //draw
    g.push
    //g.transform(trans.mult(g.transform))
    g.transform(trans)
    g.drawText(text, x.toInt, y.toInt)
    g.pop
  }

}