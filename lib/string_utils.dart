import 'value_utils.dart' as value_utils;
export 'bool_utils.dart' show parseBool;
export 'int_utils.dart' show parseInt;

//int parseInt(String text, [int defaultValue = 0]) {
//  try {
//    return int.parse(text);
//  } on FormatException catch (e) {
//    return defaultValue;
//  }
//}
/*

int parseInt(String value, [int defaultValue = null]) {
  if (value == null) {
    return defaultValue;
  }
  return int.parse(value, onError: (e) {
    return defaultValue;
  });
}

// handle false/true FALSE/TRUE, 0/1
bool parseBool(String value, [bool defaultValue = false]) {
  if (value != null) {
    switch (value) {
      case '0':
      case 'false':
        return false;
      case '1':
      case 'true':
        return true;
    }

    switch (value.toLowerCase()) {
      case 'false':
        return false;
      case 'true':
        return true;
    }
  }
  return defaultValue;
}
*/
bool isEmpty(String text) {
  return ((text == null) || (text.length == 0));
}

// Use default Value if null (default empty string)
String nonNull(String value, [String defaultValue = '']) =>
    value_utils.nonNull(value, defaultValue);

// User defaul Value if empty (default null)
String nonEmpty(String value, [String defaultValue = null]) =>
    isEmpty(value) ? defaultValue : value;

String prefilled(String text, int len, String char) {
  int length = text.length;
  StringBuffer out = new StringBuffer();
  while (length < len) {
    out.write(char);
    length += char.length;
  }
  out.write(text);
  return out.toString();
}

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
