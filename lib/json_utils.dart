import 'dart:convert';

//
// Safely parse a map
//
Map<String, Object?>? parseJsonObject(String? text,
    [Map<String, Object?>? defaultMap]) {
  var map = parseJson(text);
  if (map is Map) {
    return map.cast<String, Object?>();
  }
  return defaultMap;
}

//
// Safely parse a list
//
List? parseJsonList(String? text, [List? defaultList]) {
  var list = parseJson(text);
  if (list is List) {
    return list;
  }
  return defaultList;
}

//
// safely parse text
//
Object? parseJson(String? text) {
  if (text != null) {
    try {
      return json.decode(text);
    } catch (_) {}
  }
  return null;
}

//
// safely encode map, list, primitive or null
//
String? encodeJson(Object? value) {
  if (value == null) {
    return null;
  }
  return json.encode(value);
}

//
// [data] can be map a list
// if it is a string, it will try to parse it first
//
String? jsonPretty(Object? data, [String? defaultString]) {
  if (data is String) {
    var parsed = parseJson(data);
    if (parsed != null) {
      data = parsed;
    }
  }
  if (data != null) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {}
  }
  return defaultString;
}
