// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/async_utils.dart';

void main() {
  group('async', () {
    test('sleep', () async {
      Stopwatch sw = Stopwatch();
      sw.start();
      await sleep(50);
      expect(sw.elapsedMilliseconds, greaterThan(30));
      expect(sw.elapsedMilliseconds, lessThan(3000));
      await sleep();
    });

    test('waitAll', () async {
      expect(await waitAll(null), isNull);
      expect(await waitAll([]), isNull);
      expect(await waitAll([() async {}]), [null]);
      expect(
          await waitAll([
            () async {
              return 0;
            }
          ]),
          [0]);
      expect(
          await waitAll([
            () async {},
            () async {
              await sleep(1);
            }
          ]),
          [null, null]);
      expect(
          await waitAll([
            () async {
              return 0;
            },
            () async {
              await sleep(1);
              return 1;
            }
          ]),
          [0, 1]);
      expect(
          await waitAll([
            () async {
              return 0;
            },
            () async {
              await sleep(1);
            }
          ]),
          [0, null]);
      expect(
          waitAll([
            () async {
              throw 'fail';
            }
          ]),
          throwsA('fail'));
      expect(
          waitAll([
            () async {
              return 0;
            },
            () async {
              throw 'fail';
            }
          ]),
          throwsA('fail'));

      Future<int> f1() async {
        return 1;
      }

      Future<String> ft() async {
        return "1";
      }

      expect(await waitAll([f1, ft]), [1, "1"]);
    });

    test('onceRunner', () async {
      int count = 0;
      Future _count() async {
        await sleep(5);
        count++;
      }

      AsyncOnceRunner runner = AsyncOnceRunner(_count);
      expect(count, 0);
      Future future = runner.run();
      expect(runner.done, isFalse);
      await runner.run();
      expect(count, 1);
      expect(runner.done, isTrue);
      await future;
    });

    test('onceRunner fail', () async {
      bool shouldFail = true;
      Future _count() async {
        await sleep(5);
        if (shouldFail) {
          throw "should fail";
        }
      }

      AsyncOnceRunner runner = AsyncOnceRunner(_count);
      try {
        await runner.run();
        fail('should have failed');
      } catch (e) {
        expect(e, "should fail");
      }
      expect(runner.done, isFalse);

      try {
        await runner.run();
        fail('should have failed');
      } catch (e) {
        expect(e, "should fail");
      }

      shouldFail = false;
      await runner.run();
      expect(runner.done, isTrue);
      await runner.run();
    });
  });
}
