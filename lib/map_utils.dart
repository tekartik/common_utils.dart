library tekartik_utils.map_utils;

import 'list_utils.dart';

/**
 * content from mapSrc is merge into mapDst overriding it if needed
 * @returns mapDst
 */
Map mergeMap(Map mapDst, Map mapSrc) {
  if (mapSrc != null) {
    mapSrc.forEach((var key, var value) {
      mapDst[key] = value;
    });
  }
  return mapDst;
}

Map cloneMap(Map orignal) {
  Map map = new Map();
  orignal.forEach((key, value) {
    if (value is Map) {
      value = cloneMap(value);
    } else if (value is List) {
      value = cloneList(value);
    }
    map[key] = value;
  });
  return map;
}

String mapStringValue(Map map, String key, [String defaultValue = null]) {
  if (map != null) {
    String value = map[key];
    if (value != null) {
      return value.toString();
    }
  }
  return defaultValue;
}

int mapIntValue(Map map, String key, [int defaultValue = null]) {
  if (map != null) {
    var value = map[key];
    if (value != null) {
      if (value is String) {
        return int.parse(value);
      } else if (value is int) {
        return value;
      }
    }
  }
  return defaultValue;
}

//bool mapBoolValue(Map map, String key, [bool defaultValue = false]) {
//  if (map != null) {
//    var value = map[key];
//    if (value != null) {
//      if (value is String) {
//        return bool.parse(value);
//      } else if (value is int) {
//        return value;
//      }
//    }
//  }
//  return defaultValue;
//}

void dumpMap(Map map) {
  map.forEach((key, value) {
    print('$key = $value');
  });
}

dynamic mapValueFromPath(Map map, String path) {
  List<String> parts = path.split('/');
  dynamic value = map;
  for (String part in parts) {
    if (value is Map) {
      value = value[part];
    } else {
      return null;
    }
  }
  return value;
}
