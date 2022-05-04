//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**************************************************************************
** MultiPoint
**************************************************************************
@Js
class MultiPoint : GeometryCollection
{
  new make(GeoPoint[] geometrys) : super.make(geometrys) {}

  override GeometryType geometryType() { GeometryType.multiPoint }

  override Str toStr() { toMyString("MULTIPOINT ", |GeoPoint g->Str| { "$g.x $g.y" } ) }
}

**************************************************************************
** MultiLineString
**************************************************************************
@Js
class MultiLineString : GeometryCollection
{
  new make(LineString[] geometrys) : super.make(geometrys) {}

  override GeometryType geometryType() { GeometryType.multiLineString }

  override Str toStr() { toMyString("MULTILINESTRING ", |LineString g->Str| { g.toMyString } ) }
}

**************************************************************************
** MultiPolygon
**************************************************************************
@Js
class MultiPolygon : GeometryCollection
{
  new make(Polygon[] geometrys) : super.make(geometrys) {}

  override GeometryType geometryType() { GeometryType.multiPolygon }

  override Str toStr() { toMyString("MULTIPOLYGON ", |Polygon g->Str| { g.toMyString } ) }
}

