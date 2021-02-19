import 'package:tekartik_common_utils/model/src/model.dart';
import 'package:tekartik_common_utils/model/src/model_entry.dart';
import 'package:tekartik_common_utils/model/src/model_list.dart';
export 'package:tekartik_common_utils/model/src/model.dart'
    show ModelBase, asModel;
export 'package:tekartik_common_utils/model/src/model_list.dart'
    show ModelListBase, asModelList;

/// Model class to use as a [Map<String, Object?>].
abstract class Model implements Map<String, Object?> {
  /// Get a value expecting a given type
  T? getValue<T>(String key);

  /// Set a value or remove it if [value] is null and [presentIfNull]
  /// is not true
  void setValue<T>(String key, T value, {bool presentIfNull = false});

  /// Create a model. If map is null, the model
  /// is an empty map
  factory Model([Map<dynamic, dynamic>? map]) {
    if (map is Model) {
      return map;
    }
    return ModelImpl(map);
  }

  /// Returns the model entry for this key.
  ///
  /// Returns a [ModelEntry] object or null if the key is not present
  ModelEntry? getModelEntry(String key);
}

/// List class to use as a [List<dynamic>].
abstract class ModelList implements List<Model?> {
  /// Create a model. If list is null, the model
  /// is an empty list

  factory ModelList([Iterable<dynamic>? iterable]) {
    if (iterable is ModelList) {
      return iterable;
    }
    return ModelListImpl(iterable);
  }
}

/// A model entry tells where a field exists and its value
///
/// To use a mixin, check [ModelMixin].
abstract class ModelEntry implements MapEntry<String, Object?> {
  /// Create a model with a given key and value
  factory ModelEntry(String key, dynamic value) {
    return ModelEntryImpl(key, value);
  }

  /// Create a model.
  factory ModelEntry.fromMapEntry(MapEntry<Object?, Object?> mapEntry) {
    if (mapEntry is ModelEntry) {
      return mapEntry;
    }
    return ModelEntryImpl.fromMapEntry(mapEntry);
  }
}
