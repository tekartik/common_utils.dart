import 'dart:async';

import 'package:tekartik_common_utils/stream/stream_poller.dart';
import 'package:test/test.dart';

void main() {
  group('StreamPoller', () {
    test('api', () {
      expect(StreamPollerEvent, isNotNull);
      expect(StreamPoller, isNotNull);
    });
    test('empty', () async {
      var stream = Stream<bool>.fromIterable([]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).done, isTrue);
      expect((await poller.getNext()).data, isNull);
      expect((await poller.getNext()).done, isTrue);
    });
    test('one', () async {
      var stream = Stream<bool>.fromIterable([true]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).data, isTrue);
      expect((await poller.getNext()).done, isTrue);
    });
    test('two', () async {
      var stream = Stream<bool>.fromIterable([true, false]);
      var poller = StreamPoller<bool>(stream);
      expect((await poller.getNext()).data, isTrue);
      expect((await poller.getNext()).data, isFalse);
      expect((await poller.getNext()).done, isTrue);
    });

    test('two_race_condition', () async {
      var stream = Stream<bool>.fromIterable([true, false]);
      var poller = StreamPoller<bool>(stream);
      var list = await Future.wait(
          [poller.getNext(), poller.getNext(), poller.getNext()]);
      expect(list[0].data, isTrue);
      expect(list[1].data, isFalse);
      expect(list[2].data, isNull);
    });

    test('cancel', () async {
      var ctlr = StreamController<bool>();
      var poller = StreamPoller<bool>(ctlr.stream);
      try {
        await poller.getNext().timeout(Duration());
        fail('should fail');
      } on TimeoutException catch (_) {}
      var future = poller.cancel();
      expect((await poller.getNext()).done, isTrue);
      await ctlr.close();
      await future;
    });
  });
}
