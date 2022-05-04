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
** Event
**
@Js
class CEvent
{
  Bool consumed := false

  Int? x
  Int? y
  Int? delta
  Int? button
  Int? count
  Int? keyChar
  Int? size

  EventType? type
  Int id
  Obj? rawEvent

  new make(Int id)
  {
    this.id = id
    switch(id)
    {
    case mouseDown:
    case keyDown:
      type = EventType.press
    case mouseUp:
    case keyUp:
      type = EventType.release
    case mouseMove:
      type = EventType.move
    default:
      type = EventType.other
    }
  }

  const static Int mouseDown := 0
  const static Int mouseUp := 1
  const static Int mouseMove := 2
  const static Int mouseWheel := 3
  const static Int mouseEnter := 4
  const static Int mouseExit := 5
  const static Int mouseHover := 6
  const static Int keyDown := 7
  const static Int keyUp := 8
  const static Int touchEvent := 9
}

**
** Event Type
**
@Js
enum class EventType
{
  press,
  release,
  move,
  other
}