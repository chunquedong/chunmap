//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-10  Jed Young  Creation
//

**
** Build the `Envelope`
**
@Js
class EnvelopeBuilder : Rectangle
{
    ** minimum X
  override Float minX { private set }

  ** maximum X
  override Float maxX { private set }

  ** minimum Y
  override Float minY { private set }

  ** maximum Y
  override Float maxY { private set }

  **
  ** Make from four coordinate value. x1,y1 is a point and x2,y2 is another point
  **
  new make(Float x1, Float y1, Float x2, Float y2)
  {
    if (x1 < x2)
    {
      minX = x1
      maxX = x2
    }
    else
    {
      minX = x2
      maxX = x1
    }
    if (y1 < y2)
    {
      minY = y1
      maxY = y2
    }
    else
    {
      minY = y2
      maxY = y1
    }
  }

  new makeRectangle(Rectangle envelop)
    : this.make(envelop.minX, envelop.minY, envelop.maxX, envelop.maxY) { }

  **
  ** Make an illegality Envelope.
  ** The min Point is  positive infinity and The max point is negative infinity.
  ** This is useful as start to calculate merge of envelopes.
  **
  new makeNone()
  {
    minX = Float.posInf
    minY = Float.posInf
    maxX = Float.negInf
    maxY = Float.negInf
  }

  ** Is illegality Envelope.
  Bool isNone() { minX > maxX }

//////////////////////////////////////////////////////////////////////////
// operate
//////////////////////////////////////////////////////////////////////////

  **
  ** extends this box for the point lay in the envelope
  **
  Void extends(Point point)
  {
    x := point.x
    y := point.y

    if (isNone)
    {
      minX = x
      maxX = x
      minY = y
      maxY = y
      return
    }

    if (x < minX)       minX = x
    else if (x > maxX)  maxX = x

    if (y < minY)       minY = y
    else if (y > maxY)  maxY = y

  }

  **
  ** merge two envelope to a big one
  **
  Void merge(Rectangle envelop)
  {
    if (envelop.minX < minX)
      minX = envelop.minX
    if (envelop.minY < minY)
      minY = envelop.minY

    if (envelop.maxX > maxX)
      maxX = envelop.maxX
    if (envelop.maxY > maxY)
      maxY = envelop.maxY
  }

  **
  ** buffer for some padding
  **
  Void buffer(Float x, Float y)
  {
    minX = minX - x
    minY = minY - y
    maxX = maxX + x
    maxY = maxY + y
  }

  **
  ** move some distance
  **
  Void move(Float x, Float y)
  {
    minX += x
    minY += y
    maxX += x
    maxY += y
  }

  Envelope toEnvelope()
  {
    return Envelope(minX, minY, maxX, maxY)
  }

  EnvelopeBuilder clone()
  {
    return EnvelopeBuilder(minX, minY, maxX, maxY)
  }
}