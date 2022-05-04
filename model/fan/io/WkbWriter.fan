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
internal class WkbWriter
{
  static const Int none := 0
  static const Int point := 1
  static const Int lineString := 2
  static const Int polygon := 3
  static const Int multiPoint := 4
  static const Int multiLineString := 5
  static const Int multiPolygon := 6
  static const Int geometryCollection := 7

  OutStream out
  new make(OutStream out) { this.out = out }

  Void write(Geometry g)
  {
    writeByteOrder
    type := g.typeof.toNonNullable
    switch (type)
    {
    case GeoPoint#: writeGeoPoint(g)
    case LineString#: writeLineString(g)
    case Polygon#: writePolygon(g)
    case MultiPoint#: writeMultiPoint(g)
    case MultiLineString#: writeMultiLineString(g)
    case MultiPolygon#: writeMultiPolygon(g)
    case GeometryCollection#: writeGeometryCollection(g)
    default: throw ParseErr("unknow type: $type")
    }
  }

  private Void writeGeometryCollection(GeometryCollection ps)
  {
    writeInt(WkbReader.geometryCollection)
    writeMultiGeometry(ps)
  }

  private Void writeInt(Int i)
  {
    out.writeI4(i)
  }

  private Void writeByteOrder()
  {
    i := out.endian == Endian.big ? 0 : 1
    out.write(i)
  }

  private Void writePoint(Point p)
  {
    out.writeF8(p.x)
    out.writeF8(p.y)
  }

  private Void writeGeoPoint(GeoPoint p)
  {
    writeInt(WkbReader.point)
    writePoint(p.point)
  }

  private Void writeLineString(LineString ls)
  {
    writeInt(WkbReader.lineString)
    writePoints(ls.points)
  }

  private Void writePoints(CoordSeq cs)
  {
    writeInt(cs.size)
    cs.each
    {
      writePoint(it)
    }
  }

  private Void writePolygon(Polygon pg)
  {
    writeInt(WkbReader.polygon)
    writeInt(pg.ringCount)
    pg.each |r|
    {
      writePoints(r.points)
    }
  }

  private Void writeMultiGeometry(GeometryCollection gs)
  {
    writeInt(gs.size)
    gs.each
    {
      write(it)
    }
  }

  private Void writeMultiPoint(MultiPoint ps)
  {
    writeInt(WkbReader.multiPoint)
    writeMultiGeometry(ps)
  }

  private Void writeMultiLineString(MultiLineString ps)
  {
    writeInt(WkbReader.multiLineString)
    writeMultiGeometry(ps)
  }

  private Void writeMultiPolygon(MultiPolygon ps)
  {
    writeInt(WkbReader.multiPolygon)
    writeMultiGeometry(ps)
  }
}