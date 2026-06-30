import 'dart:collection';

import 'lru_map.dart';

/// A map that keeps track of the last accessed keys and expires entries after
/// a given [duration].
///
/// Like an [LruMap], the least recently used entry is removed when the
/// [maximumSize] is reached. In addition, an entry is considered gone once it
/// has been in the map for longer than [duration] (time to live).
///
/// Timing is based on a monotonic [Stopwatch] rather than the wall clock.
class ExpiringLruMap<K, V> extends MapBase<K, V> implements LruMap<K, V> {
  /// The maximum number of entries in the map.
  @override
  final int? maximumSize;

  /// How long an entry is kept in the cache before it expires.
  final Duration duration;

  /// Monotonic clock used to compute expirations.
  final Stopwatch _stopwatch;

  final _map = <K, V>{};
  final _keys = <K>[];

  /// Elapsed time at which each entry expires.
  final _expirations = <K, Duration>{};

  /// A function that is called when an entry is removed from the map.
  @override
  final void Function(MapEntry<K, V> entry)? dispose;

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
    this.maximumSize,
    this.dispose,
    Stopwatch? stopwatch,
  }) : _stopwatch = stopwatch ?? (Stopwatch()..start());

  void _trigger(K key) {
    _keys.remove(key);
    _keys.add(key);
  }

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
    if (key is! K) {
      return null;
    }
    if (_isExpired(key)) {
      _dispose(key);
      return null;
    }
    if (!_map.containsKey(key)) {
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
    _expirations.remove(key);
  }

  @override
  void operator []=(K key, V value) {
    if (maximumSize != null && !_keys.contains(key) && length >= maximumSize!) {
      _dispose(_keys.first);
    }
    _map[key] = value;
    _expirations[key] = _stopwatch.elapsed + duration;
    _trigger(key);
  }

  @override
  void clear() {
    for (var key in List.of(_keys)) {
      _dispose(key);
    }
  }

  @override
  Iterable<K> get keys {
    purge();
    return _keys;
  }

  @override
  V? remove(Object? key) {
    if (key is! K) {
      return null;
    }
    var value = _map[key];
    _dispose(key);
    return value;
  }
}
