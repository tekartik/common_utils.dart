import 'value_utils.dart' as value_utils;
export 'bool_utils.dart' show parseBool;
export 'int_utils.dart' show parseInt;

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
