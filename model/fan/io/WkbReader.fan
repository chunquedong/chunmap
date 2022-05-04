//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-24  Jed Young  Creation
//

**
** Well-known Binary Representation for Geometry
**
@Js
internal class WkbReader
{
  static const Int none := 0
  static const Int point := 1
  static const Int lineString := 2
  static const Int polygon := 3
  static const Int multiPoint := 4
  static const Int multiLineString := 5
  static const Int multiPolygon := 6
  static const Int geometryCollection := 7

  InStream in
  new make(InStream in) { this.in = in }

  Geometry read()
  {
    in.endian = readByteOrder
    type := readInt
    Geometry? g
    switch (type)
    {
    case point: g = readGeoPoint
    case lineString: g = readLineString
    case polygon: g = readPolygon
    case multiPoint: g = readMultiPoint
    case multiLineString: g = readMultiLineString
    case multiPolygon: g = readMultiPolygon
    case geometryCollection: g = readGeometryCollection
    default: throw ParseErr("unknow type: $type")
    }
    return g
  }

  private GeometryCollection readGeometryCollection()
  {
    n := readInt
    geometrys := Geometry[,] { capacity = n }
    n.times
    {
      geometrys.add(read)
    }
    return GeometryCollection(geometrys)
  }

  private Int readInt()
  {
    in.readU4
  }

  private Endian readByteOrder()
  {
    i := in.readS1
    if ( i == 0 ) return Endian.big
    else if (i ==1 ) return Endian.little
    throw ParseErr("unknow byteOrder: $i")
  }

  private Point readPoint()
  {
    Coord(in.readF8, in.readF8)
  }

  private GeoPoint readGeoPoint()
  {
    return GeoPoint.makeCoord(readPoint)
  }

  private LineString readLineString()
  {
    n := readInt
    points := Point[,] { capacity = n }
    n.times
    {
      points.add(readPoint)
    }
    return LineString.makePoints(points)
  }

  private Polygon readPolygon()
  {
    n := readInt
    holes := Ring[,] { capacity = n-1 }
    shell := readLineString.toLinearRing

    (n-1).times
    {
      holes.add(readLineString.toLinearRing)
    }
    return Polygon(shell, holes)
  }

  private MultiPoint readMultiPoint()
  {
    n := readInt
    points := GeoPoint[,] { capacity = n }
    n.times
    {
      points.add(read)
    }
    return MultiPoint(points)
  }

  private MultiLineString readMultiLineString()
  {
    n := readInt
    rings := LineString[,] { capacity = n }
    n.times
    {
      rings.add(read)
    }
    return MultiLineString(rings)
  }

  private MultiPolygon readMultiPolygon()
  {
    n := readInt
    rings := Polygon[,] { capacity = n }
    n.times
    {
      rings.add(read)
    }
    return MultiPolygon(rings)
  }
}