// never fails
// [value] could be an int or a String
int parseInt(dynamic value, [int defaultInt]) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.parse(value, onError: (_) => defaultInt);
  }
  return defaultInt;
}