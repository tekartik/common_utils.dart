// ignore_for_file: avoid_print

import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/date_time_utils.dart';
import 'package:tekartik_common_utils/duration_utils.dart';
import 'package:tekartik_common_utils/hex_utils.dart';
import 'package:tekartik_common_utils/json_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';
import 'package:tekartik_common_utils/list_utils.dart';
import 'package:tekartik_common_utils/log_format.dart';
import 'package:tekartik_common_utils/map/lru_map.dart';
import 'package:tekartik_common_utils/map_utils.dart';
import 'package:tekartik_common_utils/stream/stream_join.dart';
import 'package:tekartik_common_utils/string_utils.dart';
import 'package:tekartik_common_utils/tags.dart';
import 'package:tekartik_common_utils/version_utils.dart';

Future<void> main() async {
  // Lenient parsing: null or the default value, never an exception.
  var config = parseJsonObject('{"port": "8080", "debug": 1}')!;
  print(parseInt(config['port'], 80)); // 8080
  print(parseBool(config['debug'], false)); // true
  print(parseJsonObject('not json')); // null

  // Strings and lists.
  print('  text  '.trimmedNonEmpty()); // text
  print('a=b=c'.splitFirst('=')); // [a, b=c]
  print(['file10', 'file2', 'file']..sort(stringsCompareWithLastInt));
  print(listChunk([1, 2, 3, 4, 5], 2)); // [[1, 2], [3, 4], [5]]
  print([1, 2].getOrNull(5)); // null

  // Nested maps.
  var map = <String, Object?>{};
  setPartsMapValue(map, ['a', 'b'], 1);
  print(getPartsMapValue<int>(map, ['a', 'b'])); // 1

  // Hex, dates and durations.
  print(toHexString([1, 2, 255])); // 0102FF
  print(
    dateTimeToString(DateTime.utc(2024, 3, 15)),
  ); // 2024-03-15T00:00:00.000Z
  print(1.5.seconds); // 0:00:01.500000

  // Versions (pub_semver re-exported).
  print(parseVersion('1.2')); // 1.2.0
  print(Version.parse('1.2.3').bump(minor: true)); // 1.3.0

  // Tags and conditions.
  var tags = Tags.fromText('dev, linux');
  print(TagsCondition('dev && (linux || macos)').check(tags)); // true

  // Short log lines.
  print(logFormat({'items': List.generate(20, (i) => i)})); // 5 items kept

  // Latest values of several streams.
  await for (var (name, count) in streamJoin2(
    Stream.value('a'),
    Stream.value(1),
  )) {
    print('$name $count'); // a 1
  }

  // Debounced work: many triggers, few runs.
  var runner = LazyRunner(
    action: (count) async {
      print('save #$count');
    },
  );
  runner
    ..trigger()
    ..trigger();
  await sleep(50);
  runner.dispose();

  // LRU cache.
  var cache = LruMap<String, int>(maximumSize: 2);
  cache['a'] = 1;
  cache['b'] = 2;
  cache['c'] = 3; // evicts 'a'
  print(cache.keys); // [b, c]
}
