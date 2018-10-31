import 'package:tekartik_common_utils/stream/stream_poller.dart';
import 'package:test/test.dart';
import 'dart:async';

void main() {
  group('StreamPoller', () {
    test('empty', () async {
      var stream = Stream<bool>.fromIterable([]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).done, isTrue);
      expect((await poller.getNext()).event, isNull);
      expect((await poller.getNext()).done, isTrue);
    });
    test('one', () async {
      var stream = Stream<bool>.fromIterable([true]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).event, isTrue);
      expect((await poller.getNext()).done, isTrue);
    });
    test('two', () async {
      var stream = Stream<bool>.fromIterable([true, false]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).event, isTrue);
      expect((await poller.getNext()).event, isFalse);
      expect((await poller.getNext()).done, isTrue);
    });

    test('two_race_condition', () async {
      var stream = Stream<bool>.fromIterable([true, false]);
      var poller = StreamPoller<bool>(stream);
      var list = await Future.wait(
          [poller.getNext(), poller.getNext(), poller.getNext()]);
      expect(list[0].event, isTrue);
      expect(list[1].event, isFalse);
      expect(list[2].event, isNull);
    });
  });
}
