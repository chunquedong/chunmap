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
using slanRecord

**
** FeatureList
**
@Js
class FeatureList : FeatureSet
{
  Feature[] features
  

  new make(Envelope env, TableDef schema, Feature[] features := [,]) : super(env, schema)
  {
    this.features = features
  }

  override This add(Feature f) { features.add(f); return this }
  override Feature? remove(Feature f) { features.remove(f) }

  override Void each(Condition condition, |Feature| filter)
  {
    features.each |f|
    {
      if (condition.envelope == null || condition.envelope.intersects(f.envelope))
      {
        filter(f)
      }
    }
  }

  override Feature? find(Condition condition, |Feature->Bool| filter)
  {
    features.find |Feature f->Bool|
    {
      if (condition.envelope == null || condition.envelope.intersects(f.envelope))
      {
        return filter(f)
      }
      return false
    }
  }

//////////////////////////////////////////////////////////////////////////
// Serialization
//////////////////////////////////////////////////////////////////////////

  override Str toStr()
  {
    str := (uri == null ? "" : uri.toStr)
    if (options == null) return str
    options.each |v,k|
    {
      str += ",$k:$v"
    }
    return str
  }

  static new fromStr(Str s)
  {
    t := s.split(',')
    [Str:Str]? options
    if (t.size > 1)
    {
      options = [Str:Str][:]
      for (i:=1; i< t.size; ++i)
      {
        p := t[i].split(':')
        if (p.size > 1)
          options[p[0]] = p[1]
      }
    }
    return fromUri(t[0].toUri, options)
  }

  static FeatureList fromUri(Uri uri, [Str:Str]? options = null) {
    if (uri.ext == "tsv") {
      return fromTsv(uri.toFile)
    }
    else {
      return GeoDataAdapter.buildFeatureSet(uri, options)
    }
  }

  Void saveAs(File file) {
    out := file.out
    
    this.schema.each |f| {
      out.print(f.name + "|" + f.type.qname + "\t")
    }
    out.printLine("geometry|WKT")

    features.each |ShapeFeature f|
    {
      f.values.each |s| {
        if (s != null) out.print(s)
        else out.print("")
        out.print("\t")
      }

      geom := f.geometry

      if (metadata.crs.projection != null) geom = f.geometry.transform(metadata.crs.projection.getReverseTransform)
      out.printLine(geom)
    }
    out.close
  }

  static FeatureList fromTsv(File file) {
    eb := EnvelopeBuilder.makeNone
    table := TableDefBuilder(file.basename, ShapeFeature#)
    
    //read header
    in := file.in
    Str? line = in.readLine
    if (line != null) {
      fs := line.split('\t')
      fs.each {
        if (it == "geometry|WKT") lret
        cs := it.split('|')
        if (cs.size == 2) {
          table.addColumn(cs.first, Type.find(cs.last))
        }
        else {
          table.addColumn(it, Str#)
        }
      }
    }
    schema := table.build

    Feature[] features := [,]
    i := 0
    Geometry? geometry
    line = in.readLine
    while (line != null) {
      fs := line.split('\t')
      geometry = Geometry.fromStr(fs.last)

      feature := ShapeFeature(schema)
      feature.geometry = geometry
      feature.id = i
      feature.values = fs[0..<-1]
      features.add(feature)

      eb.merge(geometry.envelope)

      line = in.readLine
      ++i
    }
    in.close

    fc := FeatureList(eb.toEnvelope, schema, features)
    fc.metadata = Metadata
    {
      it.name = "unknown"
      it.type = geometry.geometryType
      it.crs = SpatialRef.defVal
    }
    //echo(fc.envelope)
    //fc.recalcuEnvelope
    //echo(fc.envelope)
    return fc
  }
}