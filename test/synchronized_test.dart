// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:tekartik_common_utils/synchronized.dart';
import 'package:dev_test/test.dart';

void main() {
  group('synchronized', () {
    test('order', () async {
      Lock lock = new Lock();
      List<int> list = [];
      Future future1 = lock.synchronized(() async {
        list.add(1);
      });
      Future<String> future2 = lock.synchronized(() async {
        await new Duration(milliseconds: 10);
        list.add(2);
        return "text";
      });
      Future<int> future3 = lock.synchronized(() {
        list.add(3);
        return 1234;
      });
      expect(list, isEmpty);
      await Future.wait([future1, future2, future3]);
      expect(await future1, isNull);
      expect(await future2, "text");
      expect(await future3, 1234);
      expect(list, [1, 2, 3]);
    });

    test('nested', () async {
      Lock lock = new Lock();
      List<int> list = [];
      Future future1 = lock.synchronized(() async {
        list.add(1);
        await lock.synchronized(() async {
          await new Duration(milliseconds: 10);
          list.add(2);
        });
        list.add(3);
      });
      Future future2 = lock.synchronized(() {
        list.add(4);
      });
      await Future.wait([future1, future2]);
      expect(list, [1, 2, 3, 4]);
    });

    test('perf', () async {
      int count = 100;
      Lock lock = new Lock();
      List<Future> futures = [];
      List<int> list = [];
      for (int i = 0; i < count; i++) {
        Future future = lock.synchronized(() async {
          list.add(i);
        });
        futures.add(future);
      }
      await Future.wait(futures);
    });
  });
}
