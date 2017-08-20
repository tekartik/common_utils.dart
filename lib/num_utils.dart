// never fails
// [value] could be an int or a String
num parseNum(dynamic value, [num defaultValue]) {
  if (value is num) {
    return value;
  } else if (value is String) {
    return num.parse(value, (_) => defaultValue);
  }
  return defaultValue;
}
