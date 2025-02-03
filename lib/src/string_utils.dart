import 'dart:math';

import 'package:tekartik_common_utils/string_utils.dart';

/// True if the string is a digit
bool stringIsDigit(String s, [int index = 0]) =>
    (s.codeUnitAt(index) ^ 0x30) <= 9;

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

  /// True if a string is a digit
  bool isDigit([int idx = 0]) => stringIsDigit(this);

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
      if (!chr.isDigit(index)) {
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
int stringsCompareWithLastInt(String? value1, String? value2,
    {bool? nullFirst = false}) {
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
