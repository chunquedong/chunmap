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
** FeatureSet
**
@Js
@Serializable { simple = true }
abstract class FeatureSet : GeoDataSource
{
  abstract This add(Feature f)
  abstract Feature? remove(Feature f)

//////////////////////////////////////////////////////////////////////////
// Field
//////////////////////////////////////////////////////////////////////////

  override Envelope envelope {
    get {
        if (dirty) {
            recalcuEnvelope
        }
        return &envelope
    }
  }
  override Metadata metadata := Metadata.defVal
  override TableDef schema

  //option field
  Obj? dataResources
  Uri? uri
  [Str:Str]? options
  Bool dirty = false

  new make(Envelope envelope, TableDef schema)
  {
    this.envelope = envelope
    this.schema = schema
  }

  Void recalcuEnvelope()
  {
    eb := EnvelopeBuilder.makeNone
    each(Condition.empty) |Feature f|
    {
      eb.merge(f.envelope)
    }
    envelope = eb.toEnvelope
  }

}