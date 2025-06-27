import 'dart:math';

import 'package:tekartik_common_utils/string_utils.dart';

/// True if the string is a digit
bool stringIsDigit(String s, [int index = 0]) {
  if (index >= s.length) {
    return false;
  }
  return (s.codeUnitAt(index) ^ 0x30) <= 9;
}

/// True if null or empty
bool stringIsEmpty(String? text) {
  return ((text == null) || text.isEmpty);
}

///
String? stringNonEmpty(String? value, [String? defaultValue]) =>
    stringIsEmpty(value) ? defaultValue : value;

/// Common string extension
extension TekartikCommonStringListExtension on List<String> {
  /// Compare two lists of strings
  bool matchesStringList(List<String> other) {
    if (other.length != length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}

/// Common string extension
extension TekartikCommonStringExtension on String {
  /// Never returns an empty string.
  String? nonEmpty([String? defaultValue]) =>
      stringNonEmpty(this, defaultValue);

  /// Remove extra blank space.
  String? trimmedNonEmpty([String? defaultValue]) =>
      trim().nonEmpty(defaultValue);

  /// Parse an int or throw
  int parseInt({int? radix}) => int.parse(this, radix: radix);

  /// try parse an int
  int? tryParseInt({int? radix}) => int.tryParse(this, radix: radix);

  /// Get the last int of a string.
  int? getLastInt() {
    var index = getLastIntIndex();
    if (index != null) {
      return trimRight().substring(index).parseInt();
    }
    return null;
  }

  /// Split by first occurernce of a separator
  ///
  /// results has length 1 or 2
  List<String> splitFirst(String separator) {
    var index = indexOf(separator);
    if (index >= 0) {
      return [substring(0, index), substring(index + separator.length)];
    }
    return [this];
  }

  /// Truncate at max element.
  String truncate(int len, {bool? ellipsis}) =>
      stringTruncate(this, len, ellipsis: ellipsis)!;

  /// Obfuscate a string by replacing all but the first and last 4 characters with '*'.
  /// at least half of the characters are obfuscated.
  String obfuscate({int lastAndFirstKeepCountMax = 4}) {
    var keepCount = min(lastAndFirstKeepCountMax, length ~/ 4);
    return '${substring(0, keepCount)}'
        '${List<String>.generate(length - keepCount * 2, (_) => '*').join()}'
        '${substring(length - keepCount)}';
  }
}

/// Private extension
extension TekartikCommonStringPrvExtension on String {
  /// null if none found
  int? getLastIntIndex() {
    var endTrimmedIndex = trimRight().length - 1;
    var index = endTrimmedIndex;
    var foundOne = false;

    int? intOrNull() {
      if (foundOne) {
        return index + 1;
      } else {
        return null;
      }
    }

    while (index >= 0) {
      var chr = substring(index, index + 1);
      if (!chr.isDigit()) {
        return intOrNull();
      }
      foundOne = true;
      index--;
    }
    return intOrNull();
  }
}

int _compareInt(int? value1, int? value2) {
  if (value1 == null) {
    if (value2 == null) {
      return 0;
    } else {
      return -1;
    }
  } else {
    if (value2 == null) {
      return 1;
    } else {
      return value1.compareTo(value2);
    }
  }
}

/// Compare two strings with the last int part
int stringsCompareWithLastInt(
  String? value1,
  String? value2, {
  bool? nullFirst = false,
}) {
  if (nullFirst ?? false) {
    return -stringsCompareWithLastInt(value1, value2);
  }
  if (value1 == null) {
    if (value2 == null) {
      return 0;
    } else {
      return -1;
    }
  } else {
    if (value2 == null) {
      return 1;
    }
  }
  var intIndex1 = value1.getLastIntIndex();
  var intIndex2 = value1.getLastIntIndex();
  if (intIndex1 != null && intIndex2 != null) {
    var textPart1 = value1.substring(0, intIndex1);
    var textPart2 = value2.substring(0, intIndex2);
    var cmp = textPart1.compareTo(textPart2);
    if (cmp != 0) {
      return cmp;
    }

    var intPart1 = value1.substring(intIndex1).parseInt();
    var intPart2 = value2.substring(intIndex2).parseInt();
    cmp = _compareInt(intPart1, intPart2);
    if (cmp != 0) {
      return cmp;
    }
  }
  return value1.compareTo(value2);
}

//
// utils
//

///
/// Returns `true` if [rune] represents a whitespace character.
///
/// The definition of whitespace matches that used in [String.trim] which is
/// based on Unicode 6.2. This maybe be a different set of characters than the
/// environment's [RegExp] definition for whitespace, which is given by the
/// ECMAScript standard: http://ecma-international.org/ecma-262/5.1/#sec-15.10
///
/// from quiver
///
bool runeIsWhitespace(int rune) =>
    ((rune >= 0x0009 && rune <= 0x000D) ||
    rune == 0x0020 ||
    rune == 0x0085 ||
    rune == 0x00A0 ||
    rune == 0x1680 ||
    rune == 0x180E ||
    (rune >= 0x2000 && rune <= 0x200A) ||
    rune == 0x2028 ||
    rune == 0x2029 ||
    rune == 0x202F ||
    rune == 0x205F ||
    rune == 0x3000 ||
    rune == 0xFEFF);

/// Returns `true` if [rune] represents a digit character.
bool runeIsDigit(int rune) => (rune >= 0x0030 && rune <= 0x0039);

/// Returns `true` if [rune] represents a letter character from a to z.
bool runeIsLowerAlpha(int rune) => (rune >= 0x0061 && rune <= 0x007A);

/// Returns `true` if [rune] represents a letter character from A to Z.
bool runeIsUpperAlpha(int rune) => (rune >= 0x0041 && rune <= 0x005A);

/// Returns `true` if [rune] represents a letter character from a to z or A to Z.
bool runeIsAlpha(int rune) => runeIsLowerAlpha(rune) || runeIsUpperAlpha(rune);

/// Returns `true` if [rune] represents a letter or digit character.
bool runeIsAlphaNumeric(int rune) => runeIsAlpha(rune) || runeIsDigit(rune);

/// Alphanumeric string extension
extension TekartikAlphaNumericStringExtension on String {
  /// Returns `true` if the string contains only letter or digit characters.
  bool isOnlyAlphaNumeric() {
    if (isEmpty) {
      return false;
    }
    for (var rune in runes) {
      if (!runeIsAlphaNumeric(rune)) {
        return false;
      }
    }
    return true;
  }

  /// True if a string is a digit (assuming single character)
  bool isDigit([int idx = 0]) => stringIsDigit(this, idx);

  /// Returns `true` if the string contains only digit characters (and at least one)
  bool isOnlyDigit() {
    if (isEmpty) {
      return false;
    }
    for (var rune in runes) {
      if (!runeIsDigit(rune)) {
        return false;
      }
    }
    return true;
  }
}

/// Whitespace string extension
extension TekartikWhitespaceStringExtension on String {
  /// Must contains at least 1 !
  bool isOnlyWhitespaces() {
    if (isEmpty) {
      return false;
    }
    for (var rune in runes) {
      if (!runeIsWhitespace(rune)) {
        return false;
      }
    }
    return true;
  }

  /// Returns `true` if the string begins with a whitespace character.
  bool beginsWithWhitespaces() {
    if (isEmpty) {
      return false;
    }
    return runeIsWhitespace(runes.first);
  }

  /// Return `true` if the string ends with a whitespace character.
  bool endsWithWhitespaces() {
    if (isEmpty) {
      return false;
    }
    return runeIsWhitespace(runes.last);
  }

  /// Returns `true` if the string begins or ends with a whitespace character.
  bool beginsOrEndsWithWhitespaces() {
    if (isEmpty) {
      return false;
    }
    var runes = this.runes;
    return runeIsWhitespace(runes.first) || runeIsWhitespace(runes.last);
  }
}
