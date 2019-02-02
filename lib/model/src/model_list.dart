import 'dart:collection';

import 'package:tekartik_common_utils/model/model.dart';

// last mixin wins
class ModelListImpl
    with ListMixin<dynamic>, ModelListMixin
    implements ModelList {
  ModelListImpl(Iterable<dynamic> iterable) {
    __list = iterable?.cast<dynamic>()?.toList();
  }
}

mixin ModelListMixin implements List<dynamic> {
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
/*
  @override
  List<dynamic> operator +(List<dynamic> other) => _list + other;
*/
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

/*
  @override
  void forEach(void Function(element) f) {
    // TODO: implement forEach
  }

  @override
  Iterable getRange(int start, int end) {
    // TODO: implement getRange
    return null;
  }

  @override
  int indexOf(element, [int start = 0]) {
    // TODO: implement indexOf
    return null;
  }

  @override
  int indexWhere(bool Function(element) test, [int start = 0]) {
    // TODO: implement indexWhere
    return null;
  }

  @override
  void insert(int index, element) {
    // TODO: implement insert
  }

  @override
  void insertAll(int index, Iterable iterable) {
    // TODO: implement insertAll
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => null;

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => null;

  @override
  // TODO: implement iterator
  Iterator get iterator => null;

  @override
  String join([String separator = ""]) {
    // TODO: implement join
    return null;
  }

  @override
  int lastIndexOf(element, [int start]) {
    // TODO: implement lastIndexOf
    return null;
  }

  @override
  int lastIndexWhere(bool Function(element) test, [int start]) {
    // TODO: implement lastIndexWhere
    return null;
  }

  @override
  lastWhere(bool Function(element) test, {Function() orElse}) {
    // TODO: implement lastWhere
    return null;
  }

  @override
  Iterable<T> map<T>(T Function(e) f) {
    // TODO: implement map
    return null;
  }

  @override
  reduce(Function(value, element) combine) {
    // TODO: implement reduce
    return null;
  }

  @override
  bool remove(Object value) {
    // TODO: implement remove
    return null;
  }

  @override
  removeAt(int index) {
    // TODO: implement removeAt
    return null;
  }

  @override
  removeLast() {
    // TODO: implement removeLast
    return null;
  }

  @override
  void removeRange(int start, int end) {
    // TODO: implement removeRange
  }

  @override
  void removeWhere(bool Function(element) test) {
    // TODO: implement removeWhere
  }

  @override
  void replaceRange(int start, int end, Iterable replacement) {
    // TODO: implement replaceRange
  }

  @override
  void retainWhere(bool Function(element) test) {
    // TODO: implement retainWhere
  }

  @override
  // TODO: implement reversed
  Iterable get reversed => null;

  @override
  void setAll(int index, Iterable iterable) {
    // TODO: implement setAll
  }

  @override
  void setRange(int start, int end, Iterable iterable, [int skipCount = 0]) {
    // TODO: implement setRange
  }

  @override
  void shuffle([Random random]) {
    // TODO: implement shuffle
  }

  @override
  // TODO: implement single
  get single => null;

  @override
  singleWhere(bool Function(element) test, {Function() orElse}) {
    // TODO: implement singleWhere
    return null;
  }

  @override
  Iterable skip(int count) {
    // TODO: implement skip
    return null;
  }

  @override
  Iterable skipWhile(bool Function(value) test) {
    // TODO: implement skipWhile
    return null;
  }

  @override
  void sort([int Function(a, b) compare]) {
    // TODO: implement sort
  }

  @override
  List sublist(int start, [int end]) {
    // TODO: implement sublist
    return null;
  }

  @override
  Iterable take(int count) {
    // TODO: implement take
    return null;
  }

  @override
  Iterable takeWhile(bool Function(value) test) {
    // TODO: implement takeWhile
    return null;
  }

  @override
  List toList({bool growable = true}) {
    // TODO: implement toList
    return null;
  }

  @override
  Set toSet() {
    // TODO: implement toSet
    return null;
  }

  @override
  Iterable where(bool Function(element) test) {
    // TODO: implement where
    return null;
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
    return null;
  }
  */

}
