// To change this License template, choose Tools / Templates
// and edit Licenses / FanDefaultLicense.txt
//
// History:
//   2022年5月2日 yangjiandong Creation
//

using chunmapView
using chunmapModel
using chunmapData

@Js
class EditCommand : CCommand
{
  private ShapeFeature feature
  private Geometry oldGeometry
  private Geometry geometry
  private MapCtrl map

  new make(MapCtrl map, VectorLayer layer, ShapeFeature feature, Geometry geometry)
  {
    this.map = map
    this.feature = feature
    this.oldGeometry = feature.geometry
    this.geometry = geometry
    (layer.dataSource as FeatureList).dirty = true
  }

  override Void execute()
  {
    feature.geometry = geometry
  }

  override Void undo()
  {
    feature.geometry = oldGeometry
  }

}


@Js
class CreateCommand : CCommand
{
  private VectorLayer layer
  private ShapeFeature feature
  private MapCtrl map

  new make(MapCtrl map, VectorLayer layer, ShapeFeature feature)
  {
    this.feature = feature
    this.map = map
    this.layer = layer
    (layer.dataSource as FeatureList).dirty = true
  }

  override Void execute()
  {
    FeatureSet ds := layer.dataSource
    ds.add(feature)
  }

  override Void undo()
  {
    FeatureSet ds := layer.dataSource
    ds.remove(feature)
  }

}