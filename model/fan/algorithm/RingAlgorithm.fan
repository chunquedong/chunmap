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
** Ring Algorithm
**
@Js
class RingAlgorithm
{
  **
  ** contains Point
  **
  static Bool containIn(CoordSeq points, Point point)
  {
    sum := 0f
    Point? p0 := null
    points.each |p|
    {
      if (p0 == null)
      {
        p0 = p
      }
      else
      {
        a := Angle(p0, point, p)
        sum += a.calculateAngle

        p0 = p
      }
    }
    if (sum.abs > 6.28f) return true
    else return false
  }

  **
  ** contains lineString
  **
  static Bool containLineString(CoordSeq points, CoordSeq other)
  {
    //break
    tLine := CoordSeqBuf.makeCoordSeq(other)
    points.each
    {
      tLine.tryPutPointExactly(it)
    }

    // try to find the not contain
    r := tLine.findSegment |lsg|
    {
      if (!containIn(points, lsg.middlePoint)) return true
      return false
    }
    return r == null
  }

//////////////////////////////////////////////////////////////////////////
// clockwise
//////////////////////////////////////////////////////////////////////////

  **
  ** is clockwise
  **
  static Bool clockwise(CoordSeq points)
  {
    Int i2 := maxPoint(points)
    Int i1 := (i2 == 0) ? points.size - 1 : i2 - 1
    Int i3 := (i2 == (points.size - 1)) ? 0 : i2 + 1
    angle := Angle(points[i1], points[i2], points[i3])

    Int i := angle.clockwise
    if (i == 1) return false
    else if (i == -1) return true
    else throw ArgErr("notSimpleGeometry")
  }

  static private Int maxPoint(CoordSeq points)
  {
    maxP := points[0]
    maxI := 0
    n := points.size
    for (i := 1; i < n; i++)
    {
      p := points[i]
      if (p > maxP)
      {
        maxP = p
        maxI = i
      }
    }
    return maxI
  }

//////////////////////////////////////////////////////////////////////////
// Area
//////////////////////////////////////////////////////////////////////////

  **
  ** area of the ring
  **
  static Float calculateArea(CoordSeq points)
  {
    area := 0f
    p := points[0]

    n := points.size - 1
    for (i := 1; i < n; i++)
    {
      trian := Triangle(p, points[i], points[i + 1])
      area += trian.area
    }
    return area
  }

  static Point calculateCenter(CoordSeq points)
  {
    xh := 0f // x sum
    he := 0f // power sum
    yh := 0f // y sum
    p := points[0]

    n := points.size - 1
    for (i := 1; i < n; i++)
    {
      trian := Triangle(p, points[i], points[i + 1])
      center := trian.coordCenter
      area := trian.area
      xh += area * center.x
      yh += area * center.y
      he += area
    }
    x := xh / he
    y := yh / he

    return Coord(x, y)
  }
}