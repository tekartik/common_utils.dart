///
/// return the defaultValue if value is null
///
T nonNull<T>(T? value, T defaultValue) {
  return value ?? defaultValue;
}
