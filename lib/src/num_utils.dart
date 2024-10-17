/// never fails
/// [value] could be a num or a String
num? parseNum(Object? value, [num? defaultValue]) {
  if (value is num) {
    return value;
  } else if (value is String) {
    var numValue = num.tryParse(value);
    if (numValue != null) {
      return numValue;
    }
  }
  return defaultValue;
}
