library;

import 'list_utils.dart';
export 'src/map_utils.dart' show TekartikStringObjectMapExtension;

/// content from mapSrc is merge into mapDst overriding it if needed
/// @returns mapDst
Map mergeMap(Map mapDst, Map mapSrc) {
  mapSrc.forEach((var key, var value) {
    mapDst[key] = value;
  });

  return mapDst;
}

/// Clone a map
Map<K, V?> cloneMap<K extends Object?, V extends Object?>(Map<K, V> original) {
  final map = <K, V?>{};
  original.forEach((key, value) {
    Object? cloneValue;
    if (value is Map) {
      cloneValue = cloneMap(value);
    } else if (value is List) {
      cloneValue = cloneList(value);
    } else {
      cloneValue = value;
    }
    map[key] = cloneValue as V?;
  });
  return map;
}

/// Get a map Value, create if needed.
///
/// if the map value is null and createIfNull is specified, the object is
/// created and inserted in the map.
V? mapValue<K extends Object?, V extends Object?>(
  Map<K, V> map,
  K key, {
  V Function()? createIfNull,
}) {
  var value = map[key];
  if (value == null && createIfNull != null) {
    value = createIfNull()!;
    map[key] = value;
  }
  return value;
}

/// Get a map Value toString, default if not found or null.
String? mapStringValue(Map map, String key, [String? defaultValue]) {
  var value = map[key]?.toString();
  if (value != null) {
    return value;
  }
  return defaultValue;
}

/// Get a map int value (parse string if needed), default if not found or null.
int? mapIntValue(Map map, String key, [int? defaultValue]) {
  var value = map[key];
  if (value != null) {
    if (value is String) {
      return int.parse(value);
    } else if (value is int) {
      return value;
    }
  }

  return defaultValue;
}

/// Can fail
Map<K, V> anyAsMap<K extends Object?, V extends Object?>(Object value) =>
    anyAsMapOrNull(value)!;

/// Safe way to get a map, never fails
Map<K, V>? anyAsMapOrNull<K extends Object?, V extends Object?>(Object? value) {
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

/// Safe way to get a map, never fails
/// @Deprecated prefer anyAsMapOrNull or anyAsMap
Map<K, V>? asMap<K extends Object?, V extends Object?>(Object? value) =>
    anyAsMapOrNull(value);

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

/// Dump a map
@Deprecated('Dev only')
void dumpMap(Map map) {
  map.forEach((key, value) {
    // ignore: avoid_print
    print('$key = $value');
  });
}

/// Get a map value (to deprecate)
T? mapValueFromParts<T>(Map map, Iterable<String> parts) =>
    getPartsMapValue(map, parts);

/// Get a map value
T? getPartsMapValue<T>(Map map, Iterable<String> parts) {
  Object? value = map;
  for (var part in parts) {
    if (value is Map) {
      value = value[part];
    } else {
      return null;
    }
  }
  return value as T?;
}

/// Set a map value
void setPartsMapValue(Map map, List<String> parts, Object? value) {
  for (var i = 0; i < parts.length - 1; i++) {
    var part = parts[i];
    Object? sub = map[part];
    if (sub is! Map) {
      sub = <String, Object?>{};
      map[part] = sub;
    }
    map = sub;
  }
  map[parts.last] = value;
}

/// Get a map value at path separated by / (? why /)
T? mapValueFromPath<T>(Map map, String path) {
  return mapValueFromParts(map, path.split('/'));
}
