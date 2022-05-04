//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

internal class LineStringTest : Test
{

  Void testInsertPoint()
  {
    p1 := Coord(10f, 20f)
    p2 := Coord(30f, 60f)
    p3 := Coord(20f, 40f)
    p4 := Coord(40f, 80f)

    points := Point[p1, p2, p4]
    ls := LineString.makePoints(points)

    les := CoordSeqBuf.makeCoordSeq(ls.points)
    les.tryPutPointExactly(p3)
    ls2 := LineString(les.toCoordSeq)

    les2 := CoordSeqBuf.makeCoordSeq(ls.points)
    les.tryPutPointExactly(p2)
    ls3 := LineString(les2.toCoordSeq)

    exp2 := WktReader("LINESTRING(10.0 20.0,20.0 40.0,30.0 60.0,40.0 80.0)").read
    verify(exp2.equals(ls2))
    exp3 := WktReader("LINESTRING(10.0 20.0,30.0 60.0,40.0 80.0)").read
    verify(exp3.equals(ls3))
  }

  Void testContainLineString()
  {
    p1 := Coord(10f, 20f)
    p2 := Coord(20f, 40f)
    p3 := Coord(30f, 60f)
    p4 := Coord(40f, 80f)
    p5 := Coord(50f, 100f)

    points := Point[p1, p3, p5]
    ls := LineString.makePoints(points)

    points2 := Point[p2, p4]
    ls2 := LineString.makePoints(points2)

    verify(ls.containLineString(ls2))
  }

  Void testGetLength()
  {
    p1 := Coord(1f, 1f)
    p2 := Coord(1f, 2f)
    p3 := Coord(4f, 2f)

    points := Point[p1, p2, p3]
    ls := LineString.makePoints(points)

    verify(ls.length == 4f)
  }

  Void testJoin()
  {
    g := WktReader("LineString(334 23,1230.09 234)").read
    g2 := WktReader("LineString(32 34,334 23)").read
    l := (LineString)g
    l2 := (LineString)g2

    lineEditor := CoordSeqBuf.makeCoordSeq(l.points)
    lineEditor.join(l2.points)
    rl2 := LineString(lineEditor.toCoordSeq)

    s := WktReader("LINESTRING(32.0 34.0,334.0 23.0,1230.09 234.0)").read
    verify(s.equals(rl2))
  }

  Void testChain()
  {
    g := WktReader("LINESTRING(0 4,4 0)").read
    g2 := WktReader("LINESTRING(1 1,2 1,2 3)").read
    l := (LineString)g
    l2 := (LineString)g2

    bag := l.intersection(l2)
    verify(!bag.isEmpty)
  }

  Void testChain2()
  {
    g := WktReader("LINESTRING(1.0 6.0,5.999998414659173 1.0039816335536662,1.0079632645824341 -3.999993658637697,-3.9999857319385903 0.9880551094385923,1.0 6.0)").read
    ls := (LineString)g
    g2 := WktReader("LINESTRING(-2.639991350383829 -1.7999950537374092,-1.8399918576928131 -1.7999950537374092,-1.8399918576928131 -0.9999955610463935,-2.639991350383829 -0.9999955610463935,-2.639991350383829 -1.7999950537374092)").read
    ls2 := (LineString)g2

    bag := ls.intersection(ls2)
    verify(!bag.isEmpty)
  }

  Void testChain3()
  {
    g := WktReader("LINESTRING(-4.125146582183989 2.162505569897099,-3.4010910293343892 2.162505569897099,-3.4010910293343892 2.8865611227466985,-4.125146582183989 2.8865611227466985,-4.125146582183989 2.162505569897099)").read
    ls := (LineString)g
    g2 := WktReader("LINESTRING(1.0 6.0,5.75429730253235 2.5481140652851213,3.9440778098389764 -3.0413371363465505,-1.9311899958501355 -3.0506944106199967,-3.759204394078429 2.5329623398454943,1.0 6.0)").read
    ls2 := (LineString)g2

    bag := ls.intersection(ls2)
    verify(!bag.isEmpty)
  }

  Void testChain4()
  {
    g := WktReader("LINESTRING(-3.9419812736325976 1.0200031579984215,-3.141981780941582 1.0200031579984215,-3.141981780941582 1.8200026506894371,-3.9419812736325976 1.8200026506894371,-3.9419812736325976 1.0200031579984215)").read
    ls := (LineString)g
    g2 := WktReader("LINESTRING(1.0 6.0,5.328799197461722 3.502298445041029,5.332779000281329 -1.4954009967780992,1.0079632645824363 -3.999993658637697,-3.324808414448497 -1.5091895461115477,-3.3367478128123684 3.488497218818446,1.0 6.0)").read
    ls2 := (LineString)g2

    bag := ls.intersection(ls2)
    verify(!bag.isEmpty)
  }

  Void testChain5()
  {
    g := WktReader("LINESTRING(1.0 6.0,5.999998414659173 1.0039816335536662,1.0079632645824341 -3.999993658637697,-3.9999857319385903 0.9880551094385923,1.0 6.0)").read
    ls := (LineString)g
    g2 := WktReader("LINESTRING(3.3400048574815147 -2.1999948000829175,4.140004350172529 -2.1999948000829175,4.140004350172529 -1.399995307391901,3.3400048574815147 -1.399995307391901,3.3400048574815147 -2.1999948000829175)").read
    ls2 := (LineString)g2

    bag := ls.intersection(ls2)
    verify(!bag.isEmpty)
  }
}