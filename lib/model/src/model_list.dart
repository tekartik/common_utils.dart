import 'dart:collection';
import 'dart:math';

import 'package:tekartik_common_utils/model/model.dart';

// last mixin wins
class ModelListImpl extends ModelListBase implements ModelList {
  ModelListImpl(Iterable<Object?>? iterable) : super(iterable);
}

abstract class ModelListBase
    with ListMixin<Model?>, ModelListBaseMixin
    implements ModelList {
  ModelListBase(Iterable<Object?>? iterable) {
    if (iterable != null) {
      if (iterable is List<Map?>) {
        __list = iterable;
      } else {
        __list = iterable.cast<Map<Object?, Object?>?>().toList();
      }
    }
  }
}

/// Only create the model if non null
ModelList? asModelList(Object? list) =>
    list is Iterable ? ModelList(list) : null;

mixin ModelListBaseMixin implements ModelList {
  List<Map<Object?, Object?>?>? __list;

  // Never null
  List<Map<Object?, Object?>?> get _list => __list ??= <Model?>[];

  @override
  Model? get first => asModel(_list.first);

  @override
  set first(Model? first) => _list.first = first;

  @override
  Model? get last => asModel(_list.last);

  @override
  set last(Model? last) => _list.last = last;

  @override
  int get length => _list.length;

  @override
  List<Model?> operator +(List<Model?> other) => asModelList(_list + other)!;

  @override
  Model? operator [](int index) => asModel(_list[index]);

  @override
  void operator []=(int index, Model? value) => _list[index] = value;

  @override
  void add(Model? value) => _list.add(value);

  @override
  void addAll(Iterable<Model?> iterable) => _list.addAll(iterable);

  @override
  bool any(bool Function(Model? element) test) =>
      _list.any((item) => test(asModel(item)));

  @override
  Map<int, Model?> asMap() =>
      _list.asMap().map((key, value) => MapEntry(key, asModel(value)));

  @override
  List<R> cast<R>() => _list.cast<R>();

  @override
  void clear() => _list.clear();

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  Model? elementAt(int index) => asModel(_list.elementAt(index));

  @override
  bool every(bool Function(Model? element) test) =>
      _list.every((item) => test(asModel(item)));

  @override
  Iterable<T> expand<T>(Iterable<T> Function(Model? element) f) =>
      _list.expand((item) => f(asModel(item)));

  @override
  void fillRange(int start, int end, [fillValue]) =>
      _list.fillRange(start, end);

  @override
  Model? firstWhere(bool Function(Model? element) test,
          {Model? Function()? orElse}) =>
      asModel(_list.firstWhere((item) => test(asModel(item)), orElse: orElse));

  @override
  T fold<T>(T initialValue,
          T Function(T previousValue, Model? element) combine) =>
      _list.fold<T>(initialValue,
          (previous, element) => combine(previous, asModel(element)));

  @override
  Iterable<Model?> followedBy(Iterable<Model?> other) =>
      asModelList(_list.followedBy(other))!;

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  void forEach(void Function(Model? element) f) =>
      // ignore: avoid_function_literals_in_foreach_calls
      _list.forEach((item) => f(asModel(item)));

  @override
  Iterable<Model?> getRange(int start, int end) =>
      asModelList(_list.getRange(start, end))!;

  @override
  int indexOf(Object? element, [int start = 0]) =>
      _list.indexOf(asModel(element), start);

  @override
  int indexWhere(bool Function(Model? element) test, [int start = 0]) =>
      _list.indexWhere((item) => test(asModel(item)), start);

  @override
  void insert(int index, Model? element) =>
      _list.insert(index, asModel(element));

  @override
  void insertAll(int index, Iterable<Model?> iterable) =>
      _list.insertAll(index, iterable);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<Model?> get iterator => ModelListIterator(_list.iterator);

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  int lastIndexOf(Object? element, [int? start]) =>
      _list.lastIndexOf(asModel(element), start);

  @override
  int lastIndexWhere(bool Function(Model? element) test, [int? start]) =>
      _list.lastIndexWhere((item) => test(asModel(item)), start);

  @override
  Model? lastWhere(bool Function(Model? element) test,
          {Model? Function()? orElse}) =>
      asModel(_list.lastWhere((item) => test(asModel(item)), orElse: orElse));

  @override
  Iterable<T> map<T>(T Function(Model? e) f) =>
      _list.map((item) => f(asModel(item)));

  @override
  Model? reduce(Model? Function(Model? value, Model? element) combine) =>
      asModel(_list.reduce(
          (value, element) => combine(asModel(value), asModel(element))));

  @override
  bool remove(Object? value) => _list.remove(value);

  @override
  Model? removeAt(int index) => asModel(_list.removeAt(index));

  @override
  Model? removeLast() => asModel(_list.removeLast());

  @override
  void removeRange(int start, int end) => _list.removeRange(start, end);

  @override
  void removeWhere(bool Function(Model? element) test) =>
      _list.removeWhere((item) => test(asModel(item)));

  @override
  void replaceRange(int start, int end, Iterable<Model?> replacement) =>
      _list.replaceRange(start, end, replacement);

  @override
  void retainWhere(bool Function(Model? element) test) =>
      _list.retainWhere((item) => test(asModel(item)));

  @override
  Iterable<Model?> get reversed => asModelList(_list.reversed)!;

  @override
  void setAll(int index, Iterable<Model?> iterable) =>
      _list.setAll(index, iterable);

  @override
  void setRange(int start, int end, Iterable<Model?> iterable,
          [int skipCount = 0]) =>
      _list.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random? random]) => _list.shuffle(random);

  @override
  Model? get single => asModel(_list.single);

  @override
  Model? singleWhere(bool Function(Model? element) test,
          {Model? Function()? orElse}) =>
      asModel(_list.singleWhere((item) => test(asModel(item)), orElse: orElse));

  @override
  Iterable<Model?> skip(int count) => asModelList(_list.skip(count))!;

  @override
  Iterable<Model?> skipWhile(bool Function(Model? value) test) =>
      asModelList(_list.skipWhile((item) => test(asModel(item))))!;

  @override
  void sort([int Function(Model? a, Model? b)? compare]) =>
      _list.sort((a, b) => compare!(asModel(a), asModel(b)));

  @override
  List<Model?> sublist(int start, [int? end]) =>
      asModelList(_list.sublist(start, end))!;

  @override
  Iterable<Model?> take(int count) => asModelList(_list.take(count))!;

  @override
  Iterable<Model?> takeWhile(bool Function(Model? value) test) =>
      asModelList(_list.takeWhile((item) => test(asModel(item))))!;

  @override
  List<Model?> toList({bool growable = true}) =>
      asModelList(_list.toList(growable: true))!;

  @override
  Set<Model> toSet() => Set.from(asModelList(_list.toSet())!);

  @override
  Iterable<Model?> where(bool Function(Model? element) test) =>
      asModelList(_list.where((item) => test(asModel(item))))!;

  @override
  Iterable<T> whereType<T>() => _list.whereType<T>();
}

class ModelListIterator implements Iterator<Model?> {
  final Iterator<Map<Object?, Object?>?> _iterator;

  ModelListIterator(this._iterator);

  @override
  Model? get current => asModel(_iterator.current);

  @override
  bool moveNext() => _iterator.moveNext();
}
