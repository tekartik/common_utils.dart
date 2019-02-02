import 'dart:core';

import 'package:tekartik_common_utils/model/model.dart';

// last mixin win!
class ModelEntryImpl with ModelEntryMixin implements ModelEntry {
  ModelEntryImpl.fromMapEntry(MapEntry<dynamic, dynamic> mapEntry) {
    if (mapEntry is MapEntry<String, dynamic>) {
      _mapEntry = mapEntry;
    } else {
      _mapEntry =
          MapEntry<String, dynamic>(mapEntry.key?.toString(), mapEntry.value);
    }
    present = mapEntry != null;
  }

  ModelEntryImpl(String key, dynamic value, {bool presentIfNull = false}) {
    _mapEntry = MapEntry<String, dynamic>(key, value);
    present = (value != null) || (presentIfNull == true);
  }
}

mixin ModelEntryMixin implements ModelEntry {
  @override
  bool present;

  MapEntry<String, dynamic> _mapEntry;

  @override
  int get hashCode => key.hashCode ?? 0 + value?.hashCode ?? 0;

  @override
  bool operator ==(other) {
    if (other is ModelEntry) {
      return key == other.key &&
          value == other.value &&
          present == other.present;
    }
    return false;
  }

  @override
  String get key => _mapEntry.key;

  @override
  dynamic get value => _mapEntry.value;

  @override
  String toString() => "ModelEntry($key: ${present ? value : 'undefined'})";
}
