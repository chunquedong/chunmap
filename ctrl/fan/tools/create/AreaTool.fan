//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-10-29  Jed Young  Creation
//

using vaseGraphics

using chunmapModel
using chunmapData

@Js
class AreaTool : LineTool
{
  protected override Void finished(CoordSeqBuf lse)
  {
    if (lse.size < 3) {
        return
    }
    
    lse.close
    Ring? ls
    try
      ls = Ring(lse.toCoordSeq)
    catch
      return
    geom := Polygon(ls)
    
    if (onCreateFinish != null)
    {
      onCreateFinish?.call(geom)
    }
    
    if (editLayer != null) {
        FeatureSet ds := editLayer.dataSource
        Feature f := ShapeFeature(ds.schema)
        {
          geometry = geom
        }
        cmd := CreateCommand(map, editLayer, f)
        map.executeCommand(cmd)
        map.refresh
    }
  }

  protected override PointArray toIntArray(Int x, Int y)
  {
    ps := PointArray((lse.size+2))
    n := lse.size
    i:=0
    for (; i<n; ++i)
    {
      p := lse.get(i)
      ps.setX(i, map.view.x2Screen(p.x).toInt)
      ps.setY(i, map.view.y2Screen(p.y).toInt)
    }
    k := n
    ps.setX(k, x)
    ps.setY(k, y)
    
    if (n > 0) {
        first := lse.first
        ps.setX(k+1, map.view.x2Screen(first.x).toInt)
        ps.setY(k+1, map.view.y2Screen(first.y).toInt)
    }
    else {
        ps.setX(k+1, x)
        ps.setY(k+1, y)
    }
    return ps
  }
}