---
name: tekartik-common-utils-async
description: >-
  Use when writing async, stream or caching code with tekartik_common_utils:
  Subject and StreamWithValue (BehaviorSubject-like value stream),
  streamJoinAll / streamJoin2 / streamJoin2OrError / StreamJoinItem,
  StreamPoller and Fifo, AsyncOnceRunner, sleep, safeComplete /
  safeCompleteError / safeAdd / safeAddError, sleepAtLeast, unawait,
  LazyRunner and LazyRunner.periodic for debounced background work,
  Operation for coalesced runs with a cooldown, Cooperator / cooperator to
  yield during long loops, and LruMap / ExpiringLruMap caches.
---

# Async, streams and concurrency primitives (tekartik_common_utils)

`tekartik_common_utils` ships the small async building blocks shared by the
tekartik packages: a value-carrying broadcast controller, stream combiners, a
pull adapter, debounced runners and LRU caches — all pure Dart, usable on vm,
web and Flutter. For parsing and collections see
`tekartik-common-utils-values`; for build-mode flags and logging see
`tekartik-common-utils-env-logging`.

## Guidelines

* Dependency (git, not on pub.dev — single-package repo, no `path:`):
  ```yaml
  dependencies:
    tekartik_common_utils:
      git:
        url: https://github.com/tekartik/common_utils.dart
      version: '^1.0.0'
  ```
* Entry points: `async_utils.dart` (re-exports `dart:async`),
  `future_utils.dart`, `stream_utils.dart` (alias of `stream/subject.dart`),
  `stream/subject.dart`, `stream/stream_join.dart` (re-exports
  `stream/stream_join_gen.dart`), `stream/stream_poller.dart`,
  `queue/fifo.dart`, `lazy_runner/lazy_runner.dart`,
  `operation/operation.dart`, `cooperator/cooperator.dart`,
  `map/lru_map.dart`, `map/expiring_lru_map.dart`.
* `Subject<T>` is a broadcast `StreamController<T>` that remembers its last
  value: it *is* a `Stream<T>` (`subject.stream` returns `this`), implements
  `StreamSink<T>`, `StreamController<T>` and `StreamWithValue<T>`, and every
  new listener immediately gets the current `value` (or the stored error)
  before later events. `Subject(value: x)` seeds only when `x` is non-null;
  `Subject.seeded(value: null)` seeds with null on purpose. Adding a value
  clears a stored error and vice versa. `onPause`/`onResume` throw
  `UnsupportedError` (it is broadcast) — everything else of the controller
  API works, including `close()`, `done`, `isClosed`, `hasListener` and
  `addStream`. Expose it to consumers as `StreamWithValue<T>` so they cannot
  `add` to it.
* Combining streams: `streamJoinAll(streams)` emits a `List<T>` of the latest
  values, first only once *every* source produced a value, then on each
  event; it closes when all sources are done and forwards errors.
  `streamJoin2`/`streamJoin3`/`streamJoin4` are the record-typed versions
  (`Stream<(T1, T2)>`). When a source may fail without killing the join, use
  `streamJoinAllOrError` / `streamJoin2OrError` …: each slot becomes a
  `StreamJoinItem<T>` with `value` or `error`, and the tuple extensions
  (`StreamJoinItemList2Ext`) give `item1`, `item2` and `values`.
* `StreamPoller<T>(stream, lastOnly: ...)` turns a push stream into
  `await poller.getNext()`, returning a `StreamPollerEvent<T?>` with `data`
  and `done`. It subscribes immediately and buffers in a `Fifo`;
  `lastOnly: true` keeps only the most recent event. Always `await
  poller.cancel()` — stream completion cancels it too. This is the tool for
  writing "expect the next 3 events" tests without `expectAsync`.
* `AsyncOnceRunner(computation)` runs `computation` at most once; concurrent
  `run()` calls all await the same execution (guarded by
  `package:synchronized`) and `done` flips to true only after success, so a
  failure is retried on the next `run()`.
* Safety extensions from `async_utils.dart`: `completer.safeComplete(value)`
  / `safeCompleteError(e)` no-op when already completed;
  `controller.safeAdd(event)` / `safeAddError(e)` no-op when closed — use
  them in `onDispose`-prone code instead of `if (!x.isCompleted)` guards.
  `sleep(300)` is a milliseconds `Future.delayed`; `stopwatch.sleepAtLeast(ms)`
  waits only the remaining time (the stopwatch must be running).
  `future.unawait()` (`future_utils.dart`) documents a deliberately
  non-awaited future. `waitAll` is legacy, use `Future.wait`.
* Debounced work: `LazyRunner(action: (count) async {...})` runs `action` in
  a background loop; `trigger()` requests a run and further triggers arriving
  during a run coalesce into exactly one extra run. `LazyRunner.periodic(
  duration: ..., action: ...)` also fires on its own every `duration` (first
  run after `duration`; `trigger()` to run now). Errors are swallowed — set
  `debugLazyRunner = true` to print them. Always `dispose()`.
  `Operation(action: ..., delay: ...)` is the simpler sibling: `trigger()`
  while a run is pending is ignored, and `delay` enforces a minimum gap
  between runs.
* `cooperator.cooperate()` (global `Cooperator`) returns a 100µs future when
  more than 4ms elapsed since the last yield, `null` otherwise: `await` it
  inside long synchronous loops to keep a UI or an isolate responsive. Check
  `cooperator.needCooperate` first if building the future matters.
* Caches: `LruMap<K, V>(maximumSize: n, dispose: (entry) {...})` is a
  `Map` where reads and writes promote the key; overflow evicts the least
  recently used entry and calls `dispose`. `LruMap.expiring(duration: ...)`
  (or `ExpiringLruMap` directly) also drops entries after a TTL measured on a
  monotonic `Stopwatch`; `purge()` forces the sweep, and `keys` purges first.
* Anti-patterns: calling `subject.onPause = ...`; treating `streamJoinAll` as
  emitting before every source has a value; polling a `StreamPoller` after
  `cancel()` and expecting data (you get `done: true`); leaking a
  `LazyRunner` without `dispose()`; using `ExpiringLruMap` for timing-exact
  expiry (the sweep only happens on access or `purge()`).
* Testing: `dart test -p vm,chrome,node`. Prefer `StreamPoller` or
  `stream.take(n).toList()` over sleeps; when a sleep is unavoidable use
  `sleep(ms)` from `async_utils.dart` (not `dart:io`'s blocking `sleep`).

## Examples

### A value stream for state (Subject / StreamWithValue)

```dart
import 'package:tekartik_common_utils/stream/subject.dart';

class CounterService {
  final _subject = Subject<int>(value: 0);

  /// Read-only view: listeners get the current value right away.
  StreamWithValue<int> get counter => _subject;

  int get value => _subject.value!;

  void increment() => _subject.add(value + 1);

  Future<void> close() => _subject.close();
}

Future<void> main() async {
  var service = CounterService();
  var sub = service.counter.listen((value) => print('counter $value'));
  service.increment();
  service.increment();
  await service.close();
  await sub.cancel();
}
```

### Combining streams, with and without error slots

```dart
import 'package:tekartik_common_utils/stream/stream_join.dart';

Future<void> main() async {
  var names = Stream.fromIterable(['a', 'b']);
  var counts = Stream.fromIterable([1, 2]);

  // Record typed: emits once both have a value, then on every event.
  await for (var (name, count) in streamJoin2(names, counts)) {
    print('$name $count');
  }

  // Keep going when one stream fails.
  var flaky = Stream<int>.error(StateError('nope'));
  var joined = streamJoin2OrError(Stream.value('ok'), flaky);
  await for (var items in joined) {
    print('${items.item1.value} ${items.item2.error} ${items.values}');
  }

  // Dynamic number of streams.
  await for (var list in streamJoinAll([Stream.value(1), Stream.value(2)])) {
    print(list); // [1, 2]
  }
}
```

### Pull events from a stream (StreamPoller)

```dart
import 'dart:async';

import 'package:tekartik_common_utils/stream/stream_poller.dart';

Future<void> main() async {
  var controller = StreamController<int>();
  var poller = StreamPoller(controller.stream);
  try {
    controller.add(1);
    controller.add(2);
    var first = await poller.getNext();
    print('${first.data} done: ${first.done}'); // 1 done: false
    print((await poller.getNext()).data); // 2
    await controller.close();
    print((await poller.getNext()).done); // true
  } finally {
    await poller.cancel();
  }
}
```

### Debounced save with LazyRunner, one-shot init with AsyncOnceRunner

```dart
import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';

class Store {
  late final _init = AsyncOnceRunner(() async {
    await sleep(10); // open the database once, whoever calls first
    print('initialized');
  });

  late final LazyRunner _saver = LazyRunner(
    action: (count) async {
      await _init.run();
      print('save #$count');
    },
  );

  Future<void> ready() => _init.run();

  /// Many calls in a row result in a single extra save.
  void saveLater() => _saver.trigger();

  void dispose() => _saver.dispose();
}

Future<void> main() async {
  var store = Store();
  await store.ready();
  store
    ..saveLater()
    ..saveLater();
  await sleep(50);
  store.dispose();
}
```

### LRU cache, cooldown operation and cooperative loop

```dart
import 'package:tekartik_common_utils/cooperator/cooperator.dart';
import 'package:tekartik_common_utils/map/lru_map.dart';
import 'package:tekartik_common_utils/operation/operation.dart';

Future<void> main() async {
  var cache = LruMap<String, List<int>>(
    maximumSize: 2,
    dispose: (entry) => print('evicted ${entry.key}'),
  );
  cache['a'] = [1];
  cache['b'] = [2];
  cache['a']; // promotes 'a'
  cache['c'] = [3]; // evicts 'b'
  print(cache.keys);

  // Same map, entries also expiring after 5 minutes.
  var expiring = LruMap<String, int>.expiring(
    duration: const Duration(minutes: 5),
    maximumSize: 100,
  );
  expiring['token'] = 1;

  // At most one refresh at a time, never more often than every 2 seconds.
  var refresh = Operation(
    action: () async => print('refresh'),
    delay: const Duration(seconds: 2),
  );
  refresh
    ..trigger()
    ..trigger(); // ignored, one is already pending

  for (var i = 0; i < 100000; i++) {
    if (cooperator.needCooperate) {
      await cooperator.cooperate();
    }
  }
}
```

## Common mistakes

* Using `Subject` as a single-subscription controller: it is broadcast, so
  `onPause`/`onResume` throw and events added with no listener are only kept
  as the current `value`.
* Expecting `streamJoinAll` / `streamJoin2` to emit before every input stream
  has produced at least one value.
* Forgetting `dispose()` on a `LazyRunner` (especially `.periodic`) or
  `cancel()` on a `StreamPoller`.
* Assuming `Operation.trigger()` queues: extra triggers while one run is
  pending are dropped, not queued.
* Relying on `ExpiringLruMap` to fire `dispose` exactly at the TTL; it sweeps
  on access or on `purge()`.
