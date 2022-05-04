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
** ShpDataReader
**
class ShpDataReader : FeatureDataReader
{
  private ShapefileReader shpReader
  private DbfReader dbfReader
  private Int index := -1
  const Int size

  new make(Uri path, Charset charset := Charset.defVal)
  {
    shpReader = ShapefileReader(path)
    dbfReader = DbfReader(shpReader.path + ".dbf", charset)
    size = shpReader.shapeCount
  }

  override  Void close() { shpReader.close; dbfReader.close }

  override Envelope envelope() { shpReader.envelop }

  override Geometry geometry() { shpReader.getGeometry(index) }

  override Bool next()
  {
    if (index == size -1 || !dbfReader.next) return false
    ++index
    return true
  }

  override Metadata metadata()
  {
    Metadata
    {
      it.name = shpReader.name
      it.type = shpReader.geometryType
      it.crs = SpatialRef.defVal
    }
  }

  override Envelope shapeEnvelope() { shpReader.getShapeEnvelop(index) }

  override TableDef schema() { dbfReader.schema(shpReader.name) }

  override Obj?[] data() { dbfReader.values }
}