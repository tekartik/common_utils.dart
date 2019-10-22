//import 'package:quiver/strings.dart';

import 'package:tekartik_common_utils/string_utils.dart';
import 'package:tekartik_common_utils/date_time_utils.dart';

String formatYYYYdashMMdashDD(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

TimeOfDay timeOfDayLocalToUtc(TimeOfDay tod) {
  tod ??= TimeOfDay();
  DateTime dt = DateTime.now();
  dt = DateTime(dt.year, dt.month, dt.day, tod.hour, tod.minute);
  dt = dt.toUtc();
  return TimeOfDay(dt.hour, dt.minute);
}

TimeOfDay timeOfDayUtcToLocal(TimeOfDay tod) {
  tod ??= TimeOfDay();
  DateTime dt = DateTime.now().toUtc();
  dt = DateTime.utc(dt.year, dt.month, dt.day, tod.hour, tod.minute);
  dt = dt.toLocal();
  return TimeOfDay(dt.hour, dt.minute);
}

int dayOffsetLocalToUtc(int localDayOffset) {
  return localDayOffset - DateTime.now().timeZoneOffset.inMilliseconds;
}

int dayOffsetUtcToLocal(int utcDayOffset) {
  return utcDayOffset + DateTime.now().timeZoneOffset.inMilliseconds;
}

class TimeOfDay {
  int hour;
  int minute;

  int get milliseconds => (hour * 60 + minute) * 60 * 1000;

  TimeOfDay([int hour = 0, int minute = 0]) {
    while (minute < 0) {
      hour -= 1;
      minute += 60;
    }
    while (minute >= 60) {
      hour += 1;
      minute -= 60;
    }
    while (hour < 0) {
      hour += 24;
    }
    hour %= 24;
    this.minute = minute;
    this.hour = hour;
  }

  @override
  int get hashCode => hour + minute * 13;

  @override
  bool operator ==(o) {
    return o is TimeOfDay && o.hour == hour && o.minute == minute;
  }

  @override
  String toString() {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }

  static TimeOfDay parse(String text) {
    int minute = 0;
    int hour = 0;
    try {
      if (!stringIsEmpty(text)) {
        List<String> parts = text.split(":");
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }
    } catch (_) {}
    return TimeOfDay(hour, minute);
  }
}

const int secondInMillis = 1000;
const int minuteInMillis = 60 * secondInMillis;
const int hourInMillis = 60 * minuteInMillis;
const int dayInMillis = 24 * hourInMillis;
const int weekInMillis = 7 * dayInMillis;

DateTime newDateTimeClearTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

DateTime dateTimeWithOffset(DateTime dt, int offset) {
  return DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch + offset,
      isUtc: dt.isUtc);
}

String formatTimestampMinSeconds(int timestamp) {
  int seconds = (timestamp / 1000).round();
  int minutes = seconds ~/ 60;
  seconds -= minutes * 60;
  return "${minutes.toString()}:${seconds.toString().padLeft(2, "0")}";
}

// [datStartOffset] is the offset from utc, return a utc time, now can be anything
DateTime findBeginningOfDay(DateTime now, int dayStartOffset) {
  // make sure it goes after now, then go backwards
  // now.timeZoneName;
  DateTime begginingOfDay = dateTimeWithTimeCleared(now)
      .add(Duration(milliseconds: dayStartOffset + 2 * dayInMillis));

  while (now.isBefore(begginingOfDay)) {
    begginingOfDay = begginingOfDay.add(const Duration(days: -1));
  }
  return begginingOfDay;
}

// never return null

// to sort by reverse data
int reverseDateCompare(DateTime dateTime1, DateTime dateTime2) {
  if (dateTime1 != null) {
    if (dateTime2 == null) {
      return -1;
    } else {
      return dateTime2.compareTo(dateTime1);
    }
  } else if (dateTime2 != null) {
    return 1;
  }
// keep as is
  return 0;
}
