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

/// Common list list extension.
extension TekartikCommonListListExtension<T> on List<List<T>> {
  /// [[1], [2, 3]].flatten() => [1, 2, 3]
  List<T> flatten() => listFlatten<T>(this);
}

/// Common list or null extension.
extension TekartikCommonListOrNullExtension<T> on List<T>? {
  /// If empty return null
  List<T> nonNull() => this ?? <T>[];
}

/// Common iterable extension.
extension TekartikCommonIterableExtension<T> on Iterable<T> {
  /// Get first where or null
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

/// Common iterable extension
extension TekartikCommonIterableIterableExtension<T> on Iterable<Iterable<T>> {
  /// [[1], [2, 3]].flatten() => [1, 2, 3]
  List<T> flatten() => listFlatten<T>(this);
}

/// Find the list of chunk sizes to split a list of a given length
List<int> listLengthChunkSizes(int length, int chunkMaxSize) {
  var fullChunkCount = length ~/ chunkMaxSize;
  var list = List.filled(fullChunkCount, chunkMaxSize, growable: true);
  var remaining = length - fullChunkCount * chunkMaxSize;
  if (remaining > 0) {
    list.add(remaining);
  }
  return list;
}
