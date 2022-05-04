//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-04  Jed Young  Creation
//

**
** Quart-Tree key encode
**
const class QuartTreeIndex
{
  const Envelope envelope
  const Int deep
  new make(Envelope env, Int deep) { envelope = env; this.deep = deep }

  **
  ** make a key for object envelope
  **
  Str key(Envelope env)
  {
    if (!envelope.intersects(env)) return ""

    curEnv := envelope
    key := StrBuf()

    for(i:=1; i < deep; ++i)
    {
      intersection := Int[,]
      quarters := curEnv.quarters
      quarters.each |sub, k|
      {
        if (sub.intersects(env))
        {
          intersection.add(k)
        }
      }

      if (intersection.size > 1)
      {
        return key.toStr
      }
      else
      {
        index := intersection[0]
        curEnv = quarters[index]
        key.add(index)
      }
    }
    return key.toStr
  }

  **
  ** find all keys that intersects env
  **
  Str[] findKeys(Envelope env)
  {
    keys := Str[,]
    key := ""
    findKeysInEnv(keys, envelope, env, key, deep)
    return keys
  }

  private Void findKeysInEnv(Str[] keys, Envelope curEnv, Envelope env, Str key, Int count)
  {
    if (count == 0) return
    if (!curEnv.intersects(env)) return

    keys.add(key)

    curEnv.quarters.each |sub, k|
    {
      findKeysInEnv(keys, sub, env, key + k.toStr, count-1)
    }
  }
}