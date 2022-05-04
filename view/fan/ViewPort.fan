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
** ViewPort manage the coordinate transform
**
@Js
class ViewPort
{
  private Float xBuffer
  private Float yBuffer

  private EnvelopeBuilder? bufferEnvelop

  Int height { private set } //screen Height
  Int width { private set } //screen Width

  |ViewPort|? onViewChanged

  new make(Int width, Int height, Float xBuffer, Float yBuffer)
  {
    this.xBuffer = xBuffer
    this.yBuffer = yBuffer

    this.height = height
    this.width = width
    &scale = 1f
    &viewEnvelop = EnvelopeBuilder(0f, 0f, width.toFloat, height.toFloat)
    setBufferEnvelope
    &center = viewEnvelop.center
  }

//////////////////////////////////////////////////////////////////////////
// setter
//////////////////////////////////////////////////////////////////////////

  Void resetSize(Int width, Int height, Float xBuffer, Float yBuffer)
  {
    this.xBuffer = xBuffer
    this.yBuffer = yBuffer
    this.height = height
    this.width = width
    resetEnvelope
  }

  private Void setBufferEnvelope()
  {
    &bufferEnvelop = viewEnvelop.clone
    &bufferEnvelop.buffer(this.dis2World(xBuffer), this.dis2World(yBuffer))
  }

  Envelope getBufferEnvelope()
  {
    bufferEnvelop.toEnvelope
  }

  Float scale
  {
    set { &scale = it; resetEnvelope }
  }

  private EnvelopeBuilder viewEnvelop
  {
    set
    {
      EnvelopeBuilder eb := it
      if (it.width == 0f || it.height == 0f)
      {
        //if user set point envelope to this
        eb = EnvelopeBuilder.makeRectangle(it)
        eb.buffer(0.1f, 0.1f)
      }
      &scale = calculateScale(eb)
      &center = it.center
      resetEnvelope
    }
  }

  Envelope envelope
  {
    get { viewEnvelop.toEnvelope }
    set { viewEnvelop = EnvelopeBuilder.makeRectangle(it) }
  }

  Point center
  {
    set
    {
      dx := it.x - &center.x
      dy := it.y - &center.y

      &center = Coord(it.x, it.y)
      &viewEnvelop.move(dx, dy)
      &bufferEnvelop.move(dx, dy)

      onViewChanged?.call(this)
    }
  }

  **
  ** Reset the viewEnvelope and bufferEnvelope by the center and scale value
  **
  private Void resetEnvelope()
  {
    x := center.x
    y := center.y
    dx := (width / scale) / 2f
    dy := (height / scale) / 2f

    &viewEnvelop = EnvelopeBuilder(x - dx, y - dy, x + dx, y + dy)
    setBufferEnvelope

    onViewChanged?.call(this)
  }

  private Float calculateScale(Rectangle envelop)
  {
    expectedEnvelopHeight := envelop.maxY - envelop.minY
    expectedEnvelopWidth := envelop.maxX - envelop.minX
    s1 := height / expectedEnvelopHeight
    s2 := width / expectedEnvelopWidth

    return s1.min(s2)
  }

//////////////////////////////////////////////////////////////////////////
// util
//////////////////////////////////////////////////////////////////////////

  Void zoom(Float s, Float x, Float y)
  {
    //world
    dx0 := x - this.center.x
    dy0 := y - this.center.y

    //view
    dx := dx0 * this.scale
    dy := dy0 * this.scale

    this.center = Coord(x, y)
    this.scale *= s

    //world
    xx := dx / this.scale
    yy := dy / this.scale

    this.center = Coord(x - xx, y - yy)

    //echo(this)
  }

  override Str toStr() {
    return "scale:$scale, bufferEnvelop:$bufferEnvelop, center:$center, width:$width, height:$height"
  }

//////////////////////////////////////////////////////////////////////////
// coordinateTransform
//////////////////////////////////////////////////////////////////////////

  **
  ** transform x coordinate from world to screen
  **
  Float x2Screen(Float x)
  {
    Float newX
    newX = x - viewEnvelop.minX
    newX = newX * scale
    return newX
  }

  **
  ** transform y coordinate from world to screen
  **
  Float y2Screen(Float y)
  {
    Float newY
    newY = viewEnvelop.maxY - y
    newY = newY * scale
    return newY
  }

  **
  ** transform point from world to screen
  **
  |Point->Point| world2Screen := |Point p->Point|
  {
    x := x2Screen(p.x)
    y := y2Screen(p.y)
    return Coord(x, y)
  }

  **
  ** transform x coordinate from screen to world
  **
  Float x2World(Float x)
  {
    Float newX
    newX = x / scale
    newX = newX + viewEnvelop.minX

    return newX
  }

  **
  ** transform y coordinate from screen to world
  **
  Float y2World(Float y)
  {
    Float newY
    newY = y / scale
    newY = viewEnvelop.maxY - newY

    return newY
  }

  **
  ** transform point from screen to world
  **
  |Point->Point| screen2World := |Point p->Point|
  {
    x := x2World(p.x)
    y := y2World(p.y)
    return Coord(x, y)
  }

  **
  ** transform distance from world to screen
  **
  Float dis2Screen(Float d) { d * scale }

  **
  ** transform distance from screen to world
  **
  Float dis2World(Float d) { d / scale }

}