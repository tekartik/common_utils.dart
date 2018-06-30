import 'dart:convert';

//
// Safely parse a map
//
Map<String, dynamic> parseJsonObject(String text,
    [Map<String, dynamic> defaultMap = null]) {
  var map = parseJson(text);
  if (map is Map) {
    return map?.cast<String, dynamic>();
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
      return json.decode(text);
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
  return json.encode(value);
}

//
// [data] can be map a list
// if it is a string, it will try to parse it first
//
String jsonPretty(dynamic data, [String defaultString]) {
  if (data is String) {
    dynamic parsed = parseJson(data);
    if (parsed != null) {
      data = parsed;
    }
  }
  if (data != null) {
    try {
      return const JsonEncoder.withIndent("  ").convert(data);
    } catch (e) {}
  }
  return defaultString;
}
