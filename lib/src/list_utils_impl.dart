import 'package:tekartik_common_utils/list_utils.dart';

/// Common list extension.
extension TekartikCommonListExtension<T> on List<T> {
  /// If empty return null
  List<T>? nonEmpty() => isNotEmpty ? this : null;

  /// Get element at index or null
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

/// Common list or null extension.
extension TekartikCommonListOrNullExtension<T> on List<T>? {
  /// If empty return null
  List<T> nonNull() => this ?? <T>[];
}

extension TekartikCommonIterableExtension<T> on Iterable<T> {}

/// Common iterable extension
extension TekartikCommonIterableIterableExtension<T> on Iterable<Iterable<T>> {
  /// [[1], [2, 3]].flatten() => [1, 2, 3]
  List<T> flatten() => listFlatten<T>(this);
}
