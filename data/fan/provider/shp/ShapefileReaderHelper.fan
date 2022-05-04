//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using chunmapModel

**
** ShapefileReaderHelper
**
internal const class ShapefileReaderHelper
{
  Envelope readEnvelop(Buf br)
  {
    xMin := br.readF8
    yMin := br.readF8
    xMax := br.readF8
    yMax := br.readF8

    return Envelope(xMin, yMin, xMax, yMax)
  }

  Point readPoint(Buf br)
  {
    x := br.readF8
    y := br.readF8

    return Coord(x, y)
  }

  MultiPoint readMultiPoint(Buf br)
  {
    env := readEnvelop(br)
    numPoints := readLittleU4(br)
    points := readPointList(br, numPoints)


    GeoPoint[] geoPointList := [,]
    points.each { geoPointList.add(GeoPoint.makeCoord(it)) }
    mPoint := MultiPoint(geoPointList)
    //mPoint._setEnvelop(env)
    return mPoint
  }

  private CoordArray readPointList(Buf br, Int num)
  {
    points := CoordArray(num)
    for (i:=0; i<num*2; ++i)
    {
      points.setCoord(i, br.readF8)
    }
    return points
  }

  private LineString readLineString(Buf br, Int num)
  {
    points := readPointList(br, num)
    return LineString(points)
  }

  private Ring readRing(Buf br, Int num)
  {
    points := readPointList(br, num)
    return Ring(points)
  }

  MultiLineString readMultiLine(Buf br)
  {
    env := readEnvelop(br)

    Int numParts := readLittleU4(br)
    Int numPoints := readLittleU4(br)

    // parts index
    parts := Int[,] { capacity = numParts }
    numParts.times
    {
      parts.add(readLittleU4(br))
    }

    // read lineString
    multiPath := LineString[,] { capacity = numParts }
    numParts.times |i|
    {
      LineString? ls
      if (i == (numParts - 1))
      {
        // last one
        last := numPoints
        ls = readLineString(br, last - parts[i])
      }
      else
      {
        ls = readLineString(br, parts[i + 1] - parts[i])
      }
      multiPath.add(ls)
    }
    mls := MultiLineString(multiPath)
    //mls._setEnvelop(env)
    return mls
  }

  // readMultiPolygon
  MultiPolygon readMultiPolygon(Buf br)
  {
    env := readEnvelop(br)

    numParts := readLittleU4(br)
    numPoints := readLittleU4(br)

    // part index
    parts := Int[,] { capacity = numParts }
    numParts.times
    {
      parts.add(readLittleU4(br))
    }

    // read ring
    polygons := Polygon[,] { capacity = numParts }
    numParts.times |i|
    {
      Ring? r
      if (i == (numParts - 1))
      {
        //last one
        last := numPoints
        r = readRing(br, last - parts[i])
      }
      else
      {
        r = readRing(br, parts[i + 1] - parts[i])
      }

      pg := Polygon(r)
      polygons.add(pg)
    }
    mpolygon := MultiPolygon(polygons)
    //mpolygon._setEnvelop(env)
    return mpolygon
  }

//////////////////////////////////////////////////////////////////////////
// reverseBytes
//////////////////////////////////////////////////////////////////////////

  Int readLittleU4(Buf br)
  {
    br.readU4
  }

  Int readBigU4(Buf br)
  {
    br.endian = Endian.big
    n := br.readU4

    br.endian = Endian.little
    return n
  }

  Float readBigF8(Buf br)
  {
    br.endian = Endian.big
    n := br.readF8

    br.endian = Endian.little
    return n
  }
}