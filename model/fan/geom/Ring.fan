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
** Ring is circular lineString
**
@Js
class Ring : LineString
{
  new make(CoordSeq coordinateArray) : super.make(coordinateArray)
  {
    check
  }

  private Void check()
  {
    if (size < 4)
      throw ArgErr("least four points(four pair coordinate)")

    if (!(startPoint.equals(endPoint)))
      throw ArgErr("firstPoInt mast same to lastPoInt in a ring")
  }


  override Geometry transform(|Point->Point| transf) { Ring(points.map(transf)) }

//////////////////////////////////////////////////////////////////////////
// util
//////////////////////////////////////////////////////////////////////////

  Bool containIn(GeoPoint point)
  {
    if (!super.envelope.containsPoint(point.point)) return false
    if (super.onLineString(point)) return true

    return RingAlgorithm.containIn(points, point.point)
  }

  Bool clockwise() { RingAlgorithm.clockwise(points) }

  Float area() { RingAlgorithm.calculateArea(points) }

  Bool containLineStringIn(LineString l2)
  {
    if (!super.envelope.contains(l2.envelope)) return false
    return RingAlgorithm.containLineString(points, l2.points)
  }

  Polygon toPolygon() { Polygon(this) }
}

