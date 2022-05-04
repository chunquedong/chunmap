//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-17  Jed Young  Creation
//

**
** Geographic[terrestrial] coordinates System
**
@Js
const class GeoCoordSys
{
  **
  ** radius of the earth
  **
  const static Float r := 6371_012f

  **
  ** Get the spherical distance of two geographic coordinates points
  **
  static Float distance(Point p1, Point p2)
  {
    longitude1 := p1.x.toRadians
    latitude1 := p1.y.toRadians
    longitude2 := p2.x.toRadians
    latitude2 := p2.y.toRadians

    d := ((latitude1.sin)*(latitude2.sin)+(latitude1.cos)*(latitude2.cos)*(longitude1-longitude2).cos).acos
    return r * d
  }

  **
  ** From spherical coordinates to rectangular space coordinates
  **
  static Coord3D toXyz(Point p)
  {
    longitude := p.x.toRadians
    latitude := p.y.toRadians

    x := r * longitude.cos * latitude.cos
    y := r * latitude.cos * longitude.sin
    z := r * latitude.sin

    return Coord3D(x, y, z)
  }
}