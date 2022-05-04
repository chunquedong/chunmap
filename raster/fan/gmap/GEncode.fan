//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-04  Jed Young  Creation
//

using chunmapModel

**
** OSM tile encode
**
** Tile is 256*256px image.
** There are 18 level(0-17) scale.
** The first is 0 level, is a global view
** The next level is quartern of tile
** The coordinate origin at left-top(W180,N90)
** Base on Transverse Mercator projection.
**
@Js
class GEncode
{

//////////////////////////////////////////////////////////////////////////
// const
//////////////////////////////////////////////////////////////////////////

  ** pixel size of a tile
  static const Int tileSize := 300

  ** Mercator projected width
  static const Float dis := Mercator.maxDis * 2

  ** scale of one tile global view
  static const Float originScale := tileSize / dis

//////////////////////////////////////////////////////////////////////////
// fields
//////////////////////////////////////////////////////////////////////////

  ** tile total num of horizontal or vertical
  private Int countX

  ** tile size in projection
  private Float sizeX

  ** current zoom
  private Int zoom

  ** make from zoom
  new make(Int zoom)
  {
    countX = 2.toFloat.pow(zoom.toFloat).toInt // 2^zoom
    sizeX = dis / countX
    this.zoom = zoom
  }

  **
  ** find the Tile that intersects with the envelope
  **
  GTile[] findAll(Envelope envelope)
  {
    tileSet := GTile[,]
    minT := getTile(envelope.leftUp, true)
    maxT := getTile(envelope.rightDown, false)

    for (Int i := minT.x; i <= maxT.x; i++)
    {
      for (Int j := minT.y; j <= maxT.y; j++)
      {
        if (j < 0 || j >= countX) continue
        tile := GTile(i, j, zoom)
        normallize(tile, countX)
        tileSet.add(tile)
      }
    }
    return tileSet
  }

  **
  ** get tile coord by position
  **
  private Tile getTile(Point p, Bool isLeftUp)
  {
    indexX := (p.x + Mercator.maxDis) / sizeX
    indexY := (Mercator.maxDis - p.y) / sizeX

    if (isLeftUp)
    {
      indexX = indexX - 1
      indexY = indexY - 1
    }

    return Tile(indexX.toInt, indexY.toInt, zoom)
  }

//////////////////////////////////////////////////////////////////////////
// normallize tile
//////////////////////////////////////////////////////////////////////////

  **
  ** normallize the proxy tile
  **
  private Void normallize(GTile tile, Int count)
  {
    x := subNormalize(tile.tile.x, count)
    y := subNormalize(tile.tile.y, count)

    tile.proxy = Tile(x, y, tile.tile.z)
  }

  private Int subNormalize(Int x, Int c)
  {
    if (x >= c)
    {
      return x % c
    }
    else if (x < 0)
    {
      Int t := x % c
      if (t >= 0) return t
      return t + c
    }
    else
    {
      return x
    }
  }

//////////////////////////////////////////////////////////////////////////
// static
//////////////////////////////////////////////////////////////////////////

  **
  ** get the envelope of the tile
  **
  static Envelope getEnvelope(Tile tile)
  {
    countX := 2.toFloat.pow(tile.z.toFloat).toInt
    Float sizeX := dis / countX

    minX := (tile.x * sizeX) - Mercator.maxDis
    maxY := Mercator.maxDis - (tile.y * sizeX)

    return Envelope(minX, maxY-sizeX, minX + sizeX, maxY)
  }

  **
  ** get the around tile list by envelope and scale
  **
  static GTile[] getTileSet(Envelope envelope, Float scale, Int minZoom = 1, Int maxZoom = 18)
  {
    zoom := scaleTozoom(scale)
    if (zoom < 0) {
      return [GTile(0, 0, 0)]
    }
    if (zoom < minZoom)
    {
      zoom = minZoom
    }
    if (zoom > maxZoom) {
      zoom = maxZoom
    }

    grid := GEncode(zoom)
    tiles := grid.findAll(envelope)
    return tiles
  }

  **
  ** calculate zoom by scale
  **
  private static Int scaleTozoom(Float scale)
  {
    curScale := originScale

    Int i := -1
    while (curScale < scale*1.5f)
    {
      curScale = curScale * 2f
      i++
    }
    if ( i == -1) return 0
    return i
  }

  static Float preferScale(Float scale)
  {
    curScale := originScale
    while (curScale < scale*0.6f)
    {
      curScale = curScale * 2f
    }
    return curScale
  }
}