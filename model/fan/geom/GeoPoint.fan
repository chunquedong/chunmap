//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

**
** Geometry Point
**
@Js
class GeoPoint : Geometry
{
  const Point point

  new makeCoord(Point point)
  {
    this.point = point
  }

  static new make(Float x, Float y) { makeCoord(Coord(x, y)) }

  Float x() { point.x }
  Float y() { point.y }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  override Bool equals(Obj? obj)
  {
    if (this === obj) return true

    p := obj as GeoPoint
    if (p == null) return false

    return this.point.equals(p.point)
  }

  override Int hash() { point.hash }

  override Str toStr() { "POINT ($x $y)" }

//////////////////////////////////////////////////////////////////////////
// Geometry
//////////////////////////////////////////////////////////////////////////

  override once Envelope envelope() { Envelope(this.x, this.y, this.x, this.y) }

  override Geometry transform(|Point->Point| transf){ GeoPoint.makeCoord(transf(point)) }

  override Obj? eachPoint(|Point->Obj?| trace) { trace(point) }

  override GeometryType geometryType() { GeometryType.point }

  override Geometry? getBoundary() { null }

  override Bool isValid() { true }
}

