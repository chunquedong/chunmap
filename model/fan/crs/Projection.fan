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
** Map projection
**
@Js
abstract const class Projection
{
  const Str name
  const SpatialRef? cs

  new make(Str name) { this.name = name }

  abstract |Point->Point| getTransform()

  abstract |Point->Point| getReverseTransform()
}