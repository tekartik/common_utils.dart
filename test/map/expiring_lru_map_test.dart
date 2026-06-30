import 'package:tekartik_common_utils/map/expiring_lru_map.dart';
import 'package:test/test.dart';

/// A [Stopwatch] whose elapsed time is controlled manually.
class FakeStopwatch implements Stopwatch {
  @override
  Duration elapsed = Duration.zero;

  void advance(Duration duration) => elapsed += duration;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ExpiringLruMap', () {
    // A long duration so size-based tests are not affected by expiration.
    const longDuration = Duration(days: 1);

    test('behaves like an LRU map', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 2,
        duration: longDuration,
      );
      map[1] = 'one';
      map[2] = 'two';
      map[3] = 'three';
      expect(map.length, 2);
      expect(map[1], isNull);
      expect(map[3], 'three');
    });

    test('is empty when initialized', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 2,
        duration: longDuration,
      );
      expect(map.length, 0);
    });

    test('disposes least recently used item when maximum size is reached', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 2,
        duration: longDuration,
      );
      map[1] = 'one';
      map[2] = 'two';
      map[3] = 'three';
      expect(map[1], isNull);
      expect(map[2], 'two');
      expect(map[3], 'three');
    });

    test('updates order of keys when a key is accessed', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 2,
        duration: longDuration,
      );
      map[1] = 'one';
      map[2] = 'two';
      // ignore: unnecessary_statements
      map[1];
      map[3] = 'three';
      expect(map[1], 'one');
      expect(map[2], isNull);
      expect(map[3], 'three');
    });

    test('remove method removes a key-value pair', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 2,
        duration: longDuration,
      );
      map[1] = 'one';
      map[2] = 'two';
      map.remove(1);
      expect(map[1], isNull);
      expect(map[2], 'two');
    });

    test('clear', () {
      var map = ExpiringLruMap<int, String>(
        maximumSize: 3,
        duration: longDuration,
      );
      map[1] = 'one';
      map[2] = 'two';
      expect(map.length, 2);
      map.clear();
      expect(map.length, 0);
    });

    test('expires entries after the given duration', () {
      var stopwatch = FakeStopwatch();
      var map = ExpiringLruMap<int, String>(
        duration: const Duration(seconds: 10),
        stopwatch: stopwatch,
      );
      map[1] = 'one';
      expect(map[1], 'one');

      // Just before expiration.
      stopwatch.advance(const Duration(seconds: 9));
      expect(map[1], 'one');

      // At/after expiration.
      stopwatch.advance(const Duration(seconds: 1));
      expect(map[1], isNull);
      expect(map.length, 0);
    });

    test('expiration is per entry', () {
      var stopwatch = FakeStopwatch();
      var map = ExpiringLruMap<int, String>(
        duration: const Duration(seconds: 10),
        stopwatch: stopwatch,
      );
      map[1] = 'one';
      stopwatch.advance(const Duration(seconds: 5));
      map[2] = 'two';

      stopwatch.advance(const Duration(seconds: 6)); // 1 -> 11s, 2 -> 6s
      expect(map[1], isNull);
      expect(map[2], 'two');
    });

    test('dispose is called on expiration', () {
      var stopwatch = FakeStopwatch();
      var disposed = <MapEntry<int, String>>[];
      var map = ExpiringLruMap<int, String>(
        duration: const Duration(seconds: 10),
        stopwatch: stopwatch,
        dispose: disposed.add,
      );
      map[1] = 'one';
      stopwatch.advance(const Duration(seconds: 11));
      expect(map[1], isNull);
      expect(disposed.map((e) => e.key), [1]);
    });

    test('purge removes expired entries', () {
      var stopwatch = FakeStopwatch();
      var map = ExpiringLruMap<int, String>(
        duration: const Duration(seconds: 10),
        stopwatch: stopwatch,
      );
      map[1] = 'one';
      map[2] = 'two';
      stopwatch.advance(const Duration(seconds: 11));
      map.purge();
      expect(map.length, 0);
    });
  });
}
