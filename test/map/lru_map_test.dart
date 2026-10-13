import 'package:tekartik_common_utils/async_utils.dart';
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

  test('LruMap reading a missing key does not add it', () {
    var lruMap = LruMap<int, String>(maximumSize: 2);
    lruMap[1] = 'one';
    expect(lruMap[2], isNull);
    expect(lruMap.length, 1);
    expect(lruMap.containsKey(2), isFalse);
    lruMap[3] = 'three';
    expect(lruMap[1], 'one');
    expect(lruMap[3], 'three');
  });

  test('LruMap iterations do not change the order of keys', () {
    var lruMap = LruMap<int, String>(maximumSize: 3);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    lruMap[3] = 'three';
    expect(lruMap.toString(), '{1: one, 2: two, 3: three}');
    expect(lruMap.values, ['one', 'two', 'three']);
    expect(lruMap.entries.map((entry) => entry.key), [1, 2, 3]);
    var forEachValues = <String>[];
    lruMap.forEach((key, value) => forEachValues.add(value));
    expect(forEachValues, ['one', 'two', 'three']);
    expect(lruMap.containsValue('one'), isTrue);
    expect(lruMap.containsValue('four'), isFalse);
    expect(lruMap.map((key, value) => MapEntry(value, key)), {
      'one': 1,
      'two': 2,
      'three': 3,
    });
    expect(lruMap.keys, [1, 2, 3]);
    // 1 is still the least recently used
    lruMap[4] = 'four';
    expect(lruMap.keys, [2, 3, 4]);
  });

  test('LruMap updateAll and removeWhere', () {
    var disposed = <int>[];
    var lruMap = LruMap<int, String>(
      maximumSize: 3,
      dispose: (entry) => disposed.add(entry.key),
    );
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    lruMap[3] = 'three';
    lruMap.updateAll((key, value) => value.toUpperCase());
    expect(lruMap.keys, [1, 2, 3]);
    expect(lruMap.values, ['ONE', 'TWO', 'THREE']);
    lruMap.removeWhere((key, value) => key.isOdd);
    expect(lruMap.keys, [2]);
    expect(lruMap.values, ['TWO']);
    expect(disposed, [1, 3]);
  });

  test('clear', () {
    var lruMap = LruMap<int, String>(maximumSize: 3);
    lruMap[1] = 'one';
    lruMap[2] = 'two';
    expect(lruMap.length, 2);
    lruMap.clear();
    expect(lruMap.length, 0);
  });

  test('LruMap.expiring factory creates an ExpiringLruMap', () async {
    var stopwatch = Stopwatch()..start();
    // Typed as LruMap to verify the factory return type.
    // ignore: omit_local_variable_types
    LruMap<int, String> lruMap = LruMap<int, String>.expiring(
      maximumSize: 2,
      duration: const Duration(milliseconds: 100),
      stopwatch: stopwatch,
    );
    expect(lruMap, isA<ExpiringLruMap<int, String>>());
    lruMap[1] = 'one';
    expect(lruMap[1], 'one');
    await sleep(150);
    expect(lruMap[1], isNull);
  });
}
