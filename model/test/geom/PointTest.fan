//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

internal class PointTest : Test
{
  Void testEqualsObject()
  {
    coord1 := GeoPoint(10f, 20f)
    coord2 := GeoPoint(10.00000000001f, 20f)
    verify(!coord1.equals(coord2))
  }

  Void testApproximateEquals()
  {
    coord1 := GeoPoint(10f, 20f)
    coord2 := GeoPoint(10.00000000001f, 20f)
    verify(coord1.point.approx(coord2.point))
  }
}