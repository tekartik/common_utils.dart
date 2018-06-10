import 'value_utils.dart' as value_utils;
export 'bool_utils.dart' show parseBool;
export 'int_utils.dart' show parseInt;

@Deprecated("User stringIsEmpty")
bool isEmpty(String text) => stringIsEmpty(text);

bool stringIsEmpty(String text) {
  return ((text == null) || (text.length == 0));
}

// Use default Value if null (default empty string)
// might be deprecated for stringNonNull to avoid conflict
@Deprecated("User stringNonNull")
String nonNull(String value, [String defaultValue = '']) =>
    stringNonNull(value, defaultValue);

String stringNonNull(String value, [String defaultValue = '']) =>
    value_utils.nonNull(value, defaultValue);

// User defaul Value if empty (default null)
// might be deprecated for stringNonNull to avoid conflict
@Deprecated("User stringNonEmpty")
String nonEmpty(String value, [String defaultValue = null]) =>
    stringNonEmpty(value, defaultValue);

String stringNonEmpty(String value, [String defaultValue = null]) =>
    stringIsEmpty(value) ? defaultValue : value;

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
