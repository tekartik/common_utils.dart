// never fails
// [value] could be an int or a String

import 'package:tekartik_common_utils/num_utils.dart';

bool parseBool(dynamic value, [bool defaultBool]) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  } else if (value is String) {
    switch (value.toLowerCase()) {
      case "true":
        return true;
      case "false":
        return false;
    }
    num numValue = parseNum(value);
    if (numValue != null && numValue != 0) {
      return true;
    }
  }
  return defaultBool;
}
