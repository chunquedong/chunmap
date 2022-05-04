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
** CommandStack
**
@Js
class CommandStack
{
  private CCommand[] undoStack := CCommand[,]
  private CCommand[] redoStack := CCommand[,]


  Void push(CCommand cmd)
  {
    undoStack.push(cmd)
    if (cmd is EditCommand || cmd is CreateCommand) {
        redoStack.clear
    }
  }

  Void undo()
  {
    cmd := undoStack.pop
    if (cmd == null) return
    if (cmd.undoable) cmd.undo
    redoStack.push(cmd)
  }

  Void redo()
  {
    cmd := redoStack.pop
    if (cmd == null) return
    if (cmd.undoable) cmd.redo
    undoStack.push(cmd)
  }
}

