//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**
** LinearReference
**
@Js
class LinearReference
{
  **
  ** The point at distance
  **
  static Point refPoint(CoordSeq points, Float distance)
  {
    checkArgument(points, distance)
    len := 0f
    i := 0
    for (n := points.size - 1; i < n; i++)
    {
      len += points[i].distance2D(points[i + 1])

      if (len == distance) return points[i + 1]
      else if (len > distance) break
    }

    lsg := LineSegment(points[i], points[i + 1])
    l2 := len - distance
    l1 := lsg.length2D - l2
    lamuda := l1 / l2
    return lsg.separatedPoint(lamuda)
  }

  **
  ** a part of lineString
  **
  static CoordSeq? subLineString(CoordSeq points, Float start, Float end)
  {
    checkArgument(points, start)
    checkArgument(points, end)

    sp := refPoint(points, start)
    ep := refPoint(points, end)

    if (start < end)
    {
      return middleLineString(points, sp, ep)
    }
    else if (start > end)
    {
      return middleLineString(points, ep, sp)
    }
    else
    {
      return null
    }
  }

//////////////////////////////////////////////////////////////////////////
// Helper
//////////////////////////////////////////////////////////////////////////

  **
  ** The line that between of two point
  **
  private static CoordSeq middleLineString(CoordSeq points, Point start, Point end)
  {
    ml := splitLine(points, start)
    if (ml.size == 0) throw ArgErr("IllegalArgument exist")

    i := (ml.size == 1) ? 0 : 1
    tl := ml[i]
    ml2 := splitLine(tl, end)
    return ml2[0]
  }

  **
  ** split a line to two sub line.
  ** if the point is not on the line return null
  **
  static CoordSeq[]? splitLine(CoordSeq points, Point p)
  {
    if (!LineAlgorithm.onLineString(points, p)) return null
    if (onBorder(points, p)) return [points]

    // split
    points1 := Point[,]
    points2 := Point[,]
    n := points.size - 1
    for (i := 0; i < n; i++)
    {
      lseg := LineSegment(points[i], points[i + 1])
      if (lseg.onLineSegment(p))
      {
        tpoints := subList(points, 0, i + 1)
        points1.addAll(tpoints)
        points1.add(p)

        if (!lseg.onBorder(p)) points2.add(p)

        tpoints2 := subList(points, i + 1, n + 1)
        points2.addAll(tpoints2)
        break
      }
    }

    // make
    l1 := CoordArray(points1)
    l2 := CoordArray(points2)
    return CoordSeq[l1, l2]
  }

  private static Bool onBorder(CoordSeq points, Point p)
  {
    if (p.equals(points.first) || p.equals(points.last)) return true
    return false
  }

  private static Point[] subList(CoordSeq points, Int start, Int end)
  {
    sub := Point[,]
    for (i := start; i < end; i++)
    {
      sub.add(points[i])
    }
    return sub
  }

  private static Void checkArgument(CoordSeq points, Float distance)
  {
    length := getLength(points)
    if (distance < 0f || distance > length)
    {
      throw ArgErr("$distance out [0..$length]")
    }
  }

  **
  ** compute line length
  **
  static Float getLength(CoordSeq points)
  {
    len := 0f
    n := points.size - 1
    for (i := 0; i < n; i++)
    {
      d := points[i].distance2D(points[i + 1])
      len += d
    }
    return len
  }

  **
  ** get actual line length by longitude and latitude coordinates
  **
  static Float getWorldLength(CoordSeq points)
  {
    len := 0f
    n := points.size - 1
    for (i := 0; i < n; i++)
    {
      d := GeoCoordSys.distance(points[i], points[i + 1])
      len += d
    }
    return len
  }
}