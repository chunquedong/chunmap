//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-04-30  Jed Young  Creation
//

internal class EnvelopeTest : Test
{
  Void testGetCenter()
  {
    Envelope envelop := Envelope(10f, 16f, 20f, 22f)
    Point p := envelop.center
    Point expected := Coord(15f, 19f)
    Bool b := p.equals(expected)
    verify(b)
  }

  Void testMergeEnvelop()
  {
    Envelope envelop1 := Envelope(10f, 16f, 20f, 22f)
    Envelope envelop2 := Envelope(7f, 18f, 17f, 25f)
    // Envelop expected:=new Envelop(7f,20f,16f,25f)
    EnvelopeBuilder env := EnvelopeBuilder.makeNone
    env.merge(envelop1)
    env.merge(envelop2)
    envelop := env.toEnvelope

    Bool b1 := (envelop.minX == 7f)
    Bool b2 := (envelop.maxX == 20f)
    Bool b3 := (envelop.minY == 16f)
    Bool b4 := (envelop.maxY == 25f)

    verify(b1 && b2 && b3 && b4)
  }

  Void testContain()
  {
    Envelope envelop1 := Envelope(10f, 16f, 20f, 22f)
    Point p := Coord(11f, 17f)

    Bool b1 := envelop1.containsPoint(p)
    verify(b1)
  }

  Void testContain2()
  {
    Envelope envelop1 := Envelope(10f, 16f, 10f, 16f)
    Point p := Coord(10f, 16f)

    Bool b1 := envelop1.containsPoint(p)
    verify(b1)
  }
/*TODO: GeoPoint is undefine
  Void testContain3()
  {
    Point p := Coord(10f, 16f)
    Envelope envelop1 := GeoPoint(p).envelope
    Bool b1 := envelop1.containsPoint(p)
    verify(b1)
  }
  */
}