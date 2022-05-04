//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-09  Jed Young  Creation
//

**
** Rectangle
**
@Js
mixin Rectangle
{
  ** minimum X
  abstract Float minX()

  ** maximum X
  abstract Float maxX()

  ** minimum Y
  abstract Float minY()

  ** maximum Y
  abstract Float maxY()

  **
  ** center of rectangle
  **
  Coord center()
  {
    x := (minX + maxX) / 2f
    y := (minY + maxY) / 2f
    return Coord(x, y)
  }

  ** position of leftDown. See `Rectangle.leftUp`
  Coord minPoint() { Coord(minX, minY) }

  ** position of rightUp. See `Rectangle.leftUp`
  Coord maxPoint() { Coord(maxX, maxY) }

  **
  ** position of leftUp. Like this:
  **
  **  y^
  **   |  LU    MAX
  **   |  +------+
  **   |  |      |
  **   |  +------+ RD
  **   |  MIN
  **   |
  **  0+------------->
  **                 x
  Coord leftUp() { Coord(minX, maxY) }

  ** position of rightDown. See `Rectangle.leftUp`
  Coord rightDown() { Coord(maxX, minY) }

  ** The height of region
  Float height() { maxY - minY }

  ** The width of region
  Float width() { maxX - minX }

  **
  ** Return true if p is inside this envelope.
  **
  Bool containsPoint(Point p)
  {
    if (p.x < minX || p.x > maxX) return false
    if (p.y < minY || p.y > maxY) return false
    return true;
  }

  **
  ** Return true if env is inside this envelope.
  **
  Bool contains(Envelope env)
  {
    if (!this.containsPoint(env.minPoint) ) return false
    if (!this.containsPoint(env.maxPoint) ) return false
    return true
  }

  ** make a Ring by Rectangle
  Ring toRing()
  {
    Point[] points :=
    [
      Coord(minX, minY),
      Coord(maxX, minY),
      Coord(maxX, maxY),
      Coord(minX, maxY),
      Coord(minX, minY),
    ]
    return Ring(CoordArray(points))
  }

  **
  ** map to other Envelope
  **
  Envelope translate(|Point->Point| transf)
  {
    p1 := transf(minPoint)
    p2 := transf(maxPoint)
    return Envelope.makePoints(p1, p2)
  }

  Ring transform(|Point->Point| transf)
  {
    p1 := transf(minPoint)
    p2 := transf(rightDown)
    p3 := transf(maxPoint)
    p4 := transf(leftUp)

    return Ring(CoordArray([p1, p2, p3, p4, p1]))
  }

//////////////////////////////////////////////////////////////////////////
// intersect
//////////////////////////////////////////////////////////////////////////

  **
  ** Compute the intersection between this rectangle and that rectangle.
  ** If there is no intersection, then return null.
  **
  Envelope? intersection(Envelope envelop)
  {
    minx := minX.max(envelop.minX)
    miny := minY.max(envelop.minY)
    maxx := maxX.min(envelop.maxX)
    maxy := maxY.min(envelop.maxY)
    if (minX > maxX || minY > maxY) return null
    return Envelope(minx, miny, maxx, maxy)
  }

  **
  ** Return true if this rectangle intersects any portion of that rectangle
  **
  Bool intersects(Envelope envelop)
  {
    if (envelop.minY > maxY) return false
    else if (envelop.maxY < minY) return false
    else if (envelop.minX > maxX) return false
    else if (envelop.maxX < minX) return false
    else return true
  }

  Bool intersectsGeometry(Geometry geom)
  {
    if (!intersects(geom.envelope)) return false
    return EnvelopeAlgorithm.hasIntersect(this, geom)
  }

//////////////////////////////////////////////////////////////////////////
// Override
//////////////////////////////////////////////////////////////////////////

  ** '"minX minY,maxX maxY"'
  override Str toStr() { "BOX($minX $minY,$maxX $maxY)" }

  ** Return hash of x, y, w, and h.
  override Int hash()
  {
    minX.hash.xor(minY.hash.shiftl(8)).xor(maxX.hash.shiftl(16)).xor(maxY.hash.shiftl(24))
  }

  ** Return if obj is same Envelope value.
  override Bool equals(Obj? obj)
  {
    if (this === obj)  return true

    that := obj as Rectangle
    if (that == null) return false
    return this.minX == that.minX && this.minY == that.minY &&
           this.maxX == that.maxX && this.maxY == that.maxY
  }
}