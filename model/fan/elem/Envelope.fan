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
** Envelope is minimum rectangle bounds box of a `Geometry`
**
@Js
const class Envelope : Rectangle
{
  ** minimum X
  const override Float minX

  ** maximum X
  const override Float maxX

  ** minimum Y
  const override Float minY

  ** maximum Y
  const override Float maxY

  **
  ** Make from four coordinate value. x1,y1 is a point and x2,y2 is another point
  **
  new make(Float x1, Float y1, Float x2, Float y2)
  {
    if (x1 < x2)
    {
      minX = x1
      maxX = x2
    }
    else
    {
      minX = x2
      maxX = x1
    }
    if (y1 < y2)
    {
      minY = y1
      maxY = y2
    }
    else
    {
      minY = y2
      maxY = y1
    }
  }

  **
  ** Make from `Coord`
  **
  static Envelope makePoints(Coord point1, Coord point2)
  {
    make(point1.x, point1.y, point2.x, point2.y)
  }
  **
  ** from WKT string
  **
  static Envelope fromStr(Str text, Precision precision := Precision.none)
  {
    WktReader(text).readEnvelope()
  }

  /*
     2 | 3
     --+--
     0 | 1
  */
  Envelope[] quarters()
  {
    Point p := this.center
    env1 := Envelope.makePoints(this.minPoint, p)
    env2 := Envelope.makePoints(this.rightDown, p)
    env3 := Envelope.makePoints(this.leftUp, p)
    env4 := Envelope.makePoints(this.maxPoint, p)

    return Envelope[env1, env2, env3, env4]
  }
}