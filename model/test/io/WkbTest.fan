//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

internal class WkbTest : Test
{
  Void run(Geometry g)
  {
    buf := Buf()
    g.save(buf.out)
    buf.flip
    g2 := Geometry.fromStream(buf.in)

    verifyEq(g2, g)
  }

  Void testReadPoint()
  {
    g := WktReader("POINT(1230.09 234)").read
    run(g)
  }

  Void testReadLineString()
  {
    g := WktReader("LineString(1230.09 234,334 23)").read
    run(g)
  }

  Void testReadPolygon()
  {
    g := WktReader("POLYGON((10 20,1230.09 234,334 23,10 20),(30 20,45 33,23 10,30 20))").read
    run(g)
  }

  Void testReadMultiPoint()
  {
    g := WktReader("MULTIPOINT(1230.09 234,334 23)").read
    run(g)
  }

  Void testReadMultiLineString()
  {
    g := WktReader("MULTILINESTRING((10 20,1230.09 234,334 23,10 20),(30 20,45 33,23 10,30 20))").read
    run(g)
  }

  Void testReadMultiPolygon()
  {
    g := WktReader("MULTIPOLYGON(((10 20,40 50,60 70,10 20)),((0 0,0 100,100 100,100 0,0 0)))").read
    run(g)
  }

  Void testReadMultiGeometry()
  {
    g := WktReader("GEOMETRYCOLLECTION(MULTIPOLYGON(((10 20,40 50,60 70,10 20)),((0 0,0 100,100 100,100 0,0 0))),POINT(1230.09 234))").read
    run(g)
  }
}