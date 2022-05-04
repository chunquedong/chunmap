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
** LineString
**
@Js
class LineString : Geometry
{
  CoordSeq points

  new make(CoordSeq points)
  {
    this.points = points
  }

  static LineString makePoints(Point[] cs) { make(CoordArray(cs)) }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  GeoPoint startPoint() { GeoPoint.makeCoord(points.first) }

  GeoPoint endPoint() { GeoPoint.makeCoord(points.last) }

  GeoPoint getPoint(Int i) { GeoPoint.makeCoord(get(i)) }

  Point get(Int i) { points.get(i) }

  Int size() { points.size }

  Bool isClosed() { points.first.equals(points.last) }

  Ring toLinearRing() { Ring(points) }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  override Int hash() { points.hash }

  override Bool equals(Obj? obj)
  {
    if (this === obj)  return true

    other := obj as LineString
    if (other == null) return false

    return points.equals(other.points)
  }

  override Str toStr() { "LINESTRING " + toMyString }

  internal Str toMyString() { points.toMyString }

//////////////////////////////////////////////////////////////////////////
// Geometry
//////////////////////////////////////////////////////////////////////////

  override once Envelope envelope()
  {
    minX := Float.posInf
    minY := Float.posInf
    maxX := Float.negInf
    maxY := Float.negInf

    points.each
    {
      if (it.x < minX) minX = it.x
      if (it.x > maxX) maxX = it.x

      if (it.y < minY) minY = it.y
      if (it.y > maxY) maxY = it.y
    }

    return Envelope(minX, minY, maxX, maxY)
  }

  override Geometry transform(|Point->Point| transf) { LineString(points.map(transf)) }

  override Obj? eachPoint(|Point->Obj?| trace)
  {
    for (i:=0; i<size; i++)
    {
      r := trace(points[i])
      if (r != null) return r
    }
    return null
  }

  override GeometryType geometryType() { GeometryType.lineString }

  override Geometry? getBoundary() { MultiPoint([startPoint, endPoint]) }

  override Bool isValid() { LineAlgorithm.isSimple(this.points) }

//////////////////////////////////////////////////////////////////////////
// Util
//////////////////////////////////////////////////////////////////////////

  Bool onLineString(GeoPoint p)
  {
    if (!this.envelope.containsPoint(p.point)) return false
    return LineAlgorithm.onLineString(points, p.point)
  }

  PointLineBag intersection(LineString l2)
  {
    if (!this.envelope.intersects(l2.envelope)) return PointLineBag()
    return LineAlgorithm.intersection(this.points, l2.points)
  }

  Bool intersects(LineString l2)
  {
    if (!this.envelope.intersects(l2.envelope)) return false
    return LineAlgorithm.intersects(this.points, l2.points)
  }

  Bool containLineString(LineString l2)
  {
    if (!this.envelope.intersects(l2.envelope)) return false
    return LineAlgorithm.containLineString(this.points, l2.points)
  }

  Float length() { LinearReference.getLength(points) }

  Point refPoint(Float distance) { LinearReference.refPoint(points, distance) }
}

