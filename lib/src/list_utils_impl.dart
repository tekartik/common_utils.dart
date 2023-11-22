import 'package:tekartik_common_utils/list_utils.dart';

/// Common list extension.
extension TekartikCommonListExtension<T> on List<T> {
  /// If empty return null
  List<T>? nonEmpty() => isNotEmpty ? this : null;
}

extension TekartikCommonIterableExtension<T> on Iterable<T> {}

/// Common iterable extension
extension TekartikCommonIterableIterableExtension<T> on Iterable<Iterable<T>> {
  /// [[1], [2, 3]].flatten() => [1, 2, 3]
  List<T> flatten() => listFlatten<T>(this);
}
