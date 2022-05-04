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
using vaseGraphics::Point as SysPoint

using chunmapModel

**
** DrawHelper
**
@Js
const class DrawHelper
{
  static SysPoint[] toSysPointArray(LineString ls, RenderEnv r)
  {
    ps := SysPoint[,]
    ls.points.each |p|
    {
      ps.add(SysPoint(r.view.x2Screen(p.x).toInt, r.view.y2Screen(p.y).toInt))
    }
    return ps
  }

  static PointArray toIntArray(LineString ls, RenderEnv r)
  {
    ps := PointArray(ls.size)
    i := 0
    ls.points.each |p|
    {
      ps.setX(i, r.view.x2Screen(p.x).toInt)
      ps.setY(i, r.view.y2Screen(p.y).toInt)
      ++i
    }
    return ps
  }
  
  static Color randomColor() {
    h := (0..<360).random.toFloat
    return Color.makeHsv(h, 0.5, 0.8)
  }
}