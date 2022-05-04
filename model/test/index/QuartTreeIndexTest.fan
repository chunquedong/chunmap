//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-04  Jed Young  Creation
//

class QuartTreeIndexTest : Test
{
  Void testGetKey()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    qt := QuartTreeIndex(env, 2)
    key1 := qt.key(env)
    verifyEq(key1, "")

    key2 := qt.key(Envelope(0f, 0f, 0f, 0f))
    verifyEq(key2, "")

    key3 := qt.key(Envelope(-90f, -45f, -60f, -25f))
    verifyEq(key3, "0")

    key4 := qt.key(Envelope(90f, -45f, 60f, -25f))
    verifyEq(key4, "1")

    key5 := qt.key(Envelope(-90f, 45f, -60f, 25f))
    verifyEq(key5, "2")

    key6 := qt.key(Envelope(90f, 45f, 60f, 25f))
    verifyEq(key6, "3")
  }

  Void testGetKey2()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    qt := QuartTreeIndex(env, 2)

    key7 := qt.key(Envelope(113.345f, 36.64f, 114.435f, 37.45676f))
    verifyEq(key7.size, 1)
  }

  Void testFindKeys()
  {
    env := Envelope(-180f, -90f, 180f, 90f)
    qt := QuartTreeIndex(env, 2)
    key1 := qt.findKeys(env)
    echo(key1)
    verifyEq(key1.size, 5)

    key2 := qt.findKeys(Envelope(0f, 0f, 0f, 0f))
    verifyEq(key1.size, 5)

    key3 := qt.findKeys(Envelope(-90f, -45f, -60f, -25f))
    verifyEq(key3, ["","0"])

    key4 := qt.findKeys(Envelope(90f, -45f, 60f, -25f))
    verifyEq(key4, ["","1"])
  }
}