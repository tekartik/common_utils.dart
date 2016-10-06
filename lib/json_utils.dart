import 'dart:convert';

Map parseJsonObject(String text, [Map defaultMap = null]) {
  try {
    var map = JSON.decode(text);
    if (!(map is Map)) {
      return defaultMap;
    }
    return map;
  } catch (e) {
    return defaultMap;
  }
}

List parseJsonList(String text, [List defaultList = null]) {
  try {
    var list = JSON.decode(text);
    if (!(list is List)) {
      return defaultList;
    }
    return list;
  } catch (e) {
    return defaultList;
  }
}
