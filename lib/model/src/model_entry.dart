import 'dart:core';

import 'package:tekartik_common_utils/model/model.dart';

// last mixin win!
class ModelEntryImpl with ModelEntryMixin implements ModelEntry {
  ModelEntryImpl.fromMapEntry(MapEntry<Object?, Object?> mapEntry) {
    if (mapEntry is MapEntry<String, Object?>) {
      _mapEntry = mapEntry;
    } else {
      _mapEntry =
          MapEntry<String, Object?>(mapEntry.key.toString(), mapEntry.value);
    }
  }

  ModelEntryImpl(String key, dynamic value) {
    _mapEntry = MapEntry<String, Object?>(key, value);
  }
}

mixin ModelEntryMixin implements ModelEntry {
  late MapEntry<String, Object?> _mapEntry;

  @override
  int get hashCode => key.hashCode + (value?.hashCode ?? 0);

  @override
  bool operator ==(other) {
    if (other is ModelEntry) {
      return key == other.key && value == other.value;
    }
    return false;
  }

  @override
  String get key => _mapEntry.key;

  @override
  Object? get value => _mapEntry.value;

  @override
  String toString() => "ModelEntry($key: $value'})";
}
