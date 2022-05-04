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
** GeoDataAdapter
**
class GeoDataAdapter
{
  |Envelope->Bool|? geometryFilter
  Bool ignoreErr := false

  private FeatureDataReader dataResources

  new make(FeatureDataReader dataResources)
  {
    this.dataResources = dataResources
  }

  **
  ** Create a FeatureSet frome Uri
  **
  static FeatureSet buildFeatureSet(Uri uri, [Str:Str]? options := null)
  {
    FeatureDataReader? dataSource
    if (uri.ext.lower == "shp")
    {
      if (options != null && options["charset"] != null)
        dataSource = ShpDataReader(uri, Charset(options["charset"]))
      else
        dataSource = ShpDataReader(uri)
    }
    else
    {
      throw UnsupportedErr("unsupported data type $uri")
    }

    dataAdapter := GeoDataAdapter(dataSource)
    fc := dataAdapter.createFeatureList
    dataSource.close
    fc.uri = uri
    fc.options = options
    return fc
  }

//////////////////////////////////////////////////////////////////////////
// Methods
//////////////////////////////////////////////////////////////////////////

  **
  ** Create FeatureSet from FeatureDataReader
  **
  FeatureSet createFeatureList()
  {
    featureClass := FeatureList(dataResources.envelope, dataResources.schema)
    featureClass.dataResources = this.dataResources
    featureClass.metadata = this.dataResources.metadata

    initFeatureCollection(featureClass)
    return featureClass
  }

  FeatureSet createQuartTree()
  {
    featureClass := QuartTree(dataResources.envelope, dataResources.schema)
    featureClass.dataResources = this.dataResources
    featureClass.metadata = this.dataResources.metadata

    initFeatureCollection(featureClass)
    return featureClass
  }

  private Void initFeatureCollection(FeatureSet featureClass)
  {
    i := 0
    while (dataResources.next)
    {
      try
      {
        envelop := dataResources.shapeEnvelope
        if (geometryFilter == null || geometryFilter(envelop))
        {
          shape := ShapeFeature(featureClass.schema)
          {
            values = dataResources.data
            geometry = dataResources.geometry
            id = i
          }
          featureClass.add(shape)
        }
      }
      catch(Err e)
      {
        if (!ignoreErr) throw e
        else e.trace
      }
      ++i
    }
  }
}