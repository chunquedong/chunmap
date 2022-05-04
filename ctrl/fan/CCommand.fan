//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-05  Jed Young  Creation
//


**
** CCommand
**
@Js
abstract class CCommand
{
  abstract Void execute()

  virtual Bool undoable() { return true }

  virtual Void undo() {}

  virtual Void redo() { execute }
}

