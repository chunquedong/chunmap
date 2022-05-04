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
** Memory QuartTree
**
class QuartTree : FeatureSet
{
  QuartNode root
  Feature[] external

  new make(Envelope env, TableDef schema) : super(env, schema)
  {
    root = QuartNode(envelope, 0, 6)
    external = [,]
  }

  override This add(Feature f)
  {
    if (root.envelope.intersects(f.envelope))
    {
      root.add(f)
    }
    else
    {
      external.add(f)
    }
    return this
  }

  override Feature? remove(Feature f)
  {
    if (root.envelope.intersects(f.envelope))
    {
      return root.remove(f)
    }
    else
    {
      return external.remove(f)
    }
  }

  override Feature? find(Condition condition, |Feature->Bool| filter)
  {
    throw Err("TODO")
  }

  override Void each(Condition condition, |Feature| filter)
  {
    root.each(filter, envelope)

    external.each |f|
    {
      filter(f)
    }
  }
}