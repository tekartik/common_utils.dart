// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/async_utils.dart';

void main() {
  group('async', () {
    test('sleep', () async {
      Stopwatch sw = new Stopwatch();
      sw.start();
      await sleep(50);
      expect(sw.elapsedMilliseconds, greaterThan(30));
      expect(sw.elapsedMilliseconds, lessThan(300));
      await sleep();
    });

    test('waitAll', () async {
      expect(await waitAll(null), isNull);
      expect(await waitAll([]), isNull);
      expect(await waitAll([() async {

      }]), [null]);
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
              sleep(1);
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
              sleep(1);
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
      expect(await
          waitAll([f1, ft]), [1, "1"]);
    });
  });
}
