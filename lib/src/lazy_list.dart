import 'dart:collection';

import 'package:meta/meta.dart';

/// Lazy list converter function.
typedef LazyListConverterFunction<S, T> = T Function(S item);

/// Lazy list. item are converted when requested.
///
/// The list is modifiable too.
class LazyList<S extends Object, T extends Object> extends ListBase<T> {
  /// The base model list.
  final List<S> _srcList;

  /// The converted list.
  late List<T?> _lazyList;

  /// Optional builder functions.
  final LazyListConverterFunction<S, T> converter;

  /// Constructor.
  LazyList({required List<S> srcList, required this.converter})
    : _srcList = srcList {
    _lazyList = List<T?>.filled(this._srcList.length, null, growable: true);
  }

  @override
  T operator [](int index) {
    return _lazyList[index] ??= converter(_srcList[index]);
  }

  @override
  void operator []=(int index, T value) {
    _lazyList[index] = value;
  }

  @override
  int get length => _lazyList.length;

  @override
  set length(int newLength) {
    _lazyList.length = newLength;
  }
}

/// Private extension on LazyList
@visibleForTesting
extension LazyListPrvExt<S extends Object, T extends Object> on LazyList<S, T> {
  /// The current lazy list.
  List<T?> get lazyList => _lazyList;
}
