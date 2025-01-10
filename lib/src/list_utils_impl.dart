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

/// Compares two lists for element-by-element equality.
///
/// Returns true if the lists are both null, or if they are both non-null, have
/// the same length, and contain the same members in the same order. Returns
/// false otherwise.
///
/// If the elements are maps, lists, sets, or other collections/composite
/// objects, then the contents of those elements are not compared element by
/// element unless their equality operators ([Object.==]) do so. For checking
/// deep equality, consider using the [DeepCollectionEquality] class.
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}
