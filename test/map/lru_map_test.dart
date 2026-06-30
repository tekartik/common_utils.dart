import 'package:tekartik_common_utils/map/expiring_lru_map.dart';
import 'package:tekartik_common_utils/map/lru_map.dart';
import 'package:test/test.dart';

void main() {
  test('LruMap', () {
    var lruMap = LruMap<int, String>(maximumSize: 2);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    lruMap[3] = 'three';
    expect(lruMap.length, 2);
    expect(lruMap[1], isNull);
    expect(lruMap[3], 'three');
  });

  test('LruMap is empty when initialized', () {
    var lruMap = LruMap<int, String>(maximumSize: 2);
    expect(lruMap.length, 0);
  });

  test(
    'LruMap disposes least recently used item when maximum size is reached',
    () {
      var lruMap = LruMap<int, String>(maximumSize: 2);
      lruMap[1] = 'one';
      lruMap[2] = 'two';
      lruMap[3] = 'three';
      expect(lruMap[1], isNull);
      expect(lruMap[2], 'two');
      expect(lruMap[3], 'three');
    },
  );

  test('LruMap updates order of keys when a key is accessed', () {
    var lruMap = LruMap<int, String>(maximumSize: 2);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    // ignore: unnecessary_statements
    lruMap[1];
    lruMap[3] = 'three';
    expect(lruMap[1], 'one');
    expect(lruMap[2], isNull);
    expect(lruMap[3], 'three');
  });

  test('LruMap remove method removes a key-value pair', () {
    var lruMap = LruMap<int, String>(maximumSize: 2);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    lruMap.remove(1);
    expect(lruMap[1], isNull);
    expect(lruMap[2], 'two');
  });

  test('clear', () {
    var lruMap = LruMap<int, String>(maximumSize: 3);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    expect(lruMap.length, 2);
    lruMap.clear();
    expect(lruMap.length, 0);
  });

  test('LruMap.expiring factory creates an ExpiringLruMap', () {
    var stopwatch = Stopwatch()..start();
    // Typed as LruMap to verify the factory return type.
    // ignore: omit_local_variable_types
    LruMap<int, String> lruMap = LruMap<int, String>.expiring(
      maximumSize: 2,
      duration: const Duration(milliseconds: 1),
      stopwatch: stopwatch,
    );
    expect(lruMap, isA<ExpiringLruMap<int, String>>());
    lruMap[1] = 'one';
    expect(lruMap[1], 'one');
  });
}
