// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:tekartik_common_utils/src/date_time_utils.dart';
import 'package:test/test.dart';

void main() {
  group('timeOfDay', () {
    test('parse', () {
      expect(TimeOfDay.parse(null).toString(), "00:00");
      expect(TimeOfDay.parse("").toString(), "00:00");
      expect(TimeOfDay.parse("1").toString(), "01:00");
      expect(TimeOfDay.parse("0:-1").toString(), "23:59");
      expect(TimeOfDay.parse("-47").toString(), "01:00");
      expect(TimeOfDay.parse("0:60").toString(), "01:00");
    });

    test('localToUtc', () {
      // only valid in france
      DateTime dt = new DateTime.now();
      //print(dt.timeZoneOffset);
      expect(timeOfDayLocalToUtc(TimeOfDay.parse("11:00")),
          TimeOfDay.parse("11:${-dt.timeZoneOffset.inMinutes}"));
      // for france expect(timeOfDayLocalToUtc(TimeOfDay.parse("11:00")),TimeOfDay.parse("10:00"));
    });

    test('utcToLocal', () {
      // only valid in france
      DateTime dt = new DateTime.now();
      //print(dt.timeZoneOffset);
      expect(timeOfDayUtcToLocal(TimeOfDay.parse("11:00")),
          TimeOfDay.parse("11:${dt.timeZoneOffset.inMinutes}"));
      /*
      // for france
      expect(timeOfDayUtcToLocal(TimeOfDay.parse("11:00")),
          TimeOfDay.parse("12:00"));

      expect(timeOfDayUtcToLocal(TimeOfDay.parse("00:00")),
          TimeOfDay.parse("01:00"));
          */
    });

    test('begginningOfDay', () {
      // only valid in france
      /*
      DateTime dt = new DateTime.now();
      devPrint(dt);
      devPrint(dt.toLocal());
      devPrint(dt.toUtc());
      dt = new DateTime(2017, 2, 19, 14);
      devPrint(dt);
      devPrint(dt.toLocal());
      devPrint(dt.toUtc());
      */
      expect(findBeginningOfDay(new DateTime.utc(2017, 2, 19, 14), 0),
          new DateTime.utc(2017, 2, 19));
      expect(findBeginningOfDay(new DateTime(2017, 2, 19, 14), 0),
          new DateTime(2017, 2, 19));
      /*
      expect(new DateTime(2017, 2, 19, 14).toUtc(),
          new DateTime.utc(2017, 2, 19, 13));
      expect(new DateTime.utc(2017, 2, 19, 14).toLocal(),
          new DateTime(2017, 2, 19, 15));
          */
      /*
      expect(findBeginningOfDay(new DateTime.utc(2017, 2, 19, 14), 0),
          new DateTime(2017, 2, 19, 1));
      expect(findBeginningOfDay(new DateTime(2017, 2, 19, 1), 0),
          new DateTime(2017, 2, 19, 1));
      expect(findBeginningOfDay(new DateTime(2017, 2, 19, 0, 59), 0),
          new DateTime(2017, 2, 18, 1));
          */
      expect(findBeginningOfDay(new DateTime.utc(2017, 2, 19, 14), 86340000),
          new DateTime.utc(2017, 2, 18, 23, 59));
      expect(findBeginningOfDay(new DateTime(2017, 2, 19, 1, 1), -86340000),
          new DateTime(2017, 2, 19, 0, 1));
      expect(findBeginningOfDay(new DateTime(2017, 2, 19, 1, 0), -86340000),
          new DateTime(2017, 2, 19, 0, 1));
    });
  });
}
