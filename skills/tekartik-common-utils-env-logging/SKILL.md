---
name: tekartik-common-utils-env-logging
description: >-
  Use when detecting the build mode or platform, logging, or handling
  versions and tags with tekartik_common_utils: isDebug / isRelease,
  kDartIsWeb, kDartIsWebJs, kDartIsWebWasm, isRunningAsJavascript,
  kDartIoReleaseMode, kFlutterDebugMode / kFlutterIsWeb from
  foundation/constants.dart, debugEnvMap, devPrint / debugDevPrint /
  devWarning / DevFlag / devTrue, setupQuickLogging, parseLogLevel, Logger
  and Level re-exported from package:logging, logFormat and LogFormatOptions,
  OutBuffer, parseVersion / parseVersionOrNull / Version.bump, Tags and
  TagsCondition, and the shared lints
  (include: package:tekartik_common_utils/lints/recommended.yaml).
---

# Environment, logging, versions and tags (tekartik_common_utils)

`tekartik_common_utils` detects the build mode and the runtime platform
without any conditional import (only `const bool.fromEnvironment` values and
the assert trick), wraps `package:logging` with a one-call setup, and carries
the shared lint config used by every tekartik package. For parsing and
collections see `tekartik-common-utils-values`; for streams and runners see
`tekartik-common-utils-async`.

## Guidelines

* Dependency (git, not on pub.dev — single-package repo, no `path:`):
  ```yaml
  dependencies:
    tekartik_common_utils:
      git:
        url: https://github.com/tekartik/common_utils.dart
      version: '^1.0.0'
  ```
* Lints: every tekartik package points its `analysis_options.yaml` at this
  package (which itself delegates to `package:tekartik_lints`):
  ```yaml
  include: package:tekartik_common_utils/lints/recommended.yaml
  ```
  That set turns on `strict-casts` and `strict-inference`, plus
  `avoid_print`, `unawaited_futures`, `omit_local_variable_types`,
  `prefer_single_quotes`, `directives_ordering` and friends.
  `lib/pedantic/analysis_options.yaml` is a deprecated alias of the same
  file.
* Build mode, from `env_utils.dart`:
  - `isDebug` / `isRelease` are **runtime** getters based on whether
    `assert` runs; they work outside Flutter and outside `dart:io`.
  - `kDartIoReleaseMode`, `kDartIoProfileMode`, `kDartIoDebugMode` are
    compile-time `bool.fromEnvironment('dart.vm.product'/'dart.vm.profile')`
    constants — use these when you want the branch tree-shaken.
  - Platform: `kDartIsWeb` (`dart.library.js_interop`),
    `isRunningAsJavascript` (`identical(1, 1.0)`, true only for dart2js),
    `kDartIsWebJs` (web and js) and `kDartIsWebWasm` (web but not js).
    There is no `isIo` here: "not web" is `!kDartIsWeb`.
* `foundation/constants.dart` mirrors Flutter's foundation constants without
  depending on Flutter: `kFlutterReleaseMode`, `kFlutterProfileMode`,
  `kFlutterDebugMode`, `kFlutterIsWeb`, `kFlutterPrecisionErrorTolerance`.
  The unprefixed Flutter names (`kReleaseMode`, `kDebugMode`, `kIsWeb`,
  `precisionErrorTolerance`) still exist but are deprecated aliases — in a
  real Flutter app import `package:flutter/foundation.dart` instead.
  `debugEnvMap` (from `dev_utils.dart`) dumps all of these at once, which is
  what to print in a bug report.
* Dev helpers in `dev_utils.dart` are **deliberately deprecated** so that
  temporary debug code shows up in `dart analyze`: `devPrint`, `devError`,
  `devWarning(value)` (passes its value through), `devDebugOnly(() => ...)`,
  `devPrintEnabled`. Their non-deprecated twins for code you intend to keep
  are `debugDevPrint`, `debugDevError` and `debugDevPrintEnabled`.
  `DevFlag('why')` is an off-by-default toggle whose setter is deprecated;
  `devTrue` / `devFalse` are `@doNotSubmit` constants for temporary gates.
* Logging, from `log_utils.dart` (it re-exports **all** of
  `package:logging`, so `Logger`, `Level` and `LogRecord` come with it):
  `setupQuickLogging(Level.INFO)` installs a root print handler once and sets
  the root level; `parseLogLevel('fine', Level.INFO)` turns a command-line
  string into a `Level` (case-insensitive, `logLevels` is the list);
  `compatLogger` is a shared `Logger('Quick')`; `formatTimestampMs(ms)` and
  `format0To1AsPercent(0.42)` format for human-readable output.
  `debugQuickLogging` is the deprecated dev-only variant.
* `log_format.dart` keeps log lines short: `logFormat(value, options: ...)`
  returns a truncated string and `logFormatConvert` a truncated object graph
  (strings, map/list lengths and nesting depth all capped). Defaults via
  `LogFormatOptions.defaultOptions()`: 100 chars per basic value, 320 for the
  final string, 5 map entries, 5 list entries, depth 3 — pass a
  `const LogFormatOptions(...)` to override. Use it before dumping a decoded
  JSON payload or a `CvModel`.
* `OutBuffer(maxLineCount)` (`out_buffer.dart`) keeps only the last N lines
  (`add`, `lines`, `toString`) — for a "last output" panel or an error tail.
* Versions, from `version_utils.dart` (re-exports `package:pub_semver`, so
  `Version` and `VersionConstraint` come with it): `parseVersion` also
  accepts `1.2` and `1.2.3.4` (the 4th number becomes the build),
  `parseVersionOrNull(text)` returns null on failure (`strict: true`
  rethrows), and `TekartikVersionExt` adds `bump({major, minor, patch, ext})`
  (defaults to patch, or to the pre-release/build part when there is one),
  `nextPreReleaseOrBuild` and `noPreReleaseOrBuild`.
* Tags, from `tags.dart`: `Tags.fromText('a,b')` / `Tags.fromList([...])` /
  `Tags()`, then `has`, `add`, `remove` (they return whether something
  changed), `sort`, `toList`/`toListOrNull`, `toText`/`toTextOrNull`.
  `TagsCondition('a && (b || !c)')` parses a boolean expression and
  `check(tags)` evaluates it; an empty expression is always true and mixing
  `&&` with `||` without parentheses throws. `package:test` also exports a
  `Tags` class: in tests write `import 'package:test/test.dart' hide Tags;`.
* Anti-patterns: using `isDebug` where a compile-time constant is needed
  (it is a runtime getter, no tree shaking); committing `devPrint` /
  `devWarning` / `DevFlag.on = true` (the analyzer warning is the point);
  calling `setupQuickLogging` in a library instead of in `main`; assuming
  `isRunningAsJavascript` is true on web (it is false under wasm).
* Testing: `dart test -p vm,chrome,node` — the env tests in this repo assert
  a different combination of the flags per platform, which is the reference
  for what each constant means where.

## Examples

### Detect build mode and runtime platform

```dart
import 'package:tekartik_common_utils/dev_utils.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart';

String describeRuntime() {
  if (kDartIsWebWasm) {
    return 'web (wasm)';
  } else if (kDartIsWebJs) {
    return 'web (js)';
  }
  return 'native';
}

void main() {
  print('${describeRuntime()} debug: $isDebug release: $isRelease');

  // Compile-time constant: the branch is tree-shaken in release.
  if (kFlutterDebugMode) {
    print(debugEnvMap); // isDebug, kDartIsWeb, kFlutter*, ...
  }
  if (!kDartIsWeb) {
    print('safe place to reach for a dart:io-only package');
  }
}
```

### Quick logging setup and compact log lines

```dart
import 'package:tekartik_common_utils/log_format.dart';
import 'package:tekartik_common_utils/log_utils.dart';

final _log = Logger('myapp');

void main(List<String> args) {
  // --verbose style flag: `dart run bin/main.dart fine`
  var level = parseLogLevel(args.isEmpty ? 'info' : args.first, Level.INFO);
  setupQuickLogging(level);

  _log.info('starting');

  var payload = <String, Object?>{
    'name': 'a very long value that would flood the console',
    'items': [1, 2, 3, 4, 5, 6, 7, 8],
    'nested': {
      'a': {
        'b': {'c': 1},
      },
    },
  };
  _log.fine(logFormat(payload));
  _log.fine(
    logFormat(
      payload,
      options: const LogFormatOptions(depth: 1, listTruncateLength: 3),
    ),
  );

  print(formatTimestampMs(1234)); // 01.234
  print(format0To1AsPercent(0.42));
}
```

### Debug flags that the analyzer keeps honest

```dart
import 'package:tekartik_common_utils/dev_utils.dart';
import 'package:tekartik_common_utils/out_buffer.dart';

/// Off by default; turning it on raises an analyzer warning on purpose.
final debugSync = DevFlag('sync engine');

final syncOutput = OutBuffer(50);

void syncStep(int index) {
  syncOutput.add('step $index');
  if (debugSync.on) {
    debugDevPrint('sync $index');
  }
}

void main() {
  // ignore: deprecated_member_use
  debugSync.on = true;
  syncStep(1);
  syncStep(2);
  print(syncOutput); // last 50 lines, joined
  print(syncOutput.lines.length);
}
```

### Lenient version parsing and bumping

```dart
import 'package:tekartik_common_utils/version_utils.dart';

void main() {
  print(parseVersion('1.2')); // 1.2.0
  print(parseVersion('1.2.3.4')); // 1.2.3+4
  print(parseVersionOrNull('not a version')); // null

  var version = Version.parse('1.2.3');
  print(version.bump()); // 1.2.4 (patch by default)
  print(version.bump(minor: true)); // 1.3.0
  print(Version.parse('1.2.3-1').nextPreReleaseOrBuild); // 1.2.3-2
  print(Version.parse('1.2.3-1').noPreReleaseOrBuild); // 1.2.3

  // pub_semver is re-exported, no extra dependency needed.
  print(VersionConstraint.parse('^1.0.0').allows(version));
}
```

### Tag sets and tag expressions

```dart
import 'package:tekartik_common_utils/tags.dart';

bool shouldRun(String expression, String tagsText) =>
    TagsCondition(expression).check(Tags.fromText(tagsText));

void main() {
  var tags = Tags.fromText('dev, linux');
  print(tags.toList()); // [dev, linux]
  print(tags.has('dev'));
  print(tags.add('verbose')); // true, it changed
  tags.sort();
  print(tags.toText()); // dev,linux,verbose

  print(shouldRun('dev && (linux || macos)', 'dev,linux')); // true
  print(shouldRun('!dev', 'dev,linux')); // false
  print(shouldRun('', 'anything')); // true: empty is always true
}
```

## Common mistakes

* Branching on `isDebug` (runtime) when a tree-shaken
  `kDartIoReleaseMode` / `kFlutterDebugMode` constant is what is wanted.
* Reading `isRunningAsJavascript` as "is web": it is false on wasm, use
  `kDartIsWeb`.
* Leaving `devPrint`, `devWarning` or `DevFlag.on = true` in committed code
  — the deprecation warning exists to catch that.
* Adding `package:logging` or `package:pub_semver` to `pubspec.yaml` just to
  get `Logger`/`Version`: `log_utils.dart` and `version_utils.dart`
  re-export them.
* Importing `package:test/test.dart` without `hide Tags` next to
  `tags.dart`.
