import 'dart:collection';
import 'dart:core';

import 'package:tekartik_common_utils/model/model.dart';
import 'package:tekartik_common_utils/model/src/model_entry.dart';

// last mixin win!
class ModelImpl extends ModelBase {
  ModelImpl(Map<Object?, Object?>? map) : super(map);
}

abstract class ModelBase with MapMixin<String, Object?>, ModelBaseMixin {
  ModelBase(Map<Object?, Object?>? map) {
    __map = map?.cast<String, Object?>();
  }
}

/// Only create the model if non null
Model? asModel(dynamic map) => map is Map ? Model(map) : null;

mixin ModelBaseMixin implements Model {
  /// slow implementation for null value
  /// could be overriden by implementation
  /// Returns null if it does not exists
  @override
  ModelEntry? getModelEntry(String key) {
    dynamic value = _map[key];
    if (value == null) {
      if (!containsKey(key)) {
        return null;
      }
    }
    return ModelEntryImpl(key, value);
  }

  @override
  T? getValue<T>(String key) => _map[key] as T?;

  @override
  void setValue<T>(String key, T value, {bool presentIfNull = false}) {
    if (value == null && (presentIfNull != true)) {
      _map.remove(key);
    } else {
      _map[key] = value;
    }
  }

  Map<String, Object?>? __map;

  Map<String, Object?> get _map => __map ??= <String, Object?>{};

  @override
  dynamic operator [](Object? key) => _map[key as String];

  @override
  void operator []=(String key, value) => _map[key] = value;

  @override
  void addAll(Map<String, Object?> other) => _map.addAll(other);

  @override
  void addEntries(Iterable<MapEntry<String, Object?>> newEntries) =>
      _map.addEntries(newEntries);

  @override
  Map<RK, RV> cast<RK, RV>() => _map.cast<RK, RV>();

  @override
  void clear() => _map.clear();

  @override
  bool containsKey(Object? key) => _map.containsKey(key);

  @override
  bool containsValue(Object? value) => _map.containsValue(value);

  @override
  Iterable<MapEntry<String, Object?>> get entries => _map.entries;

  @override
  void forEach(void Function(String key, dynamic value) f) => _map.forEach(f);

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  Iterable<String> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  Map<K2, V2> map<K2, V2>(
          MapEntry<K2, V2> Function(String key, dynamic value) f) =>
      _map.map(f);

  @override
  dynamic putIfAbsent(String key, Object? Function() ifAbsent) =>
      _map.putIfAbsent(key, ifAbsent);

  @override
  dynamic remove(Object? key) => _map.remove(key);

  @override
  void removeWhere(bool Function(String key, dynamic value) predicate) =>
      _map.removeWhere(predicate);

  @override
  dynamic update(String key, Object? Function(dynamic value) update,
          {Object? Function()? ifAbsent}) =>
      _map.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(Object? Function(String key, dynamic value) update) =>
      _map.updateAll(update);

  @override
  Iterable get values => _map.values;
}
