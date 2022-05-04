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
using slanRecord

**
** FeatureDataReader
**
mixin FeatureDataReader
{
  abstract Envelope shapeEnvelope()
  abstract Geometry geometry()

  abstract Bool next()
  abstract Obj?[] data()

  abstract Envelope envelope()
  abstract Metadata metadata()
  abstract TableDef schema()

  abstract Void close()
}