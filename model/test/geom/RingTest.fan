//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

internal class RingTest : Test
{
  Void testContainLineStringIn()
  {
    g := WktReader("LINESTRING(1 2,3 1,4 0,3 -2,0 0,1 2)").read
    lr := ((LineString)g).toLinearRing

    g2 := WktReader("LINESTRING(3 1,1 2,0 0)").read
    l2 := (LineString)g2
    verify(lr.containLineStringIn(l2))
    verify(lr.clockwise)
  }

  Void containInTest()
  {
    g := WktReader("LINESTRING(1 2,3 1,4 0,3 -2,0 0,1 2)").read
    lr := ((LineString)g).toLinearRing
    p1 := GeoPoint(1f, 0f)
    p2 := GeoPoint(1f, 2f)
    p3 := GeoPoint(2f, 3f)
    p4 := GeoPoint(0.5f, 1f)

    verify(lr.containIn(p1))
    verify(lr.containIn(p2))
    verify(!lr.containIn(p3))
    verify(lr.containIn(p4))
  }
}