---
name: tekartik-common-utils-values
description: >-
  Use when parsing, converting or massaging plain Dart values with
  tekartik_common_utils: parseBool, parseInt, parseNum, parseJson /
  parseJsonObject / encodeJson / jsonPretty, castAsOrNull and asOrNull,
  nonNull, string helpers (nonEmpty, trimmedNonEmpty, splitFirst, truncate,
  obfuscate, stringPrefilled, stringsCompareWithLastInt), list/iterable
  helpers (getOrNull, firstWhereOrNull, listChunk, listEquals, flatten,
  intersectList, LazyReadOnlyList), map helpers (mergeMap, cloneMap,
  anyAsMapOrNull, getPartsMapValue, setPartsMapValue, mapValueFromPath,
  keySortedMap), hex and bytes (toHexString, parseHexBytes, hexPretty,
  asUint8List), dates and durations (anyToDateTime, dateTimeToInt,
  reverseDateCompare, 200.ms, 1.5.days, TimeOfDay), plus pack, size and
  int_path.
---

# Value, collection and date utilities (tekartik_common_utils)

`tekartik_common_utils` is a pure Dart package (no `dart:io`, no browser code)
of small independent helpers shared by every tekartik project. This skill
covers the "data" half: parsing untrusted values, strings, collections, maps,
JSON, hex/bytes, dates and durations. For streams, futures and caches see
`tekartik-common-utils-async`; for build-mode detection and logging see
`tekartik-common-utils-env-logging`.

## Guidelines

* Dependency (git, not on pub.dev — the repo is a single package, so no
  `path:` in the git block):
  ```yaml
  dependencies:
    tekartik_common_utils:
      git:
        url: https://github.com/tekartik/common_utils.dart
      version: '^1.0.0'
  ```
* Import one entry point per area, never a `src/` file — every
  `lib/<name>.dart` re-exports only what is public:
  `bool_utils.dart`, `int_utils.dart`, `num_utils.dart`, `value_utils.dart`,
  `cast_utils.dart`, `comparable_utils.dart`, `string_utils.dart`,
  `list_utils.dart`, `iterable_utils.dart`, `map_utils.dart`,
  `json_utils.dart`, `hex_utils.dart`, `byte_utils.dart`,
  `byte_data_utils.dart`, `date_time_utils.dart`, `duration_utils.dart`,
  `time_of_day.dart`, `uri_utils.dart`, `ini_file_utils.dart`,
  `hash_code_utils.dart`, `string_enum.dart`, `tags.dart`,
  `pack/pack.dart`, `size/size.dart`, `size/int_size.dart`,
  `int_path/int_path.dart`.
  `common_utils_import.dart` is a barrel over `dart:async`, `dart:collection`,
  `dart:convert`, `package:meta`, `package:synchronized` plus
  `async_utils`, `bool_utils`, `cast_utils`, `dev_utils`, `future_utils`,
  `int_utils`, `json_utils`, `version_utils`; handy inside this ecosystem,
  noisy in application code.
* House style: **nothing throws by default**. `parseInt`, `parseBool`,
  `parseNum`, `parseJson*`, `anyToDateTime`, `parseDateTime`,
  `castAsOrNull` and friends take `Object?` and return `null` (or the
  supplied default) when the input is unusable. Pass the optional positional
  default (`parseInt(value, 0)`) instead of writing `?? 0`.
* `castAsOrNull<T>(object)` / `object.asOrNull<T>()`
  (`TekartikObjectAsOrNullExtension`, declared on non-nullable `Object`) do a
  checked cast returning `null` on failure; `castAsNullable<T>` only relaxes
  the static type. `nonNull(value, defaultValue)` from `value_utils.dart` is
  the generic `??`.
* Strings: prefer the extensions on `String`
  (`nonEmpty`, `trimmedNonEmpty`, `parseInt`, `tryParseInt`, `getLastInt`,
  `splitFirst`, `truncate`, `obfuscate`, `isOnlyAlphaNumeric`, `isOnlyDigit`,
  `isOnlyWhitespaces`, `beginsOrEndsWithWhitespaces`) over the older
  free functions (`stringIsEmpty`, `stringNonEmpty`, `stringSubString`,
  `stringTruncate`, `stringNonNull`, `stringPrefilled`). `stringSubString`
  and `stringTruncate` never throw on out-of-range indexes.
  `stringsCompareWithLastInt` is a `List<String>.sort` comparator ordering
  `item2` before `item10`.
* Collections: `list_utils.dart` exports the extensions
  `TekartikCommonListExtension` (`nonEmpty`, `getOrNull`),
  `TekartikCommonIterableExtension` (`firstWhereOrNull`, `containsAny`),
  `TekartikCommonListListExtension`/`TekartikCommonIterableIterableExtension`
  (`flatten`), `TekartikCommonListOrNullExtension` (`nonNull`) and
  `listEquals`. `iterable_utils.dart` is the same iterable extension alone.
  `listFirst`, `listLast`, `listLength`, `listGet` and `truncate` are
  deprecated — use the extensions or `listTruncate`.
  `LazyReadOnlyList` / `iterable.lazy((e) => ...)` build a read-only list
  whose elements are transformed on first read and cached.
* Maps: `mapValue(map, key, createIfNull: () => ...)` memoizes,
  `anyAsMap`/`anyAsMapOrNull` retype a decoded JSON `Map` to
  `Map<String, Object?>`, `getPartsMapValue`/`setPartsMapValue` walk nested
  maps by key path and `mapValueFromPath(map, 'a/b')` splits on `/`.
  `keySortedMap()` (`TekartikStringObjectMapExtension`) returns a copy sorted
  by key — useful to make JSON output deterministic. `asMap` and `dumpMap`
  are legacy.
* Hex: `toHexString(bytes)` and `Uint8List.toHexString()` emit **uppercase**,
  `toLohexString(bytes)` lowercase; `parseHexString`/`parseHexBytes` (and
  `'01ff'.hexParseUint8List()`) read both cases. `hexQuickView` is a one-line
  view for logs, `hexPretty`/`hexPrettyLines` the classic 16-byte dump.
  `byte_data_utils.dart` converts between `ByteData` and `Uint8List` keeping
  the buffer offset.
* Dates: `dateTimeToInt`/`dateTimeFromInt` round-trip through UTC millis,
  `dateTimeToString` writes UTC ISO-8601, `anyToDateTime` accepts a
  `DateTime`, an ISO string or an int. `reverseDateCompare` is a
  newest-first comparator with nulls last. `dateTimeWithTimeCleared` keeps
  the UTC/local flag (`newDateTimeClearTime` is deprecated).
  `duration_utils.dart` adds `200.ms`, `3.seconds`, `1.5.days` on `num`
  (all computed in microseconds, so fractions work). `TimeOfDay` normalizes
  hour/minute and parses/prints `HH:mm`.
* Other small helpers that live in this package: `parseIniLines` for
  `key=value` files, `locationSearchGetArguments` plus
  `uri.removeParametersAndFragment()` in `uri_utils.dart`, `safeHashCode`,
  the `StringEnum` base class, `Tags`/`TagsCondition` in `tags.dart`,
  `packList`/`unpackList`/`compackAny` in `pack/pack.dart`, the generic
  `Size`/`Point`/`Rect` and `sizeIntContainedWithRatio` in `size/size.dart`
  (int-specialized in `size/int_size.dart`, with `stringParseSize('64x48')`),
  and `intToFilePath`/`intToFileParts` in `int_path/int_path.dart` to shard
  files by integer id.
* Anti-patterns: importing `package:tekartik_common_utils/src/...`; importing
  `size/size.dart` together with `dart:math` unbound (both declare `Point`,
  use `as` prefix); assuming `parseInt` throws on bad input; calling
  `.asOrNull<T>()` on an `Object?` receiver (the extension is on `Object`, so
  null-check or use `castAsOrNull<T>(value)` first).
* Testing: the package is tested with `package:test` on every platform —
  `dart test -p vm,chrome,node`. Pure helpers make plain unit tests; keep
  them platform-agnostic, that is the point of this package.

## Examples

### Parsing an untyped map (config, JSON, query string)

```dart
import 'package:tekartik_common_utils/bool_utils.dart';
import 'package:tekartik_common_utils/cast_utils.dart';
import 'package:tekartik_common_utils/int_utils.dart';
import 'package:tekartik_common_utils/json_utils.dart';
import 'package:tekartik_common_utils/num_utils.dart';
import 'package:tekartik_common_utils/value_utils.dart';

class ServerConfig {
  final int port;
  final bool verbose;
  final num ratio;

  ServerConfig.fromMap(Map<String, Object?> map)
    : port = parseInt(map['port'], 8080)!,
      verbose = parseBool(map['verbose'], false)!,
      ratio = nonNull(parseNum(map['ratio']), 1);
}

void main() {
  // parseJsonObject never throws: bad json yields the default (or null).
  var map = parseJsonObject('{"port":"9000","verbose":"true"}', {})!;
  var config = ServerConfig.fromMap(map);
  print('${config.port} ${config.verbose} ${config.ratio}');

  Object raw = <String, Object?>{'a': 1};
  print(raw.asOrNull<Map<String, Object?>>());
  print(castAsOrNull<List<Object?>>(raw)); // null, no exception
  print(jsonPretty(map));
}
```

### String helpers and natural sort

```dart
import 'package:tekartik_common_utils/string_utils.dart';

void main() {
  print('  hello  '.trimmedNonEmpty() ?? '<empty>');
  print('key=value=more'.splitFirst('=')); // [key, value=more]
  print('a very long text'.truncate(7, ellipsis: true));
  print('secret-token-1234'.obfuscate()); // keeps 4 first/last chars
  print('item42'.getLastInt()); // 42
  print(stringPrefilled('7', 3, '0')); // 007
  print(stringIsNotEmpty(null)); // false
  print('abc123'.isOnlyAlphaNumeric());

  var names = ['item1', 'item10', 'item2'];
  names.sort(stringsCompareWithLastInt);
  print(names); // [item1, item2, item10]
}
```

### Lists, iterables and nested maps

```dart
import 'package:tekartik_common_utils/list_utils.dart';
import 'package:tekartik_common_utils/map_utils.dart';

void main() {
  var list = [1, 2, 3, 4, 5];
  print(list.getOrNull(9)); // null instead of RangeError
  print(list.firstWhereOrNull((e) => e > 3));
  print(list.containsAny([9, 5]));
  print(listChunk(list, 2)); // [[1, 2], [3, 4], [5]]
  print(listEquals(list, [1, 2, 3, 4, 5]));
  print(intersectList(list, [4, 5, 6]));
  print([
    [1, 2],
    [3],
  ].flatten());
  print(list.lazy((e) => 'n$e')); // transformed on first read

  var map = <String, Object?>{
    'a': {'b': 1},
  };
  print(getPartsMapValue<int>(map, ['a', 'b']));
  setPartsMapValue(map, ['a', 'c'], 2);
  print(mapValueFromPath<int>(map, 'a/c'));
  print(mergeMap({'x': 1}, {'y': 2}));
  print(anyAsMapOrNull<String, Object?>(map['a'])?.keySortedMap());
}
```

### Hex and bytes

```dart
import 'dart:typed_data';

import 'package:tekartik_common_utils/byte_utils.dart';
import 'package:tekartik_common_utils/hex_utils.dart';

void main() {
  var bytes = Uint8List.fromList([1, 2, 255]);
  print(bytes.toHexString()); // 0102FF (uppercase)
  print(toLohexString(bytes)); // 0102ff
  print(parseHexBytes('0102ff')); // [1, 2, 255]
  print('0000ffff'.hexParseUint32());
  print(0xffff.uint32ToHexString());
  print(hexQuickView(bytes)); // one line, for logs
  print(hexPretty(bytes)); // 16-byte-per-line dump
  print(asUint8List(<int>[1, 2, 3])); // no copy if already a Uint8List
}

Future<Uint8List> readAll(Stream<List<int>> stream) => listStreamGetBytes(stream);
```

### Dates, durations and time of day

```dart
import 'package:tekartik_common_utils/date_time_utils.dart';
import 'package:tekartik_common_utils/duration_utils.dart';
import 'package:tekartik_common_utils/time_of_day.dart';

void main() {
  var date = anyToDateTime('2024-03-15T10:30:00.000Z')!;
  print(formatYYYYdashMMdashDD(date)); // 2024-03-15
  var millis = dateTimeToInt(date)!;
  print(dateTimeFromInt(millis)); // same instant, utc
  print(dateTimeToString(date)); // utc iso-8601
  print(dateTimeWithTimeCleared(date));

  var dates = [DateTime.utc(2024), DateTime.utc(2025)]..sort(reverseDateCompare);
  print(dates); // newest first

  print(200.ms + 1.5.days); // 36:00:00.200000
  print(dayInMillis);

  var tod = TimeOfDay.parse('23:45');
  print('$tod ${tod.milliseconds}');
  print(timeOfDayUtcToLocal(tod));
}
```

## Common mistakes

* Reaching into `package:tekartik_common_utils/src/...`: always import the
  public `lib/<name>.dart` entry point.
* Using the deprecated `listFirst`/`listLast`/`listGet`/`truncate`/`asMap`
  instead of `firstWhereOrNull`/`getOrNull`/`listTruncate`/`anyAsMapOrNull`.
* Expecting `toHexString` to be lowercase (it is uppercase; use
  `toLohexString`).
* Forgetting that `dateTimeFromInt` always returns a **UTC** `DateTime`.
* Calling `size/size.dart`'s `Point` where `dart:math`'s `Point` is meant.
