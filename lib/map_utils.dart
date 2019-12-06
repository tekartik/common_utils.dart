library tekartik_utils.map_utils;

import 'list_utils.dart';

/// content from mapSrc is merge into mapDst overriding it if needed
/// @returns mapDst
Map mergeMap(Map mapDst, Map mapSrc) {
  if (mapSrc != null) {
    mapSrc.forEach((var key, var value) {
      mapDst[key] = value;
    });
  }
  return mapDst;
}

Map<K, V> cloneMap<K, V>(Map<K, V> original) {
  final map = <K, V>{};
  original.forEach((key, value) {
    dynamic cloneValue;
    if (value is Map) {
      cloneValue = cloneMap(value);
    } else if (value is List) {
      cloneValue = cloneList(value);
    } else {
      cloneValue = value;
    }
    map[key] = cloneValue as V;
  });
  return map;
}

/// Get a map Value, create if needed.
///
/// if the map value is null and createIfNull is specified, the object is
/// created and inserted in the map.
V mapValue<K, V>(Map<K, V> map, K key, {V Function() createIfNull}) {
  if (map == null) {
    return null;
  }
  var value = map[key];
  if (value == null && createIfNull != null) {
    value = createIfNull();
    map[key] = value;
  }
  return value;
}

String mapStringValue(Map map, String key, [String defaultValue]) {
  if (map != null) {
    var value = map[key]?.toString();
    if (value != null) {
      return value;
    }
  }
  return defaultValue;
}

int mapIntValue(Map map, String key, [int defaultValue]) {
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

/// Safe way to get a map, never fails
Map<K, V> asMap<K, V>(dynamic value) {
  if (value is Map<K, V>) {
    return value;
  }
  if (value is Map) {
    try {
      return value.cast<K, V>();
    } catch (_) {}
  }
  return null;
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

T mapValueFromParts<T>(Map map, Iterable<String> parts) =>
    getPartsMapValue(map, parts);

T getPartsMapValue<T>(Map map, Iterable<String> parts) {
  dynamic value = map;
  for (var part in parts) {
    if (value is Map) {
      value = value[part];
    } else {
      return null;
    }
  }
  return value as T;
}

void setPartsMapValue<T>(Map map, List<String> parts, value) {
  for (var i = 0; i < parts.length - 1; i++) {
    var part = parts[i];
    dynamic sub = map[part];
    if (!(sub is Map)) {
      sub = <String, dynamic>{};
      map[part] = sub;
    }
    map = sub as Map;
  }
  map[parts.last] = value;
}

T mapValueFromPath<T>(Map map, String path) {
  return mapValueFromParts(map, path.split('/'));
}
