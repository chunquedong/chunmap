//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-10  Jed Young  Creation
//

using chunmapModel
using chunmapView

**
** longitude and latitude Grid
**
class Graticules
{
  static VectorLayer createGrid()
  {
    geometrys := Geometry[,]
    addGeometry(geometrys)

    layer := LayerFactory.createGeometryLayer(geometrys, GeometryType.lineString)
    return layer
  }

  static private Void addGeometry(Geometry[] geometrys)
  {
    //-180<x>180
    //-90<y>90
    for (i := -90; i <= 90; i += 10)
    {
      addWeiXian(geometrys, i.toFloat)
    }
    for (i := -180; i <= 180; i += 10)
    {
      addJingXian(geometrys, i.toFloat)
    }
  }

  static private Void addWeiXian(Geometry[] geometrys, Float weidu)
  {
    ls := LineString.makePoints( [ Coord(-180f, weidu), Coord(180f, weidu) ])
    geometrys.add(ls)
  }

  static private Void addJingXian(Geometry[] geometrys, Float jingdu)
  {
    ls := LineString.makePoints( [Coord(jingdu, -90f), Coord(jingdu, 90f)])
    geometrys.add(ls)
  }
}