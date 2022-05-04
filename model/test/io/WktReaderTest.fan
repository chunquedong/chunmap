//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

internal class WktReaderTest : Test
{
  Void testReadPoint()
  {
    g := WktReader("POINT (1230.09 234)").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadLineString()
  {
    g := WktReader("LineString(1230.09 234,334 23)").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadPolygon()
  {
    g := WktReader("POLYGON((10 20,1230.09 234,334 23,10 20),(30 20,45 33,23 10,30 20))").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadMultiPoint()
  {
    g := WktReader("MULTIPOINT(1230.09 234,334 23)").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadMultiLineString()
  {
    g := WktReader("MULTILINESTRING((10 20,1230.09 234,334 23,10 20),(30 20,45 33,23 10,30 20))").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadMultiPolygon()
  {
    g := WktReader("MULTIPOLYGON(((10 20,40 50,60 70,10 20)),((0 0,0 100,100 100,100 0,0 0)))").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }

  Void testReadMultiGeometry()
  {
    g := WktReader("GEOMETRYCOLLECTION(MULTIPOLYGON(((10 20,40 50,60 70,10 20)),((0 0,0 100,100 100,100 0,0 0))),POINT(1230.09 234))").read
    g2 := WktReader(g.toStr).read
    verifyEq(g2, g)
  }
}