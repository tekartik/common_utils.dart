import 'package:tekartik_common_utils/string_utils.dart';

/// never fails.
///
/// [value] could be an int or a String
int parseInt(dynamic value,
    [

    /// To deprecated
    int deprecatedDefaultInt]) {
  if (value is int) {
    return value;
  } else if (value is String) {
    var intValue = int.tryParse(value);
    if (intValue != null) {
      return intValue;
    }
  }
  return deprecatedDefaultInt;
}

/// Parse the starting digits.
///
/// '300abc' => 300
/// 'abc300' => null
/// Never fails
///
int /*?*/ parseStartInt(dynamic /*?*/ value) {
  var intValue = parseInt(value);
  if (intValue == null) {
    var intSb = StringBuffer();
    var text = value?.toString() ?? '';
    for (var i = 0; i < text.length; i++) {
      if (isDigit(text, i)) {
        intSb.write(text[i]);
      } else {
        break;
      }
    }
    if (intSb.isNotEmpty) {
      intValue = int.parse(intSb.toString());
    }
  }
  return intValue;
}

/// Parse the first digits.
///
/// '300abc' => 300
/// 'abc300' => 300
/// Never fails
///
int /*?*/ parseFirstInt(dynamic /*?*/ value) {
  var intValue = parseInt(value);
  if (intValue == null) {
    var intSb = StringBuffer();
    var text = value?.toString() ?? '';
    for (var i = 0; i < text.length; i++) {
      if (isDigit(text, i)) {
        intSb.write(text[i]);
      } else {
        if (intSb.isNotEmpty) {
          break;
        }
      }
    }
    if (intSb.isNotEmpty) {
      intValue = int.parse(intSb.toString());
    }
  }
  return intValue;
}
