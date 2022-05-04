//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-10  Jed Young  Creation
//

**
** Envelope is minimum rectangle region of a `Geometry`
**
@Js
const class Line
{
  ** slope
  const Float k

  ** y intercept distance
  const Float b

  ** perpendicular to x axis
  const Bool isVertical

  **
  ** make from two points
  **
  new makePoints(Point p1, Point p2)
  {
    dy := p2.y - p1.y
    dx := p2.x - p1.x

    if (p1.equals(p2)) throw ArgErr("need tow different points to make one line")

    // if vertical
    if (dx == 0f)
    {
      k = Float.posInf
      b = p1.x // b become to x intercept
      isVertical = true
    }
    else
    {
      k = dy / dx
      b = p1.y - k * p1.x
    }
  }

  **
  ** make from slope and intercept
  **
  new make(Float k, Float b)
  {
    if (Float.posInf == k || Float.negInf == k)
    isVertical = true
    this.k = k
    this.b = b
  }

  **
  ** make from a point and slope
  **
  new makePk(Point p, Float k)
  {
    if (Float.posInf == k || Float.negInf == k)
    {
      k = Float.posInf
      b = p.x
      isVertical = true
    }
    else
    {
      b = p.y - k * p.x
      this.k = k
    }
  }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  Float getY(Float x)
  {
    if (isVertical) return Float.nan // vertical

    return k * x + b
  }

  Float getX(Float y)
  {
    if (isVertical) return b // vertical
    if (k == 0f) return Float.nan// horizontal

    return (y - b) / k
  }

  **
  ** slope
  **
  Float getK()
  {
    if (isVertical) return Float.posInf
    return k
  }

  **
  ** y intercept
  **
  Float getB()
  {
    return b
  }

  **
  ** perpendicular slope
  **
  Float perpendicularK()
  {
    if (isVertical)
    return 0f
    else if (k == 0f)
    return Float.posInf
    return -1f / k
  }

//////////////////////////////////////////////////////////////////////////
// intersection
//////////////////////////////////////////////////////////////////////////

  **
  ** point of intersection
  **
  Point? crossPoint(Line l2)
  {
    k1 := this.getK
    b1 := this.getB
    k2 := l2.getK
    b2 := l2.getB

    if (this.isVertical && l2.isVertical)
    {
       return null
    }
    else if (this.isVertical)
    {
       y := l2.getY(this.b)
       return Coord(this.b, y)
    }
    else if (l2.isVertical)
    {
      y := this.getY(l2.b)
      return Coord(l2.b, y)
    }
    else if (k1 == k2)
    {
      // parallel
      return null
    }
    else if (k1 == 0f)
    {
      x := l2.getX(this.b)
      return Coord(x, this.b)
    }
    else if (k2 == 0f)
    {
      x := this.getX(l2.b)
      return Coord(x, l2.b)
    }

    x2 := (b1 - b2) / (k2 - k1)
    y2 := this.getY(x2)

    return Coord(x2, y2)
  }

  **
  ** distance of point to this line
  **
  Float distance(Point point)
  {
    vertical := Line.makePk(point, perpendicularK)
    Point crossP := crossPoint(vertical)
    return point.distance2D(crossP)
  }

  **
  ** on the line approximate
  **
  Bool onLine(Point p)
  {
    // if vertical
    if (isVertical) return p.x == getB

    expectedY := getY(p.x)
    return expectedY.approx(p.y)
  }
}