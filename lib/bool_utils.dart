// never fails
// [value] could be an int or a String

import 'package:tekartik_common_utils/num_utils.dart';

/// Parses a boolean from [value].
///
/// Handles `bool`, `num` (where non-zero is `true`), and strings like `'true'`, `'false'`,
/// or numeric strings. If [value] cannot be parsed, returns [defaultBool].
bool? parseBool(Object? value, [bool? defaultBool]) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  } else if (value is String) {
    switch (value.toLowerCase()) {
      case 'true':
        return true;
      case 'false':
        return false;
    }
    final numValue = parseNum(value);
    if (numValue != null) {
      return numValue != 0;
    }
  }
  return defaultBool;
}
