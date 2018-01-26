// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:tekartik_common_utils/date_time_utils.dart';
import 'package:test/test.dart';

void main() {
  group('date_time_utils', () {
    test('withOffset', () {
      DateTime dateTime = new DateTime.utc(2018, 1, 25, 1);
      DateTime dateTime2 = new DateTime.utc(2018, 1, 25, 2);
      expect(dateTimeWithOffset(dateTime, hourInMillis), dateTime2);
    });

    test('dateTimeWithTimeCleared', () {
      DateTime dateTime = new DateTime.utc(2018, 1, 25, 1, 2, 3, 4, 5);
      DateTime dateTime2 = new DateTime.utc(2018, 1, 25);
      expect(dateTimeWithTimeCleared(dateTime), dateTime2);
    });
  });
}
