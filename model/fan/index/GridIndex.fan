//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-04  Jed Young  Creation
//

**
** Grid index
**
const class GridIndex
{
  const Int deep

  const Grid grid

  new make(Envelope env, Int deep)
  {
    this.deep = deep
    grid = Grid(env)
  }

  **
  ** find all keys that intersects geometry
  **
  Str[] geomKeys(Geometry geom)
  {
    keys := Str[,]
    Tile[] tiles := grid.findTiles(geom.envelope, deep)
    tiles.each |tile|
    {
      Envelope env2 := grid.tileEnvelope(tile)
      if (env2.intersectsGeometry(geom))
      {
        keys.add(tile.toKey)
      }
    }
    //TODO Fix this bug
    if (keys.isEmpty) throw Err("grid index is empty: $geom")
    return keys
  }

  **
  ** tile key of the point at
  **
  Str pointAt(Point p)
  {
    grid.getTile(p, deep, false).toKey
  }

  **
  ** find all keys that intersects env
  **
  Str[] findKeys(Envelope env)
  {
    keys := Str[,]
    Tile[] tiles := grid.findTiles(env, deep)
    tiles.each |tile|
    {
      Envelope env2 := grid.tileEnvelope(tile)
      if (env2.intersects(env))
      {
        keys.add(tile.toKey)
      }
    }
    return keys
  }
}