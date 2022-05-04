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
** Collection of Point and Line
**
@Js
class PointLineBag
{
  Point[] points := [,] { private set }
  CoordSeq[] lines := [,] { private set }

  Int pointSize() { points.size }

  Int lineSize() { lines.size }

  Int size() { points.size + lines.size }

  Bool isEmpty() { (pointSize == 0) && (lineSize == 0) }

  **
  ** g is Point or Point[]
  **
  Void add(Obj g)
  {
    if (g is Point)
    {
      Point p := g
      if (!points.contains(p))
      {
        putPoint(p)
      }
    }
    else if (g is Point[])
    {
      line := CoordArray((Point[])g)
      if (!lines.contains(line))
      {
        putLine(line)
      }
    }
    else
    {
      throw ArgErr("noly support point and Point[]")
    }
  }

  **
  ** add all items of other bag
  **
  Void addAll(PointLineBag bag)
  {
    bag.points.each
    {
      this.add(it)
    }
    bag.lines.each
    {
      this.add(it)
    }
  }

  private Void putPoint(Point p)
  {
    r := lines.find |line| { onLineString(line, p) }
    if (r != null) return

    points.add(p)
  }

  private Bool onLineString(CoordSeq points, Point p)
  {
    LineAlgorithm.onLineString(points, p)
  }

  private Void putLine(CoordSeq line)
  {
    // remove over point
    Point? tp := points.find { onLineString(line, it) }
    if (tp != null) points.remove(tp)

    // merge connected line
    newLine := CoordSeqBuf.makeCoordSeq(line)
    CoordSeq? tl := lines.find |l2|
    {
      if (newLine.canJoin(l2))
      {
        newLine.join(l2)
        return true
      }
      return false
    }

    if (tl != null)
    {
      lines.remove(tl)
      lines.add(newLine.toCoordSeq)
    }
    else
    {
      lines.add(line)
    }
  }
}