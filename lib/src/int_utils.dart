// never fails
// [value] could be an int or a String
import 'package:tekartik_common_utils/string_utils.dart';

int? parseInt(dynamic value, [int? defaultInt]) {
  if (value is int) {
    return value;
  } else if (value is String) {
    var intValue = int.tryParse(value);
    if (intValue != null) {
      return intValue;
    }
  }
  return defaultInt;
}

/// Find starting integer in string
int? stringParseStartingInt(String value) {
  var end = -1;
  for (var i = 0; i < value.codeUnits.length; i++) {
    if (isDigit(value, i)) {
      end++;
    } else {
      break;
    }
  }
  if (end >= 0) {
    return int.parse(value.substring(0, end + 1));
  }
}

/// Find ending integer in a string
int? stringParseEndingInt(String value) {
  var end = value.codeUnits.length;
  var start = end;
  for (var i = start - 1; i >= 0; i--) {
    if (isDigit(value, i)) {
      start--;
    } else {
      break;
    }
  }
  if (start < end) {
    return int.parse(value.substring(start, end));
  }
}
