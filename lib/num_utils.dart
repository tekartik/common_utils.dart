// never fails
// [value] could be an int or a String
num parseNum(dynamic value, [num defaultValue]) {
  if (value is num) {
    return value;
  } else if (value is String) {
    num numValue = num.tryParse(value);
    if (numValue != null) {
      return numValue;
    }
  }
  return defaultValue;
}
