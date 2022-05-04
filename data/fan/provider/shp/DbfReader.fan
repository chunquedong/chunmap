//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-03  Jed Young  Creation
//

using [java]com.linuxense.javadbf
using [java]java.io

using chunmapModel
using slanRecord

**
** DbfReader
**
class DbfReader
{
  private DBFReader dbfReader
  private FileInputStream inputStream
  private Obj?[]? lastRecord

  new make(Str apath, Charset charset := Charset.defVal)
  {
    inputStream = FileInputStream(apath)
    dbfReader = DBFReader(inputStream)
    dbfReader.setCharactersetName(charset.name)
  }

  Obj?[] values() { lastRecord }

  Bool next()
  {
    lastRecord = dbfReader.nextRecord
    return lastRecord != null
  }

  TableDef schema(Str tname)
  {
    s := TableDefBuilder(tname, ShapeFeature#)
    for (i:=0; i< dbfReader.getFieldCount(); i++)
    {
      name := dbfReader.getField(i).getName()
      Type? type
      typeChar := dbfReader.getField(i).getDataType()
      if (typeChar == 'N' || typeChar == 'F') type = Num#
      else if (typeChar == 'C') type = Str#
      else if (typeChar == 'L') type = Bool#
      else if (typeChar == 'D') type = DateTime#
      else type = Obj#

      //f := CField(name, type)
      s.addColumn(name, type)
    }
    return s.build
  }

  Void close() { inputStream.close }
}