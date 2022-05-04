//
// Copyright (c) 2009-2022, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE version 3.0
//
// History:
//   2011-09-30  Jed Young  Creation
//

using vaseGraphics

using chunmapModel
using chunmapData
using chunmapRaster

**
** image draw point
**
@Js
class ImagePointSym : GeometrySym
{
  Uri? uri {
    set {
        &uri = it
        image = null
    }
  }
  
  @Transient private Image? image
  
  new make() {
    deCollection = false
  }
  
  private Image? getImage() {
    if (image == null && uri != null) {
        image = Image.fromUri(uri)
    }
    return image
  }

  override Void drawGeometry(Geometry geom, RenderEnv r)
  {
    image := getImage()
    if (image == null || !image.isReady) return
    
    Float cx
    Float cy
    if (geom is GeoPoint) {
        GeoPoint p = geom
        cx = p.x
        cy = p.y
    }
    else {
        p := geom.envelope.center
        cx = p.x
        cy = p.y
    }


    halfW := pixelSize / 2f
    halfH := pixelSize / 2f
    x := r.view.x2Screen(cx) - halfW
    y := r.view.y2Screen(cy) - halfH

    g := r.g
    
    src := Rect(0, 0, image.width, image.height)
    dst := Rect(x.toInt, y.toInt, pixelSize, pixelSize)
    
    g.copyImage(image, src, dst)
  }
}