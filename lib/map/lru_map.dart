import 'dart:collection';

class LruMap<K, V> extends MapBase<K?, V> {
  final int? maximumSize;
  final _map = <K, V>{};
  final _keys = <K>[];
  final void Function(MapEntry<K?, V?> entry)? dispose;

  void _trigger(K key) {
    _keys.remove(key);
    _keys.add(key);
  }

  LruMap({this.maximumSize, this.dispose});
  @override
  V? operator [](Object? key) {
    _trigger(key as K);
    return _map[key];
  }

  void _dispose(K key) {
    if (dispose != null) {
      var value = _map[key];
      dispose!(MapEntry(key, value));
    }
    _keys.remove(key);
    _map.remove(key);
  }

  @override
  void operator []=(K? key, V value) {
    if (maximumSize != null && !_keys.contains(key) && length >= maximumSize!) {
      _dispose(_keys.first);
    }
    _map[key!] = value;
    _trigger(key);
  }

  @override
  void clear() {
    for (var key in _keys) {
      _dispose(key);
    }
  }

  @override
  Iterable<K> get keys => _keys;

  @override
  V? remove(Object? key) {
    var value = _map[key as K];
    _dispose(key);
    return value;
  }
}
