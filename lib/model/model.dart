import 'package:tekartik_common_utils/model/src/model.dart';
import 'package:tekartik_common_utils/model/src/model_entry.dart';
import 'package:tekartik_common_utils/model/src/model_list.dart';

/// Model class to use as a [Map<String, dynamic>].
abstract class Model implements Map<String, dynamic> {
  /// Get a value expecting a given type
  T getValue<T>(String key);

  /// Set a value or remove it if [value] is null and [presentIf] is not true
  void setValue<T>(String key, T value, {bool presentIfNull = false});

  /// Create a model. If map is null, the model
  /// is an empty map
  factory Model([Map<dynamic, dynamic> map]) {
    if (map is Model) {
      return map;
    }
    return ModelImpl(map);
  }

  /// Returns the model entry for this key.
  ///
  /// Returns a [ModelEntry] object telling where the key is present and
  /// its value
  ModelEntry getModelEntry(String key);

  /// Set the [entry] in the model
  void setModelEntry(ModelEntry entry);
}

/// List class to use as a [List<dynamic>].
abstract class ModelList implements List<dynamic> {
  /// Create a model. If list is null, the model
  /// is an empty list

  factory ModelList([Iterable<dynamic> iterable]) {
    if (iterable is ModelList) {
      return iterable;
    }
    return ModelListImpl(iterable);
  }
}

/// A model entry tells where a field exists and its value
///
/// To use a mixin, check [ModelMixin].
abstract class ModelEntry implements MapEntry<String, dynamic> {
  factory ModelEntry(String key, dynamic value, {bool presentIfNull = false}) {
    return ModelEntryImpl(key, value, presentIfNull: presentIfNull);
  }

  /// Create a null entry
  factory ModelEntry.nullEntry(String key) {
    return ModelEntryImpl(key, null, presentIfNull: true);
  }

  /// Create a model. If map is null, the model
  /// is an empty map
  factory ModelEntry.fromMapEntry(MapEntry<dynamic, dynamic> mapEntry) {
    if (mapEntry is ModelEntry) {
      return mapEntry;
    } else if (mapEntry == null) {
      return null;
    }
    return ModelEntryImpl.fromMapEntry(mapEntry);
  }

  /// true if contained
  bool get present;
}
