// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:tekartik_common_utils/date_time_utils.dart';
import 'package:test/test.dart';

void main() {
  group('date_time_utils', () {
    test('withOffset', () {
      var dateTime = DateTime.utc(2018, 1, 25, 1);
      var dateTime2 = DateTime.utc(2018, 1, 25, 2);
      expect(dateTimeWithOffset(dateTime, hourInMillis), dateTime2);
    });

    test('dateTimeWithTimeCleared', () {
      var dateTime = DateTime.utc(2018, 1, 25, 1, 2, 3, 4, 5);
      var dateTime2 = DateTime.utc(2018, 1, 25);
      expect(dateTimeWithTimeCleared(dateTime), dateTime2);
    });

    test('anyToDateTime', () {
      expect(anyToDateTime(false), isNull);
      expect(anyToDateTime('a'), isNull);
      expect(anyToDateTime(null), isNull);
      expect(
        anyToDateTime(12345678901234),
        DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
      );
      expect(
        anyToDateTime('2361-03-21T19:15:01.234Z'),
        DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
      );
    });

    test('dateTimeFromInt', () {
      expect(null, dateTimeFromInt(null));
      expect(
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        dateTimeFromInt(0),
      );
      expect(
        DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
        dateTimeFromInt(12345678901234),
      );
    });

    test('dateTimeToInt', () {
      expect(null, dateTimeToInt(null));
      expect(0, dateTimeToInt(DateTime.fromMillisecondsSinceEpoch(0)));
      expect(
        0,
        dateTimeToInt(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)),
      );
      expect(
        12345678901234,
        dateTimeToInt(DateTime.fromMillisecondsSinceEpoch(12345678901234)),
      );
      expect(
        12345678901234,
        dateTimeToInt(
          DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
        ),
      );
    });

    test('dateTimeToString', () {
      expect(null, dateTimeToString(null));
      expect(
        '1970-01-01T00:00:00.000Z',
        dateTimeToString(DateTime.fromMillisecondsSinceEpoch(0)),
      );
      expect(
        '1970-01-01T00:00:00.000Z',
        dateTimeToString(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)),
      );
      expect(
        '2361-03-21T19:15:01.234Z',
        dateTimeToString(DateTime.fromMillisecondsSinceEpoch(12345678901234)),
      );
      expect(
        '2361-03-21T19:15:01.234Z',
        dateTimeToString(
          DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
        ),
      );
    });

    test('parseDateTime', () {
      expect(null, parseDateTime(null));
      expect(null, parseDateTime(''));
      expect(null, parseDateTime('0'));
      expect(null, parseDateTime('a'));
      expect(
        DateTime.fromMillisecondsSinceEpoch(12345678901234, isUtc: true),
        parseDateTime('2361-03-21T19:15:01.234Z'),
      );
      expect(parseDateTime('2361-03-21T19:15:01.234')!.isUtc, isFalse);
    });
  });
}
