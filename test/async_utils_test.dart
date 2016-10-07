// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

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
    });
  });
}
