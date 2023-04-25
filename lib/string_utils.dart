import 'dart:math';

import 'value_utils.dart' as value_utils;

export 'bool_utils.dart' show parseBool;
export 'int_utils.dart' show parseInt;

/// True if null or empty
bool stringIsEmpty(String? text) {
  return ((text == null) || text.isEmpty);
}

/// True if not null nor empty.
bool stringIsNotEmpty(String? text) {
  return text?.isNotEmpty == true;
}

int _stringSafeStartOrEnd(String? text, int index) {
  if (index < 0) {
    return 0;
  } else if (index > text!.length) {
    return text.length;
  }
  return index;
}

/// Returns a sub string starting at start with a len max.
///
/// null only if text is null.
String? stringSubString(String? text, int start, [int? end]) {
  if (stringIsEmpty(text)) {
    return text;
  }
  start = _stringSafeStartOrEnd(text, start);
  if (end != null) {
    end = max(_stringSafeStartOrEnd(text, end), start);
  }
  return text!.substring(start, end);
}

/// Truncate at max element.
String? stringTruncate(String? text, int len) => stringSubString(text, 0, len);

/// Returns an empty string in the worst case
String stringNonNull(String? value, [String? defaultValue = '']) =>
    value_utils.nonNull(value, defaultValue ?? '');

String? stringNonEmpty(String? value, [String? defaultValue]) =>
    stringIsEmpty(value) ? defaultValue : value;

/// First
String stringPrefilled(String text, int len, String char) {
  var length = text.length;
  final out = StringBuffer();
  while (length < len) {
    out.write(char);
    length += char.length;
  }
  out.write(text);
  return out.toString();
}

/// True if the char at index is a digit
/// To deprecate
bool isDigit(String s, [int idx = 0]) => stringIsDigit(s, idx);

bool stringIsDigit(String s, [int idx = 0]) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

/// Common string extension
extension TekartikCommonStringExtension on String {
  /// Never returns an empty string.
  String? nonEmpty([String? defaultValue]) =>
      stringNonEmpty(this, defaultValue);

  /// Remove extra blank space.
  String? trimmedNonEmpty([String? defaultValue]) =>
      trim().nonEmpty(defaultValue);

  bool isDigit() => stringIsDigit(this);
}
