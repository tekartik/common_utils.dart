/// Map utils
extension TekartikStringObjectMapExtension<T> on Map<String, T> {
  /// Sort a map by key
  Map<String, T> keySortedMap() {
    var keys = this.keys.toList()..sort();
    var map = <String, T>{};
    for (var key in keys) {
      map[key] = this[key] as T;
    }
    return map;
  }
}
