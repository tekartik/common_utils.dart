// never fails
// [value] could be an int or a String
int parseInt(dynamic value, [int defaultInt]) {
  if (value is int) {
    return value;
  } else if (value is String) {
    int intValue = int.tryParse(value);
    if (intValue != null) {
      return intValue;
    }
  }
  return defaultInt;
}
