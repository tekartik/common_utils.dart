import 'package:tekartik_common_utils/common_utils_import.dart';

/// Lazy list that transform items on demand
class LazyReadOnlyList<S, T> extends ListBase<T> {
  late final List<S> _srcList;
  late final List<bool> _transformedList;
  late final List<T?> _dstList;
  late final T Function(S src) _transform;

  LazyReadOnlyList(Iterable<S> srcList, T Function(S src) transform) {
    _srcList =
        srcList is List ? srcList as List<S> : srcList.toList(growable: false);
    _transform = transform;
    _transformedList = List.generate(length, (index) => false);
    _dstList = List.generate(length, (index) => null);
  }

  @override
  int get length => _srcList.length;

  @override
  T operator [](int index) {
    if (_transformedList[index]) {
      return _dstList[index] as T;
    }
    // transform
    var dst = _transform(_srcList[index]);
    _transformedList[index] = true;
    _dstList[index] = dst;
    return dst;
  }

  @override
  void operator []=(int index, T value) {
    throw UnsupportedError('Readonly list');
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('Readonly list');
  }

  @visibleForTesting
  bool isTransformed(int index) {
    return _transformedList[index];
  }
}

/// Convenient lazy extension to transform list content
extension LazyReadOnlyListExt<S> on Iterable<S> {
  /// Creating a lazy read-only list where item are transformed when read.
  List<T> lazy<T>(T Function(S src) transform) =>
      LazyReadOnlyList<S, T>(this, transform);
}
