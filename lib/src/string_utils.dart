import 'package:tekartik_common_utils/string_utils.dart';

bool stringIsDigit(String s, [int index = 0]) =>
    (s.codeUnitAt(index) ^ 0x30) <= 9;

/// True if null or empty
bool stringIsEmpty(String? text) {
  return ((text == null) || text.isEmpty);
}

String? stringNonEmpty(String? value, [String? defaultValue]) =>
    stringIsEmpty(value) ? defaultValue : value;

/// Common string extension
extension TekartikCommonStringExtension on String {
  /// Never returns an empty string.
  String? nonEmpty([String? defaultValue]) =>
      stringNonEmpty(this, defaultValue);

  /// Remove extra blank space.
  String? trimmedNonEmpty([String? defaultValue]) =>
      trim().nonEmpty(defaultValue);

  bool isDigit([int idx = 0]) => stringIsDigit(this);

  int parseInt({int? radix}) => int.parse(this, radix: radix);
  int? tryParseInt({int? radix}) => int.tryParse(this, radix: radix);
  int? getLastInt() {
    var index = getLastIntIndex();
    if (index != null) {
      return trimRight().substring(index).parseInt();
    }
    return null;
  }

  /// Truncate at max element.
  String truncate(int len) => stringTruncate(this, len)!;
}

extension TekartikCommonStringPrvExtension on String {
  // null if none found
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
