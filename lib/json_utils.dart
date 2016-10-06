import 'dart:convert';

Map<String, dynamic> parseJsonObject(String text, [Map defaultMap = null]) {
  var map = _parse(text);
  if (map is Map) {
    return map;
  }
  return defaultMap;
}

List parseJsonList(String text, [List defaultList = null]) {
  var list = _parse(text);
  if (list is List) {
    return list;
  }
  return defaultList;
}

_parse(String text) {
  if (text != null) {
    try {
      return JSON.decode(text);
    } catch (e) {}
  }
  return null;
}
