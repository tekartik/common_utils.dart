///
/// return the defaultValue if value is null
///
dynamic nonNull(dynamic value, dynamic defaultValue) {
  return value == null ? defaultValue : value;
}
