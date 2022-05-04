//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-02  Jed Young  Creation
//

**
** Transform Chain
**
@Js
class TransformChain
{
  private |Point->Point|[] transforms := [,]

  **
  ** all a func to chain
  **
  This add(|Point->Point| trans) { transforms.add(trans); return this }

  **
  ** execute convert
  **
  Point convert(Point p)
  {
    transforms.each
    {
      p = it.call(p)
    }
    return p
  }

  |Point p->Point| trans(){ #convert.func.bind([this]) }
}