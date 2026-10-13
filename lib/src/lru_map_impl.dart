import 'dart:collection';

/// A map that keeps track of the last accessed keys.
class LruMap<K, V> extends MapBase<K, V> {
  /// The maximum number of entries in the map.
  final int? maximumSize;
  final _map = <K, V>{};
  final _keys = <K>[];

  /// A function that is called when an entry is removed from the map.
  final void Function(MapEntry<K, V> entry)? dispose;

  void _trigger(K key) {
    _keys.remove(key);
    _keys.add(key);
  }

  /// Create a LRU map with a maximum size.
  LruMap({this.maximumSize, this.dispose});

  /// Create an LRU map whose entries expire after [duration].
  ///
  /// This is a convenience constructor returning an [ExpiringLruMap].
  factory LruMap.expiring({
    required Duration duration,
    int? maximumSize,

    void Function(MapEntry<K, V> entry)? dispose,
    Stopwatch? stopwatch,
  }) = ExpiringLruMap<K, V>;
  @override
  V? operator [](Object? key) {
    if (key is! K || !_map.containsKey(key)) {
      return null;
    }
    _trigger(key);
    return _map[key];
  }

  void _dispose(K key) {
    if (dispose != null) {
      var value = _map[key];
      if (value != null) {
        dispose!(MapEntry(key, value));
      }
    }
    _keys.remove(key);
    _map.remove(key);
  }

  @override
  void operator []=(K key, V value) {
    if (maximumSize != null && !_keys.contains(key) && length >= maximumSize!) {
      _dispose(_keys.first);
    }
    _map[key] = value;
    _trigger(key);
  }

  @override
  void clear() {
    for (var key in List.of(_keys)) {
      _dispose(key);
    }
  }

  @override
  Iterable<K> get keys => _keys;

  @override
  V? remove(Object? key) {
    if (key is! K) {
      return null;
    }
    var value = _map[key];
    _dispose(key);
    return value;
  }

  // The iterations below read the values without the [] operator, which
  // would move each key to the end of [_keys] while it is being iterated.

  /// Value of a key present in the map, without changing the LRU order.
  V _peek(K key) => _map[key] as V;

  @override
  void forEach(void Function(K key, V value) action) {
    for (var key in keys) {
      action(key, _peek(key));
    }
  }

  @override
  Iterable<V> get values => keys.map(_peek);

  @override
  Iterable<MapEntry<K, V>> get entries =>
      keys.map((key) => MapEntry(key, _peek(key)));

  @override
  bool containsValue(Object? value) => values.contains(value);

  @override
  Map<K2, V2> map<K2, V2>(
    MapEntry<K2, V2> Function(K key, V value) transform,
  ) => Map.fromEntries(keys.map((key) => transform(key, _peek(key))));

  @override
  void updateAll(V Function(K key, V value) update) {
    for (var key in List.of(keys)) {
      this[key] = update(key, _peek(key));
    }
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    for (var key in keys.where((key) => test(key, _peek(key))).toList()) {
      remove(key);
    }
  }
}

/// A map that keeps track of the last accessed keys and expires entries after
/// a given [duration].
///
/// Like an [LruMap], the least recently used entry is removed when the
/// [maximumSize] is reached. In addition, an entry is considered gone once it
/// has been in the map for longer than [duration] (time to live).
///
/// Timing is based on a monotonic [Stopwatch] rather than the wall clock.
class ExpiringLruMap<K, V> extends LruMap<K, V> {
  /// How long an entry is kept in the cache before it expires.
  final Duration duration;

  /// Monotonic clock used to compute expirations.
  final Stopwatch _stopwatch;

  /// Elapsed time at which each entry expires.
  final _expirations = <K, Duration>{};

  /// Create an expiring LRU map.
  ///
  /// [duration] is how long an entry is kept before it expires.
  /// [maximumSize] is the maximum number of entries kept in the map.
  /// [dispose] is called when an entry is removed (by eviction, expiration,
  /// [remove] or [clear]).
  ///
  /// [stopwatch] overrides the monotonic clock, mainly for testing. It must
  /// already be started.
  ExpiringLruMap({
    required this.duration,
    super.maximumSize,
    super.dispose,
    Stopwatch? stopwatch,
  }) : _stopwatch = stopwatch ?? (Stopwatch()..start());

  bool _isExpired(K key) {
    var expiration = _expirations[key];
    if (expiration == null) {
      return false;
    }
    return _stopwatch.elapsed >= expiration;
  }

  /// Remove all entries that have expired.
  void purge() {
    for (var key in List.of(_keys)) {
      if (_isExpired(key)) {
        _dispose(key);
      }
    }
  }

  @override
  V? operator [](Object? key) {
    if (key is K && _isExpired(key)) {
      _dispose(key);
      return null;
    }
    return super[key];
  }

  @override
  void _dispose(K key) {
    super._dispose(key);
    _expirations.remove(key);
  }

  @override
  void operator []=(K key, V value) {
    super[key] = value;
    _expirations[key] = _stopwatch.elapsed + duration;
  }

  @override
  Iterable<K> get keys {
    purge();
    return super.keys;
  }
}
