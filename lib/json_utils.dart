import 'dart:convert';

//
// Safely parse a map
//
Map<String, dynamic> parseJsonObject(String text, [Map defaultMap = null]) {
  var map = parseJson(text);
  if (map is Map) {
    return map;
  }
  return defaultMap;
}

//
// Safely parse a list
//
List parseJsonList(String text, [List defaultList = null]) {
  var list = parseJson(text);
  if (list is List) {
    return list;
  }
  return defaultList;
}

//
// safely parse text
//
parseJson(String text) {
  if (text != null) {
    try {
      return JSON.decode(text);
    } catch (e) {}
  }
  return null;
}

//
// safely encode map, list, primitive or null
//
String encodeJson(var value) {
  if (value == null) {
    return null;
  }
  return JSON.encode(value);
}

//
// [collection] can be map a list
// if it is a string, it will try to parse it first
//
String jsonPretty(dynamic collection, [String defaultString]) {
  if (collection is String) {
    dynamic parsed = parseJson(collection);
    if (parsed != null) {
      collection = parsed;
    }
  }
  if (collection != null) {
    try {
      return const JsonEncoder.withIndent("  ").convert(collection);
    } catch (e) {}
  }
  return defaultString;
}
