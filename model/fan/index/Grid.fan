//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-03  Jed Young  Creation
//

**
** Grid manage some tile
**
@Js
const class Grid
{
  const Float width
  const Float height
  const Float minX
  const Float minY

  const Envelope envelope

  new make(Envelope env)
  {
    envelope = env
    width = env.width
    height = env.height
    minX = env.minX
    minY = env.minY
  }

  **
  ** get tile envelope
  **
  Envelope tileEnvelope(Tile tile)
  {
    num := 2f.pow(tile.z.toFloat).toInt
    tminX := (tile.x * width )/ num  + minX
    tminY := (tile.y * height)/ num  + minY

    return Envelope(tminX, tminY, tminX + width/num, tminY + height/num)
  }

  **
  ** find the Tile that intersects with the envelope
  **
  Tile[] findTiles(Envelope env, Int z)
  {
    env = env.intersection(envelope)
    tileSet := Tile[,]
    minT := getTile(env.minPoint, z, false)
    maxT := getTile(env.maxPoint, z, true)

    for (Int i := minT.x; i <= maxT.x; i++)
    {
      for (Int j := minT.y; j <= maxT.y; j++)
      {
        tile := Tile(i, j, z)
        tileSet.add(tile)
      }
    }
    return tileSet
  }

  **
  ** calculate zoom by scale
  ** originLevelScale is zero level( z = 0 ) scale
  **
  static Int scaleTozoom(Float scale, Float originLevelScale)
  {
    curScale := originLevelScale
    Int i := -1
    while (curScale < scale*1.5f)
    {
      curScale = curScale * 2f
      i++
    }
    if ( i == -1) return 0
    return i
  }

  static Float preferScale(Float scale, Float originLevelScale)
  {
    curScale := originLevelScale
    while (curScale < scale*0.6f)
    {
      curScale = curScale * 2f
    }
    return curScale
  }

  static const Float greaterOne := 1 + 1e-10f
  static const Float lessOne := 1 - 1e-10f

  **
  ** get tile coord by position
  **
  Tile getTile(Point p, Int z, Bool isMax)
  {
    num := 2f.pow(z.toFloat).toInt
    x := ((p.x - minX)  * num) / width
    y := ((p.y - minY)  * num) / height

    if (isMax)
    {
      x *= lessOne
      y *= lessOne
    }
    else
    {
      x *= greaterOne
      y *= greaterOne
    }
    return Tile(x.floor.toInt, y.floor.toInt, z)
  }

  override Str toStr()
  {
    "$minX,$minY,$width,$height"
  }

  static Grid fromStr(Str s)
  {
    cs := s.split(',')
    x := cs[0].toFloat
    y := cs[1].toFloat
    w := cs[2].toFloat
    h := cs[3].toFloat
    return Grid(Envelope(x, y, x+w, y+h))
  }
}