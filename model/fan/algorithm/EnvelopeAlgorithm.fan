//
// Copyright (c) 2009-2022, chunquedong
//
// This file is a part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

**
** Envelope Algorithm
**
@Js
class EnvelopeAlgorithm
{
  static Bool hasIntersect(Envelope env, Geometry geom)
  {
    if (geom is GeoPoint)
    {
      Point p := ((GeoPoint)geom).point
      return env.containsPoint(p)
    }
    else if (geom is LineString)
    {
      ls := geom as LineString
      r := env.toRing
      return r.intersects(ls) || r.containLineStringIn(ls)
    }
    else if (geom is Polygon)
    {
      pg := geom as Polygon
      Ring r := env.toRing
      if (pg.shell.containIn(GeoPoint.makeCoord(env.center)))
      {
        if (inHoles(r, pg)) return false
        else return true
      }
      else return r.intersects(pg.shell)
    }
    else if (geom is GeometryCollection)
    {
      gs := geom as GeometryCollection
      return gs.geometrys.any |g| { hasIntersect(env, g) }
    }
    else
    {
      throw ArgErr("UnknowType")
    }
  }

  private static Bool inHoles(LineString ls, Polygon pg)
  {
    return pg.holes.any { it.containLineStringIn(ls) }
  }
}