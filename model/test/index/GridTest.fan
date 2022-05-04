//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-03  Jed Young  Creation
//


class GridTest : Test
{
  Void testKey()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    grid := Grid(env)

    tile := Tile( 0, 0, 0)
    verifyEq(tile.toKey, "")
    t := Tile.fromKey("")
    verifyEq(tile, t)

    // +---+---+
    // | 2 | 3 |
    // +---+---+
    // | 0 | 1 |
    // +---+---+

    tile2 := Tile( 0, 0, 1)
    verifyEq(tile2.toKey, "0")
    t2 := Tile.fromKey("0")
    verifyEq(tile2, t2)

    tile3 := Tile( 1, 0, 1)
    verifyEq(tile3.toKey, "1")

    tile4 := Tile( 1, 1, 1)
    verifyEq(tile4.toKey, "3")

    tile5 := Tile( 0, 1, 1)
    verifyEq(tile5.toKey, "2")


    tile6 := Tile( 1, 1, 2)
    verifyEq(tile6.toKey, "03")
    t6 := Tile.fromKey("03")
    verifyEq(tile6, t6)
  }

  Void testEnvelope()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    grid := Grid(env)

    tile := Tile( 0, 0, 0)
    verifyEq(grid.tileEnvelope(tile), env)

    tile2 := Tile( 0, 0, 1)
    verifyEq(grid.tileEnvelope(tile2), Envelope(-180f, -90f, 0f, 0f))

    tile6 := Tile( 1, 1, 2)
    verifyEq(grid.tileEnvelope(tile6), Envelope(-90f, -45f, 0f, 0f))
  }

  Void testFindTiels()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    grid := Grid(env)

    tile := Tile( 0, 0, 0)
    tiles := grid.findTiles(env, 0)
    verifyEq(tiles.size, 1)
    verifyEq(tiles[0], tile)

    //tile2 := CTile(grid, 0, 0, 1)
    tiles2 := grid.findTiles(env, 1)
    verifyEq(tiles2.size, 4)

    tile6 := Tile( 1, 1, 2)
    tiles6 := grid.findTiles(Envelope(-90f, -45f, 0f, 0f), 2)
    verifyEq(tiles6[0], tile6)

  }
}