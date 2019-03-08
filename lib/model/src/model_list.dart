import 'dart:collection';
import 'dart:math';

import 'package:tekartik_common_utils/model/model.dart';

// last mixin wins
class ModelListImpl extends ModelListBase implements ModelList {
  ModelListImpl(Iterable<dynamic> iterable) : super(iterable);
}

abstract class ModelListBase
    with ListMixin<dynamic>, ModelListBaseMixin
    implements ModelList {
  ModelListBase(Iterable<dynamic> iterable) {
    __list = iterable?.cast<dynamic>()?.toList();
  }
}

mixin ModelListBaseMixin implements List<dynamic> {
  List<dynamic> __list;
  List<dynamic> get _list => __list ??= <dynamic>[];

  @override
  dynamic get first => _list.first;
  @override
  set first(dynamic first) => __list.first = first;

  @override
  dynamic get last => _list.last;
  @override
  set last(dynamic last) => __list.last = last;

  @override
  int get length => _list.length;

  @override
  List<dynamic> operator +(List<dynamic> other) => _list + other;

  @override
  dynamic operator [](int index) => _list[index];

  @override
  void operator []=(int index, value) => _list[index] = value;

  @override
  void add(value) => _list.add(value);

  @override
  void addAll(Iterable iterable) => _list.addAll(iterable);

  @override
  bool any(bool Function(dynamic element) test) => _list.any(test);

  @override
  Map<int, dynamic> asMap() => _list.asMap();

  @override
  List<R> cast<R>() => _list.cast<R>();

  @override
  void clear() => _list.clear();

  @override
  bool contains(Object element) => __list.contains(element);

  @override
  dynamic elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(dynamic element) test) => _list.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(dynamic element) f) =>
      _list.expand(f);

  @override
  void fillRange(int start, int end, [fillValue]) =>
      _list.fillRange(start, end);

  @override
  dynamic firstWhere(bool Function(dynamic element) test,
          {Function() orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue,
          T Function(T previousValue, dynamic element) combine) =>
      _list.fold<T>(initialValue, combine);

  @override
  Iterable followedBy(Iterable other) => _list.followedBy(other);

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  void forEach(void Function(dynamic element) f) => _list.forEach(f);

  @override
  Iterable getRange(int start, int end) => _list.getRange(start, end);

  @override
  int indexOf(dynamic element, [int start = 0]) =>
      _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(dynamic element) test, [int start = 0]) =>
      _list.indexWhere(test, start);

  @override
  void insert(int index, dynamic element) => _list.insert(index, element);

  @override
  void insertAll(int index, Iterable iterable) =>
      _list.insertAll(index, iterable);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator get iterator => _list.iterator;

  @override
  String join([String separator = ""]) => _list.join(separator);

  @override
  int lastIndexOf(dynamic element, [int start]) =>
      _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(dynamic element) test, [int start]) =>
      _list.lastIndexWhere(test, start);

  @override
  dynamic lastWhere(bool Function(dynamic element) test, {Function() orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(dynamic e) f) => _list.map(f);

  @override
  dynamic reduce(Function(dynamic value, dynamic element) combine) =>
      _list.reduce(combine);

  @override
  bool remove(Object value) => _list.remove(value);

  @override
  dynamic removeAt(int index) => _list.removeAt(index);

  @override
  dynamic removeLast() => _list.removeLast();

  @override
  void removeRange(int start, int end) => _list.removeRange(start, end);

  @override
  void removeWhere(bool Function(dynamic element) test) =>
      _list.removeWhere(test);
  @override
  void replaceRange(int start, int end, Iterable replacement) =>
      _list.replaceRange(start, end, replacement);

  @override
  void retainWhere(bool Function(dynamic element) test) =>
      _list.retainWhere(test);

  @override
  Iterable get reversed => _list.reversed;

  @override
  void setAll(int index, Iterable iterable) => _list.setAll(index, iterable);

  @override
  void setRange(int start, int end, Iterable iterable, [int skipCount = 0]) =>
      _list.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random random]) => _list.shuffle(random);

  @override
  dynamic get single => _list.single;

  @override
  dynamic singleWhere(bool Function(dynamic element) test,
          {Function() orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable skip(int count) => _list.skip(count);

  @override
  Iterable skipWhile(bool Function(dynamic value) test) =>
      _list.skipWhile(test);

  @override
  void sort([int Function(dynamic a, dynamic b) compare]) =>
      _list.sort(compare);

  @override
  List sublist(int start, [int end]) => _list.sublist(start, end);

  @override
  Iterable take(int count) => _list.take(count);

  @override
  Iterable takeWhile(bool Function(dynamic value) test) =>
      _list.takeWhile(test);

  @override
  List<dynamic> toList({bool growable = true}) => _list.toList(growable: true);

  @override
  Set<dynamic> toSet() => _list.toSet();

  @override
  Iterable where(bool Function(dynamic element) test) => _list.where(test);

  @override
  Iterable<T> whereType<T>() => _list.whereType<T>();
}
