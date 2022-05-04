//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**
** Well-Know-Text Reader
**
@Js
internal class WktReader
{
  private Str? text
  private Int pos = 0

  private Str? next() {
    if (pos >= text.size) return null
    buf := StrBuf()
    while (pos < text.size) {
      c := text[pos]
      
      if (c.isAlphaNum || c == '.' || c == '-') {
        buf.addChar(c)
      }
      else {
        if (buf.size > 0) break
        buf.addChar(c)
        ++pos
        break
      }
      ++pos
    }

    return buf.toStr
  }

  private Void skipSpace() {
    while (pos < text.size) {
      if (text[pos] == ' ') pos++
      else break
    }
  }

  new make(Str text) {
    this.text = text
    this.pos = 0
  }

  Geometry read()
  {
    try
    {
      type := next.upper
      skipSpace
      switch (type)
      {
        case "POINT":
          return getPoint()
        case "LINESTRING":
          return getLineString()
        case "POLYGON":
          return getPolygon()
        case "MULTIPOINT":
          return getMultiPoint()
        case "MULTILINESTRING":
          return getMultiPath()
        case "MULTIPOLYGON":
          return getMultiPolygon()
        case "GEOMETRYCOLLECTION":
          return getMultiGeometry()
        default:
          throw ParseErr("unknow type: $type")
      }
    }
    catch(Err e)
    {
      //throw ParseErr("WTK Parse error")
      throw e
    }
  }

  Envelope readEnvelope()
  {
    type := next
    if (type.equalsIgnoreCase("BOX")) return geEnvelop()
    else throw ParseErr("envelop parse error")
  }

//////////////////////////////////////////////////////////////////////////
// sub Method
//////////////////////////////////////////////////////////////////////////

  private GeoPoint getPoint()
  {
    assert(next == "(")
    res := GeoPoint.makeCoord(readCoord())
    assert(next == ")")
    return res
  }

  private LineString getLineString()
  {
    return LineString.makePoints(readPointList())
  }

  private Polygon getPolygon()
  {
    token := next
    assert(token == "(")
    Ring[] rs := [,]
    while (token != ")") {
      ls := LineString.makePoints(readPointList()).toLinearRing
      rs.add(ls)
      token = next
    }

    Ring[] holes := rs[1..-1]
    return Polygon(rs.first, holes)
  }

  private MultiPoint getMultiPoint()
  {
    return MultiPoint(readPointList().map |p->GeoPoint| { GeoPoint.makeCoord(p) })
  }

  private MultiLineString getMultiPath()
  {
    token := next
    assert(token == "(")
    LineString[] rs := [,]
    while (token != ")") {
      ls := LineString.makePoints(readPointList())
      rs.add(ls)
      token = next
    }
    return MultiLineString(rs)
  }

  private MultiPolygon getMultiPolygon()
  {
    token := next
    assert(token == "(")
    Polygon[] rs := [,]
    while (token != ")") {
      ls := getPolygon
      rs.add(ls)
      token = next
    }

    return MultiPolygon(rs)
  }

  private GeometryCollection getMultiGeometry()
  {
    geos := Geometry[,]

    token := next
    assert(token == "(")
    while (token != ")") {
      ls := read
      geos.add(ls)
      token = next
    }
    assert(token == ")")
    return GeometryCollection(geos)
  }

  private Envelope geEnvelop()
  {
    point1 := readCoord()
    assert(next == ",")
    point2 := readCoord()

    return Envelope(point1.x, point1.y, point2.x, point2.y)
  }

//////////////////////////////////////////////////////////////////////////
// helper
//////////////////////////////////////////////////////////////////////////

  private Point readCoord()
  {
    x := Float(next)
    assert(next == " ")
    y := Float(next)
    return Coord(x, y)
  }

  private Point[] readPointList()
  {
    token := next
    assert(token == "(")
    res := Point[,]
    while (token != ")") {
      res.add(readCoord)
      token = next
    }
    return res
  }
}

