//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2012-05-12  Jed Young  Creation
//

using vaseGraphics
using chunmapModel
using chunmapData
using chunmapUtil
using chunmapView
using slanRecord

**
** Edit the node of geometry
**
@Js
class EditTool : Tool
{
  SelectTool selectTool := RectSelectTool()
  Tool? editTool

  static const Int selectMode := 0
  static const Int editMode := 1
  Int state := selectMode

  new make()
  {
    selectTool.multiSelect = false
    selectTool.layerFilter = |Layer layer->Bool|
    {
      return (layer.isEditable && layer.isSelectable)
    }
    selectTool.onSelectChange = |Feature[] fs|
    {
      if (!fs.isEmpty)
      {
        Shape shape := fs.first
        editTool = makeToolForGeometry(shape, shape.geometry)
        if (editTool != null) state = editMode
      }
      else
      {
        state = selectMode
      }
    }

    sym := GeneralSym
    {
      pointSym = SimplePointSym { brush = Color.makeRgb(255, 0, 255); size = 20 }
      lineSym = SimpleLineSym { lineWidth = 5.0 }
      polygonSym = SimplePolygonSym { lineWidth = 5.0; fill = false }
    }
    selectTool.symbolizers = [sym, GeometryNodeSym {}]
  }

  private Tool? makeToolForGeometry(Shape shape, Geometry geometry)
  {
    if (geometry is GeoPoint)
    {
      return makeEditPointTool(shape)
    }
    else if (geometry is LineString)
    {
      return makeEditLineNodeTool(shape, geometry, false)
    }
    else if (geometry is Polygon)
    {
      return makeEditLineNodeTool(shape, (geometry as Polygon).shell, true)
    }
    else if (geometry is GeometryCollection)
    {
      GeometryCollection gs := (GeometryCollection)geometry
      for (i:=0; i<gs.size; ++i)
      {
        return makeToolForGeometry(shape, gs.get(0))
      }
    }
    return null
  }

  private Geometry makeGeometry(CoordSeqBuf coordSeqBuf, Geometry geometry, Bool isPolygon)
  {
    if (geometry is LineString)
    {
      return LineString(coordSeqBuf.toCoordSeq)
    }
    else if (geometry is Polygon)
    {
      coordSeqBuf.close
      Ring r := Ring(coordSeqBuf.toCoordSeq)
      return Polygon(r)
    }
    else if (geometry is MultiPolygon) {
      coordSeqBuf.close
      Ring r := Ring(coordSeqBuf.toCoordSeq)
      ngeo := geometry.clone
      (ngeo as MultiPolygon).geometrys[0] = Polygon(r)
      return ngeo
    }
    else if (geometry is GeometryCollection) {
      ngeo := geometry.clone
      if (isPolygon) {
        coordSeqBuf.close
        Ring r := Ring(coordSeqBuf.toCoordSeq)
        (ngeo as GeometryCollection).geometrys[0] = Polygon(r)
      }
      else {
        (ngeo as GeometryCollection).geometrys[0] = LineString(coordSeqBuf.toCoordSeq)
      }
      return ngeo
    }
    else
    {
      return LineString(coordSeqBuf.toCoordSeq)
    }
  }

  private Tool makeEditPointTool(Shape shape)
  {
    GeoPoint p := shape.geometry
    tool := EditPointTool()
    tool.map = map
    Int x := map.view.x2Screen(p.x).toInt
    Int y := map.view.y2Screen(p.y).toInt
    tool.x = x
    tool.y = y
    tool.shapeFeature = shape
    tool.onPointEdited = |Int x2, Int y2|
    {
      x3 := map.view.x2World(x2.toFloat)
      y3 := map.view.y2World(y2.toFloat)
      
      EditCommand cmd := EditCommand(map, selectTool.mainSelectedLayer, shape, GeoPoint(x3, y3))
      map.executeCommand(cmd)
      map.refresh
    }
    tool.onMissEdit = |->|
    {
      map.layers.selectedLayer = null
      state = selectMode
      map.refresh
    }
    return tool
  }

  private Tool makeEditLineNodeTool(Shape shape, LineString ls, Bool isPolygon)
  {
    EditLineNodeTool editTool := EditLineNodeTool()
    editTool.map = map
    editTool.curLine = ls
    editTool.shapeFeature = shape
    editTool.onNodeEdited = |CoordSeqBuf coordSeqBuf|
    {
      if (shape is ShapeFeature)
      {
        shapeFeature := shape as ShapeFeature
        geom := makeGeometry(coordSeqBuf, shapeFeature.geometry, isPolygon)
        if (geom is Polygon) {
            editTool.curLine = (geom as Polygon).shell
        }
        else if (geom is MultiPolygon) {
          editTool.curLine = ((geom as MultiPolygon).geometrys[0] as Polygon).shell
        }
        else if (geom is GeometryCollection) {
          g := (geom as GeometryCollection).geometrys[0]
          if (g is LineString)
            editTool.curLine =  g as LineString
          else if (g is Polygon)
            editTool.curLine =  (g as Polygon).shell
        }
        else {
            editTool.curLine = geom as LineString
        }
        EditCommand cmd := EditCommand(map, selectTool.mainSelectedLayer, shapeFeature, geom)
        map.executeCommand(cmd)
        map.refresh
      }
    }
    editTool.onMissEdit = |->|
    {
      map.layers.selectedLayer = null
      state = selectMode
      map.refresh
    }
    return editTool
  }

  override Void onAdd(MapCtrl context)
  {
    super.onAdd(context)
    selectTool.onAdd(context)
  }

  override Void onRemove()
  {
    map.layers.selectedLayer = null
    state = selectMode
    map.refresh
  }

  override Void actionEvent(CEvent e)
  {
    if (state == selectMode) selectTool.actionEvent(e)
    else if(state == editMode) editTool.actionEvent(e)
  }
}