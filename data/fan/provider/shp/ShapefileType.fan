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
** ShapefileType
**
internal const class ShapefileType
{
  static const Int none := 0
  static const Int point := 1
  static const Int polyLine := 3
  static const Int polygon := 5
  static const Int multipoint := 8
  static const Int pointZ := 11
  static const Int polyLineZ := 13
  static const Int polygonZ := 15
  static const Int multiPointZ := 18
  static const Int pointM := 21
  static const Int polyLineM := 23
  static const Int polygonM := 25
  static const Int multiPointM := 28
  static const Int multiPatch := 31

  static GeometryType getShapeType(Int shapefileType)
  {
    switch (shapefileType)
    {
      case ShapefileType.none:
        return GeometryType.none

      case ShapefileType.point:
      case ShapefileType.pointM:
      case ShapefileType.pointZ:
        return GeometryType.point

      case ShapefileType.multipoint:
      case ShapefileType.multiPointM:
      case ShapefileType.multiPointZ:
        return GeometryType.multiPoint

      case ShapefileType.polyLine:
      case ShapefileType.polyLineM:
      case ShapefileType.polyLineZ:
        return GeometryType.multiLineString

      case ShapefileType.polygon:
      case ShapefileType.polygonM:
      case ShapefileType.polygonZ:
        return GeometryType.multiPolygon

      default:
        throw ArgErr("this ShapefileType is unsupported")
    }
  }
}