# tekartik_common_utils

Small pure Dart helpers shared by the tekartik packages: lenient parsing (`parseInt`, `parseBool`, json), string,
list and map helpers, hex and bytes, dates and durations, version parsing, tags, log formatting, stream combiners,
debounced runners and LRU caches. No `dart:io` and no browser code: it runs on the Dart VM, Flutter (mobile, desktop,
web), the browser (dart2js and dart2wasm) and node.

## Getting started

Not on pub.dev: add it from git in `pubspec.yaml`:

```yaml
dependencies:
  tekartik_common_utils:
    git:
      url: https://github.com/tekartik/common_utils.dart
    version: '^1.0.0'
```

Import the entry point of the area you need (never a `src/` file):

```dart
import 'package:tekartik_common_utils/json_utils.dart';
// Also exports parseInt and parseBool (bool_utils.dart, int_utils.dart).
import 'package:tekartik_common_utils/string_utils.dart';

void main() {
  // Lenient parsing: null (or the default) instead of an exception.
  var map = parseJsonObject('{"port": "8080", "verbose": "true"}')!;
  var port = parseInt(map['port'], 80)!; // 8080
  var verbose = parseBool(map['verbose'], false)!; // true
  print('$port $verbose');

  print('key=value=more'.splitFirst('=')); // [key, value=more]
  print(['item10', 'item2']..sort(stringsCompareWithLastInt)); // [item2, item10]
}
```

A longer tour is in [example/main.dart](example/main.dart).

## What is inside

| Entry point (`package:tekartik_common_utils/...`) | Use it for |
|---|---|
| `bool_utils.dart`, `int_utils.dart`, `num_utils.dart`, `json_utils.dart`, `cast_utils.dart` | parse untrusted values (`parseBool`, `parseInt`, `parseJsonObject`, `castAsOrNull`): they return null or the default, never throw |
| `string_utils.dart`, `list_utils.dart`, `map_utils.dart`, `hex_utils.dart`, `byte_utils.dart` | strings (`nonEmpty`, `splitFirst`, `truncate`), lists (`getOrNull`, `listChunk`), nested maps (`getPartsMapValue`), hex dumps |
| `date_time_utils.dart`, `duration_utils.dart`, `time_of_day.dart` | dates as UTC millis or ISO strings, `200.ms`, `1.5.days`, `TimeOfDay` |
| `version_utils.dart` | `parseVersion` (also `1.2` and `1.2.3.4`), `Version.bump()`, re-exports `pub_semver` |
| `env_utils.dart`, `log_utils.dart`, `log_format.dart`, `dev_utils.dart` | build mode and platform (`isDebug`, `kDartIsWeb`), quick logging, short log lines (`logFormat`) |
| `tags.dart`, `pack/pack.dart`, `size/size.dart`, `int_path/int_path.dart`, `ini_file_utils.dart` | tag lists and conditions, column packing of map lists, sizes, file sharding by id, `key=value` files |
| `stream/subject.dart`, `stream/stream_join.dart`, `stream/stream_poller.dart` | a broadcast controller with a current value, `streamJoin2`/`streamJoinAll`, pull events in tests |
| `async_utils.dart`, `lazy_runner/lazy_runner.dart`, `operation/operation.dart`, `map/lru_map.dart` | `sleep`, safe completer/controller calls, debounced runs (`LazyRunner`), LRU and expiring caches |

The package skills in [skills/](skills) describe each area with examples: values and collections
(`tekartik-common-utils-values`), streams and runners (`tekartik-common-utils-async`), environment, logging, versions
and tags (`tekartik-common-utils-env-logging`).

## Pitfalls

* `package:test` also exports a `Tags` class: next to `tags.dart`, `import 'package:test/test.dart' hide Tags;`.
* `size/size.dart` declares `Point`, as `dart:math` does: import one of them with a prefix.
* `parseVersion` throws a `FormatException` on bad input (`parseVersionOrNull` returns null), unlike the `parse*`
  value helpers.
* `cloneList` and `cloneMap` are for json like content (`List<Object?>`, `Map<String, Object?>`): a nested typed
  collection (`List<List<int>>`, `Map<String, Map<String, int>>`) throws a `TypeError`.
* In `TagsCondition`, a leading `!` applies to the rest of the expression: `!a && b` is `!(a && b)`; write `(!a) && b`
  for the other meaning.
* `LazyRunner` swallows the errors of its action (printed only in debug mode or with `debugLazyRunner = true`), and
  must be disposed.
* `logFormat` truncates (strings, lists, maps, depth): it is for logs only, never for data.

## Lints

The tekartik lints are in [tekartik_lints](https://github.com/tekartik/common.dart/tree/main/packages/lints); this
package keeps an alias:

```yaml
# analysis_options.yaml
include: package:tekartik_common_utils/lints/recommended.yaml
```

## Testing

```sh
dart test -p vm,chrome,node
```

Versioning follows the [tekartik versioning](https://github.com/tekartik/common.dart/blob/main/doc/tekartik_versioning.md)
conventions.
