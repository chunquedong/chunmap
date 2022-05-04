//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-29  Jed Young  Creation
//

using concurrent
using vaseGraphics
using vaseGraphics::Point as FPoint
using vaseMath::Vector as Vector3D
using vaseGui::DisplayMetrics
using chunmapModel
using chunmapData

**
** Arrow Symbolizer
**
@Js
class ArrowSym : GeometrySym
{
  private Geometry? geometry
  Float minDis := 30f
  Float arrowRatio = 3.0
  
  @Transient
  protected Float pixelMinDis := 30f

  new make()
  {
    this.brush = Color.black
    size = 14
  }
  
  override Bool beginRender(RenderEnv r) {
    rc := super.beginRender(r)
    
    pixelMinDis = DisplayMetrics.cur.dpToPixel(minDis).toFloat
    
    w := pixelSize
    h := (pixelSize / arrowRatio).toInt
    
    p1 := Coord(-w.toFloat, h.toFloat)
    p2 := Coord(0f, 0f)
    p3 := Coord(-w.toFloat, -h.toFloat)
    geometry = LineString.makePoints([p1, p2, p3, p1])
    return rc
  }

  private Geometry getGeometry(Point p1, Point p2)
  {
    v1 := Vector.makePoints(p1, p2)
    v2 := Vector.makePoints(Coord(0f, 0f), Coord(0f, 1f))
    Float angle := v1.angle(v2)

    trans := Transform2D.makeIndentity.rotate((angle + Float.pi / 2f).toDegrees, 0f, 0f).translate(p2.x, p2.y)
    transf := |Point p->Point|
    {
      Float[] cs := [p.x, p.y]
      trans.transform(cs)
      return Coord(cs[0], cs[1])
    }
    Geometry geom := geometry
    return geom.transform(transf)
  }

  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    if (geom is LineString)
    {
      LineString ls := geom
      drawLineSymbol(ls,r )
    }
    else if (geom is Polygon)
    {
      Polygon pg := geom
      drawLineSymbol(pg.shell, r)
      pg.holes.each |g|
      {
        drawLineSymbol(g, r)
      }
    }
    else if (geom is GeometryCollection)
    {
      GeometryCollection gs := geom
      gs.each |g|
      {
        drawGeometry(g, r)
      }
    }
  }

  private Void drawLineSymbol(LineString ls, RenderEnv r)
  {
    ls = ls.transform(r.view.world2Screen)
    g := r.g
    n := ls.size - 1
    for (i := 0; i < n; ++i)
    {
      Point p1 := ls.get(i)
      Point p2 := ls.get(i + 1)

      // out dis
      if (p1.distance2D(p2) < pixelMinDis) continue

      LineString lsa := getGeometry(p1, p2)
      ps := toIntArray(lsa)

      if (g.brush != brush) g.brush = brush
      g.fillPolygon(ps)
    }
  }

  private static PointArray toIntArray(LineString ls)
  {
    ps := PointArray(ls.size)
    i := 0
    ls.points.each |p|
    {
      ps.setX(i, p.x.toInt)
      ps.setY(i, p.y.toInt)
      ++i
    }
    return ps
  }

}