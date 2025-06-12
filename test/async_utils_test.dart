// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/future_utils.dart';

import 'package:test/test.dart';

void main() {
  group('async', () {
    test('sleep', () async {
      final sw = Stopwatch();
      sw.start();
      await sleep(50);
      expect(sw.elapsedMilliseconds, greaterThan(30));
      expect(sw.elapsedMilliseconds, lessThan(3000));
      await sleep();
    });
    test('sleepAtLeast', () async {
      final sw = Stopwatch();
      await expectLater(
        () => sw.sleepAtLeast(100),
        throwsA(isA<AssertionError>()),
      );
      sw.start();
      await sw.sleepAtLeast(50);
      expect(sw.elapsedMilliseconds, greaterThan(30));
      expect(sw.elapsedMilliseconds, lessThan(3000));
    });

    test('waitAll', () async {
      expect(await waitAll(null), isNull);
      expect(await waitAll([]), isNull);
      expect(await waitAll([() async {}]), [null]);
      expect(
        await waitAll([
          () async {
            return 0;
          },
        ]),
        [0],
      );
      expect(
        await waitAll([
          () async {},
          () async {
            await sleep(1);
          },
        ]),
        [null, null],
      );
      expect(
        await waitAll([
          () async {
            return 0;
          },
          () async {
            await sleep(1);
            return 1;
          },
        ]),
        [0, 1],
      );
      expect(
        await waitAll([
          () async {
            return 0;
          },
          () async {
            await sleep(1);
          },
        ]),
        [0, null],
      );
      expect(
        waitAll([
          () async {
            throw 'fail';
          },
        ]),
        throwsA('fail'),
      );
      expect(
        waitAll([
          () async {
            return 0;
          },
          () async {
            throw 'fail';
          },
        ]),
        throwsA('fail'),
      );

      Future<int> f1() async {
        return 1;
      }

      Future<String> ft() async {
        return '1';
      }

      expect(await waitAll([f1, ft]), [1, '1']);
    });

    test('onceRunner', () async {
      var count = 0;
      Future doCount() async {
        await sleep(5);
        count++;
      }

      var runner = AsyncOnceRunner(doCount);
      expect(count, 0);
      var future = runner.run();
      expect(runner.done, isFalse);
      await runner.run();
      expect(count, 1);
      expect(runner.done, isTrue);
      await future;
    });

    test('onceRunner fail', () async {
      var shouldFail = true;
      Future doCount() async {
        await sleep(5);
        if (shouldFail) {
          throw 'should fail';
        }
      }

      var runner = AsyncOnceRunner(doCount);
      try {
        await runner.run();
        fail('should have failed');
      } catch (e) {
        expect(e, 'should fail');
      }
      expect(runner.done, isFalse);

      try {
        await runner.run();
        fail('should have failed');
      } catch (e) {
        expect(e, 'should fail');
      }

      shouldFail = false;
      await runner.run();
      expect(runner.done, isTrue);
      await runner.run();
    });
    test('safe completer', () async {
      var completer = Completer<bool>();
      completer.safeComplete(true);
      expect(completer.isCompleted, isTrue);
      completer.safeComplete(false);
      completer.safeCompleteError(false);
      expect(completer.isCompleted, isTrue);

      try {
        completer.complete(false);
        fail('should have failed');
      } catch (e) {
        // } on StateError catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }

      expect(await completer.future, isTrue);

      try {
        completer.completeError('error');
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }

      completer = Completer<bool>();
      completer.future.catchError((Object e) {
        // print('catch $e');
        return false;
      }).unawait();

      completer.safeCompleteError('error');

      expect(completer.isCompleted, isTrue);
      completer.safeComplete(false);
      completer.safeCompleteError('safe_error');
      expect(completer.isCompleted, isTrue);

      try {
        completer.complete(false);
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }

      try {
        completer.completeError('error');
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }

      await expectLater(completer.future, throwsA('error'));
    });
    test('safe controller', () async {
      var controller = StreamController<bool>();
      var futureList = controller.stream.toList();
      controller.safeAdd(true);
      controller.close().unawait();
      controller.safeAdd(false);
      controller.safeAddError('safe_error');
      try {
        controller.add(false);
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }
      try {
        controller.addError('safe_error');
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }
      expect(await futureList, [true]);

      controller = StreamController<bool>();
      futureList = controller.stream.toList();
      controller.safeAddError('error');
      controller.close().unawait();
      controller.safeAdd(false);
      controller.safeAddError('safe_error');
      try {
        controller.add(false);
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }
      try {
        controller.addError('safe_error');
        fail('should have failed');
      } catch (e) {
        expect(e, isNot(isA<TestFailure>()));
      }
      await expectLater(futureList, throwsA('error'));
    });
  });
}
