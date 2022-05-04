//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-05-14  Jed Young  Creation
//

internal class LineAlgorithmTest : Test
{
   Void testHasIntersection()
   {
      g := WktReader("LINESTRING(92.28571428571429 100.21428571428572,93.71428571428571 100.21428571428572,93.71428571428571 101.64285714285715,92.28571428571429 101.64285714285715,92.28571428571429 100.21428571428572)").read
      g2 := WktReader("LINESTRING(0.0 100.0,100.0 101.0)").read
      LineString ls := g
      LineString ls2 := g2
      verify(LineAlgorithm.intersects(ls.points, ls2.points))
   }
}