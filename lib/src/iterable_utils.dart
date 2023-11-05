/// True if null or empty
bool stringIsEmpty(String? text) {
  return ((text == null) || text.isEmpty);
}

String? stringNonEmpty(String? value, [String? defaultValue]) =>
    stringIsEmpty(value) ? defaultValue : value;

/// Iterable helper
extension TekartikIterableExt<T> on Iterable<T> {
  T? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
