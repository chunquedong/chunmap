//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-09  Jed Young  Creation
//

**
** Model a geometry. Base class for `Point`,`LineString`,`Polygon`...
**
@Js
@Serializable { simple = true }
abstract class Geometry
{
  **
  ** is simple geometry
  **
  abstract Bool isValid()

  **
  ** Point's boundary is null
  **
  abstract Geometry? getBoundary()

  **
  ** get the envelope of Geometry
  **
  abstract Envelope envelope()

  **
  ** geometry Type
  **
  abstract GeometryType geometryType()

  ** precision of this geometry
  Precision precision := Precision.none { private set }

  ** do transform, return the result
  abstract Geometry transform(|Point->Point| transf)

  ** echo point until return non-null
  abstract Obj? eachPoint(|Point->Obj?| trace)

  ** from WKT string
  static Geometry fromStr(Str text, Precision precision := Precision.none)
  {
    WktReader(text).read()
  }

  static Geometry fromStream(InStream in)
  {
    WkbReader(in).read
  }

  Void save(OutStream out)
  {
    WkbWriter(out).write(this)
  }

  **
  ** make a new geometry as the precision.
  ** if current precison leass the given precision ,do nothing and return this
  **
  Geometry makePrecision(Precision precision)
  {
    if (this.precision <= precision) return this
    ng := transform(precision.trans)
    ng.precision = precision
    return ng
  }

  Geometry clone() {
    return transform |p| { return p }
  }
}


