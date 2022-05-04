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
** ShapefileReader
**
internal class ShapefileReader
{
  Str path { private set }
  Str name { private set }
  private Buf shaperf
  private Buf indexrf
  GeometryType? geometryType { private set }
  private Int shapefileType
  Int shapeCount { private set }
  Int version { private set }
  Envelope? envelop { private set }
  private const ShapefileReaderHelper helper := ShapefileReaderHelper()

  new make(Uri uri)
  {
    this.name = uri.basename
    this.path = uri.toStr[0..<uri.toStr.indexr(".")]

    shaperf = (path + ".shp").toUri.toFile.mmap("r")
    indexrf = (path + ".shx").toUri.toFile.mmap("r")

    shaperf.endian = Endian.little
    indexrf.endian = Endian.little

    readHeader
  }

  Void close()
  {
    indexrf.close
    shaperf.close
  }

//////////////////////////////////////////////////////////////////////////
// read
//////////////////////////////////////////////////////////////////////////

  private Void readHeader()
  {
    // File No.
    indexrf.seek(0)
    Int ii := helper.readBigU4(indexrf)
    if (ii != 9994) throw IOErr("bad file")

    // File length
    indexrf.seek(24)
    Int fileLength := 2 * helper.readBigU4(indexrf) // 16bits is one word

    // Shape number
    shapeCount = (fileLength - 100) / 8 // 100bytes header. offset: 4bytes, length: 4bytes. each shape is 8bytes.

    // version
    version = helper.readLittleU4(indexrf)

    // shape type
    shapefileType = helper.readLittleU4(indexrf)
    geometryType = ShapefileType.getShapeType(shapefileType)

    // envelope
    envelop = helper.readEnvelop(indexrf)

    //dump
  }

  ** debug
  private Void dump()
  {
    echo("================")
    this.typeof.fields.each |f|
    {
      echo("$f.name: ${f.get(this)}")
    }
    echo("================")
  }

  Geometry? getGeometry(Int id)
  {
    index := getIndex(id) + 8 // +8 for skip the header, record num and length.
    shaperf.seek(index)
    type := helper.readLittleU4(shaperf)
    Geometry? geometry

    switch (type)
    {
      case ShapefileType.none:
        return null

      case ShapefileType.point:
        geometry = GeoPoint.makeCoord(helper.readPoint(shaperf))

      case ShapefileType.multipoint:
        geometry = helper.readMultiPoint(shaperf)

      case ShapefileType.polyLine:
        geometry = helper.readMultiLine(shaperf)

      case ShapefileType.polygon:
        geometry = helper.readMultiPolygon(shaperf)

      default:
        throw UnsupportedErr("this ShapefileType is unsupported")
    }
    return geometry
  }

  // from index file
  Int getIndex(Int id)
  {
    indexrf.seek(id * 8 + 100)
    return 2 * helper.readBigU4(indexrf) // 16bits is one word
  }

  Envelope getShapeEnvelop(Int id)
  {
    index := getIndex(id) + 8 // +8 for skip the header, record num and length.
    shaperf.seek(index)
    type := helper.readLittleU4(shaperf)

    Envelope? elp
    if (type == ShapefileType.none) return Envelope(0f, 0f, 0f, 0f)
    else if (type == ShapefileType.point || type == ShapefileType.pointM ||
             type == ShapefileType.pointZ)
    {
      elp = GeoPoint.makeCoord(helper.readPoint(shaperf)).envelope
    }
    else elp = helper.readEnvelop(shaperf)

    return elp
  }
}