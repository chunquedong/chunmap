//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-01  Jed Young  Creation
//

using chunmapModel
using chunmapData
using chunmapRaster

@Js
@Serializable
abstract class RenderFilter
{
  abstract Bool isPass(Feature f)
}

**
** filter for shape
**
@Js
class ShapeFilter : RenderFilter
{
  Int fieldIndex := -1
  Str operator := "!="
  Str value := ""
  Range? range
  Bool except := false

  override Bool isPass(Feature f)
  {
    if (fieldIndex == -1) return true
    
    if (f isnot ShapeFeature) return false
    ShapeFeature shp := f

    type := shp.schema.get(fieldIndex).type
    val := shp.get(fieldIndex)

    if (type.toNonNullable == Int#.toNonNullable)
    {
      switch (operator)
      {
        case "==":
        return (val as Int) == value.toInt
        case "!=":
        return (val as Int) != value.toInt
        case ">":
        return (val as Int) > value.toInt
        case "<":
        return (val as Int) < value.toInt
      }
    }
    else if (type.toNonNullable == Float#.toNonNullable)
    {
      switch (operator)
      {
        case "==":
        return (val as Float) == value.toFloat
        case "!=":
        return (val as Float) != value.toFloat
        case ">":
        return (val as Float) > value.toFloat
        case "<":
        return (val as Float) < value.toFloat
      }
    }
    else if (type.toNonNullable == Str#.toNonNullable)
    {
      if (range == null)
      {
        switch (operator)
        {
          case "==":
          return (val as Str) == value.toStr
          case "!=":
          return (val as Str) != value.toStr
          case ">":
          return (val as Str) > value.toStr
          case "<":
          return (val as Str) < value.toStr
        }
      }
      else if (range.end < value.toStr.size)
      {
        switch (operator)
        {
          case "==":
          return (val as Str) == value.toStr[range]
          case "!=":
          return (val as Str) != value.toStr[range]
          case ">":
          return (val as Str) > value.toStr[range]
          case "<":
          return (val as Str) < value.toStr[range]
        }
      }
      else
      {
        return false
      }
    }
    else
    {
      switch (operator)
      {
        case "==":
        return val == type.make([value])
        case "!=":
        return val != type.make([value])
        case ">":
        return val > type.make([value])
        case "<":
        return val < type.make([value])
      }
    }
    return true
  }
}