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
** Datum for coordinates
**
@Js
const class Datum
{
  const Str Name
  const Float x
  const Float y
  const Float r
  const Float c

  new make(|This| f) { f(this) }
}