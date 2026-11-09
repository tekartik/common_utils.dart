// Regression tests of the 2026-11-09 review (level 2, batch D).
import 'dart:async';
import 'dart:convert';

import 'package:tekartik_common_utils/ini_file_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';
import 'package:tekartik_common_utils/log_format.dart';
import 'package:tekartik_common_utils/pack/pack.dart';
import 'package:tekartik_common_utils/stream/stream_join.dart';
import 'package:tekartik_common_utils/string_utils.dart';
import 'package:tekartik_common_utils/tags.dart';
import 'package:tekartik_common_utils/uri_utils.dart';
import 'package:tekartik_common_utils/version_utils.dart';
import 'package:test/test.dart' hide Tags;

void main() {
  group('review_regression', () {
    test('stringsCompareWithLastInt uses the int part of each value', () {
      expect(stringsCompareWithLastInt('file10', 'file'), greaterThan(0));
      expect(stringsCompareWithLastInt('file', 'file10'), lessThan(0));
      expect(stringsCompareWithLastInt('abc1', 'ab'), greaterThan(0));
      expect(['file10', 'file2', 'file']..sort(stringsCompareWithLastInt), [
        'file',
        'file2',
        'file10',
      ]);
    });

    test('parseVersion X.X needs a dot and a minor', () {
      expect(parseVersionOrNull('12'), isNull);
      expect(parseVersionOrNull('1.'), isNull);
      expect(() => parseVersion('12'), throwsFormatException);
      expect(() => parseVersion('1a2'), throwsFormatException);
      expect(parseVersion('1.2'), Version(1, 2, 0));
      expect(parseVersion('1.2.3.4'), Version(1, 2, 3, build: '4'));
    });

    test('parseIniLines value containing =', () {
      expect(parseIniLines(['token=abc==', 'url=https://x?a=b']), {
        'token': 'abc==',
        'url': 'https://x?a=b',
      });
    });

    test('removeParametersAndFragment without authority', () {
      String clean(String text) =>
          Uri.parse(text).removeParametersAndFragment().toString();
      expect(clean('/a/b?x=1#f'), '/a/b');
      expect(clean('a/b?x=1'), 'a/b');
      expect(clean('mailto:a@b.c?subject=1'), 'mailto:a@b.c');
      expect(clean('file:///a/b?x'), 'file:///a/b');
      expect(clean('https://a.com/b?x=1#f'), 'https://a.com/b');
      expect(clean('https://u@a.com:8080/b?x=1#f'), 'https://u@a.com:8080/b');
    });

    test('compack round trip of a map looking like a pack', () {
      var map = {r'$c': 1, r'$r': 2, r'$vx': 3, r'$v': 4};
      expect(uncompackAny(compackAny(map)), map);
    });

    test('JsonUnpack after a json round trip', () {
      var packed =
          jsonDecode(
                jsonEncode(
                  packList([
                    {'a': 1},
                    {'a': 2},
                  ]),
                ),
              )
              as Map;
      var items = <Map>[];
      JsonUnpack(packed).forEach(items.add);
      expect(items, [
        {'a': 1},
        {'a': 2},
      ]);
    });

    test('logFormatConvert applies the truncate options', () {
      var map = {for (var i = 0; i < 10; i++) 'k$i': i};
      expect(
        (logFormatConvert(
                  map,
                  options: const LogFormatOptions(mapTruncateLength: 5),
                )
                as Map)
            .length,
        5,
      );
      var list = [for (var i = 0; i < 10; i++) i];
      expect(
        logFormatConvert(
          list,
          options: const LogFormatOptions(listTruncateLength: 5),
        ),
        [0, 1, 2, 3, 4],
      );
      expect(
        logFormatConvert({
          'k': 'x' * 30,
        }, options: const LogFormatOptions(basicTypeTruncateLength: 5)),
        {'k': 'xxxxx'},
      );
    });

    test('streamJoin2OrError non nullable types with an error', () async {
      var c1 = StreamController<int>();
      var c2 = StreamController<int>();
      var items = <(StreamJoinItem<int>, StreamJoinItem<int>)>[];
      var errors = <Object>[];
      var subscription = streamJoin2OrError<int, int>(
        c1.stream,
        c2.stream,
      ).listen(items.add, onError: errors.add);
      c1.add(1);
      c2.addError('boom');
      await Future<void>.delayed(Duration.zero);
      expect(errors, isEmpty);
      expect(items.length, 1);
      expect(items.first.item1.value, 1);
      expect(items.first.item2.error, 'boom');
      await subscription.cancel();
    });

    test('streamJoinAll forwards a source error', () async {
      var uncaught = <Object>[];
      var errors = <Object>[];
      await runZonedGuarded(() async {
        var subscription = streamJoinAll<int>([
          Stream<int>.error('boom'),
          Stream.value(1),
        ]).listen((_) {}, onError: errors.add);
        await Future<void>.delayed(const Duration(milliseconds: 50));
        await subscription.cancel();
      }, (error, _) => uncaught.add(error));
      expect(uncaught, isEmpty);
      expect(errors, ['boom']);
    });

    test(
      'LazyRunner.periodic leaves no waiter behind at each period',
      () async {
        var logs = <String>[];
        var previousDebug = debugLazyRunner;
        try {
          await runZoned(
            () async {
              debugLazyRunner = true;
              var runner = LazyRunner.periodic(
                duration: const Duration(milliseconds: 2),
                action: (_) async {},
              );
              await Future<void>.delayed(const Duration(milliseconds: 100));
              logs.clear();
              runner.trigger();
              await Future<void>.delayed(Duration.zero);
              runner.dispose();
            },
            zoneSpecification: ZoneSpecification(
              print: (self, parent, zone, line) => logs.add(line),
            ),
          );
        } finally {
          debugLazyRunner = previousDebug;
        }
        // One waiter wakes up, it used to be one per elapsed period.
        expect(
          logs.where((line) => line.endsWith('triggered')).length,
          lessThan(3),
        );
      },
    );

    test('Tags.fromText ignores empty tags', () {
      expect(Tags.fromText('').toList(), isEmpty);
      expect(Tags.fromText('  ').toListOrNull(), isNull);
      expect(Tags.fromText('a,,b, ').toList(), ['a', 'b']);
    });
  });
}
