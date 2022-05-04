//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-10  Jed Young  Creation
//
using util

**
** Coordnate Array is a high performance implements
**
@Js
@Serializable { simple = true }
class CoordArray : CoordSeq
{
  //private Point[] points
  private FloatArray points
  override Int size() { points.size / 2 }

  new make(Point[] cs) : this.makeFixed(cs.size)
  {
    cs.each |np, i|
    {
      setCoord(i*2, np.x)
      setCoord(i*2+1, np.y)
    }
  }

  ** make from Point list
  new makeFixed(Int size)
  {
    points = FloatArray.makeF8(size*2)
  }

//////////////////////////////////////////////////////////////////////////
// access
//////////////////////////////////////////////////////////////////////////

  override Point get(Int i) { Coord(points.get(i*2), points.get(i*2+1)) }

  Void setCoord(Int i, Float val) { points.set(i, val) }

  override Point[] toList()
  {
    Point[] ps := [,]
    each
    {
      ps.add(it)
    }
    return ps
  }

  override Void each(|Point,Int|  act)
  {
    for (i:=0; i<size; i++)
    {
      act(get(i), i)
    }
  }

  override Point? find(|Point,Int->Bool| f)
  {
    for (i:=0; i<size; i++)
    {
      if(f(get(i), i)) return get(i)
    }
    return null
  }

  override CoordSeq map(|Point->Point| transf)
  {
    cs := CoordArray(size)

    each |p, i|
    {
      np := transf(p)
      cs.setCoord(i*2, np.x)
      cs.setCoord(i*2+1, np.y)
    }
    return cs
  }

//////////////////////////////////////////////////////////////////////////
// Obj
//////////////////////////////////////////////////////////////////////////

  override Str toStr() { "CoordinateArray" + toMyString }

  ** prepare for WKT
  override internal Str toMyString()
  {
    str := StrBuf()
    str.add("(")
    each |p|
    {
      str.add("$p.x $p.y,")
    }
    str.remove(-1)
    str.add(")")
    return str.toStr
  }

  override Int hash() { points.hash }
}