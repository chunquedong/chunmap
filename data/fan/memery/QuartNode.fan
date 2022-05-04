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
** QuartNode
**
class QuartNode
{
  private Feature[]? list := null
  private Int deep
  private Int maxDeep
  private Bool isLeaf := true
  Envelope envelope { private set }
  /*
     2 | 3
     --+--
     0 | 1
  */
  QuartNode[]? subNode

  new make(Envelope envelope, Int deep, Int maxDeep)
  {
    this.envelope = envelope
    this.deep = deep
    this.maxDeep = maxDeep
  }

//////////////////////////////////////////////////////////////////////////
// add and remove
//////////////////////////////////////////////////////////////////////////

  This add(Feature f)
  {
    if (!envelope.intersects(f.envelope)) return this
    if (isLeaf)
    {
      if (list == null)
      {
        list = Feature[,]
        list.add(f)
        return this
      }

      if (deep < maxDeep && list.size > 4)
      {
        createLeaf
        fillDataToSubNode
        insertToSubNode(f)
        return this
      }

      list.add(f)
    }
    else
    {
      insertToSubNode(f)
    }
    return this
  }

  private Void createLeaf()
  {
    Point p := envelope.center
    Envelope? env

    env = Envelope.makePoints(envelope.minPoint, p)
    subNode0 := QuartNode(env, deep + 1, maxDeep)

    env = Envelope.makePoints(envelope.rightDown, p)
    subNode1 := QuartNode(env, deep + 1, maxDeep)

    env = Envelope.makePoints(envelope.leftUp, p)
    subNode2 := QuartNode(env, deep + 1, maxDeep)

    env = Envelope.makePoints(envelope.maxPoint, p)
    subNode3 := QuartNode(env, deep + 1, maxDeep)

    subNode = QuartNode[subNode0, subNode1, subNode2, subNode3]
  }

  private Void fillDataToSubNode()
  {
    list.each |f|
    {
      insertToSubNode(f)
    }
    isLeaf = false
    list = null
  }

  private Void insertToSubNode(Feature f)
  {
    subNode.each |sub|
    {
      sub.add(f)
    }
  }

  Feature? remove(Feature f)
  {
    if (!envelope.intersects(f.envelope)) return null
    if (isLeaf)
    {
      if (list == null) return null

      return list.remove(f)
    }
    else
    {
      Bool isRemove := false
      subNode.each |sub|
      {
        if (sub.remove(f) != null)
        {
          isRemove = true
        }
      }
      return isRemove ? f : null
    }
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  Void each(|Feature| filter, Envelope? envelope := null)
  {
    if (isLeaf)
    {
      if (list == null) return
      if (!envelope.intersects(this.envelope)) return

      list.each |f|
      {
        if (envelope == null || envelope.intersects(f.envelope))
        {
          filter(f)
        }
      }
    }
    else
    {
      subNode.each |sub|
      {
        sub.each(filter, envelope)
      }
    }
  }
}