using chunmapModel


@Js
const class Gcj02 : Projection
{
  static const SpatialRef gcj02 := SpatialRef { srid = 14326; name = "GCJ02"; projection = Gcj02() }
  static const SpatialRef gcj02Mercator := SpatialRef { srid = 13857; name = "GCJ02Mercator"; projection = Gcj02(true) }

  const Mercator? mercator

  new make(Bool useMercator = false) : super.make("GCJ02") {
    mercator = Mercator()
  }

  override |Point->Point| getReverseTransform()
  {
     |Point->Point|? mt;
     if (mercator != null) mt = mercator.getReverseTransform
     return |Point p->Point| {
        if (mt != null) {
            p = mt.call(p)
        }
        return GCJ02_WGS84.gcj02_To_Wgs84(p.y, p.x)
     }
  }

  override |Point->Point| getTransform()
  {
     |Point->Point|? mt;
     if (mercator != null) mt = mercator.getTransform
     return |Point p->Point| {
        p = GCJ02_WGS84.wgs84_To_Gcj02(p.y, p.x)
        if (mt != null) {
            p = mt.call(p)
        }
        return p
     }
  }
}

//https://www.jianshu.com/p/c943c5089e15
@Js
class GCJ02_WGS84 {

    const static Float pi = 3.1415926535897932384626;
    const static Float a = 6378245.0;
    const static Float ee = 0.00669342162296594323;

    public static Coord wgs84_To_Gcj02(Float lat, Float lon) {
        //Coord info = Coord(lon, lat);
        if (outOfChina(lat, lon)) {
            return Coord(lon, lat);
        }

        Float dLat = transformLat(lon - 105.0, lat - 35.0);
        Float dLon = transformLon(lon - 105.0, lat - 35.0);
        Float radLat = lat / 180.0 * pi;
        Float magic = Math.sin(radLat);
        magic = 1 - ee * magic * magic;
        Float sqrtMagic = Math.sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * pi);
        Float mgLat = lat + dLat;
        Float mgLon = lon + dLon;
        //info.y = mgLat
        //info.x = mgLon
        //return info;
        return Coord(mgLon, mgLat);
    }

    public static Coord gcj02_To_Wgs84(Float lat, Float lon) {
        //Coord info = Coord(lon, lat);
        Coord gps = transform(lat, lon);
        Float lontitude = lon * 2 - gps.x
        Float latitude = lat * 2 - gps.y
        //info.y = (latitude);
        //info.x = (lontitude);
        return Coord(lontitude, latitude);
    }

    private static Bool outOfChina(Float lat, Float lon) {
        if (lon < 72.004 || lon > 137.8347)
            return true;
        if (lat < 0.8293 || lat > 55.8271)
            return true;
        return false;
    }

    private static Float transformLat(Float x, Float y) {
        Float ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y
        + 0.2 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(y * pi) + 40.0 * Math.sin(y / 3.0 * pi)) * 2.0 / 3.0;
        ret += (160.0 * Math.sin(y / 12.0 * pi) + 320 * Math.sin(y * pi / 30.0)) * 2.0 / 3.0;
        return ret;
    }

    private static Float transformLon(Float x, Float y) {
        Float ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1
        * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * pi) + 20.0 * Math.sin(2.0 * x * pi)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(x * pi) + 40.0 * Math.sin(x / 3.0 * pi)) * 2.0 / 3.0;
        ret += (150.0 * Math.sin(x / 12.0 * pi) + 300.0 * Math.sin(x / 30.0 * pi)) * 2.0 / 3.0;
        return ret;
    }

    private static Coord transform(Float lat, Float lon) {
        //Coord info = Coord(lon, lat);
        if (outOfChina(lat, lon)) {
            return Coord(lon, lat);
        }
        Float dLat = transformLat(lon - 105.0, lat - 35.0);
        Float dLon = transformLon(lon - 105.0, lat - 35.0);
        Float radLat = lat / 180.0 * pi;
        Float magic = Math.sin(radLat);
        magic = 1 - ee * magic * magic;
        Float sqrtMagic = Math.sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * pi);
        Float mgLat = lat + dLat;
        Float mgLon = lon + dLon;

        //info.y = (mgLat);
        //info.x = (mgLon);
        //return info;
        return Coord(mgLon, mgLat);
    }
}