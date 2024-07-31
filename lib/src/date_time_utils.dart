/// Format a date time as yyyy-mm-dd
String formatYYYYdashMMdashDD(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

/// day offset to utc
int dayOffsetLocalToUtc(int localDayOffset) {
  return localDayOffset - DateTime.now().timeZoneOffset.inMilliseconds;
}

/// day offset to local
int dayOffsetUtcToLocal(int utcDayOffset) {
  return utcDayOffset + DateTime.now().timeZoneOffset.inMilliseconds;
}

/// Milliseconds in a second
const int secondInMillis = 1000;

/// Milliseconds in a minute
const int minuteInMillis = 60 * secondInMillis;

/// Milliseconds in an hour
const int hourInMillis = 60 * minuteInMillis;

/// Milliseconds in a day
const int dayInMillis = 24 * hourInMillis;

/// Milliseconds in a week
const int weekInMillis = 7 * dayInMillis;

/// New local date with time cleared
@Deprecated('Use newDateTimeClearTime')
DateTime newDateTimeClearTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

/// New local date with offset
DateTime dateTimeWithOffset(DateTime dt, int offset) {
  return DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch + offset,
      isUtc: dt.isUtc);
}

/// minutes:seconds
/// @Deprecated('?')
String formatTimestampMinSeconds(int timestamp) {
  var seconds = (timestamp / 1000).round();
  final minutes = seconds ~/ 60;
  seconds -= minutes * 60;
  return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
}

/// [datStartOffset] is the offset from utc, return a utc time, now can be anything
DateTime findBeginningOfDay(DateTime now, int dayStartOffset) {
  // make sure it goes after now, then go backwards
  // now.timeZoneName;
  var begginingOfDay = dateTimeWithTimeCleared(now)
      .add(Duration(milliseconds: dayStartOffset + 2 * dayInMillis));

  while (now.isBefore(begginingOfDay)) {
    begginingOfDay = begginingOfDay.add(const Duration(days: -1));
  }
  return begginingOfDay;
}

// never return null

/// to sort by reverse data
int reverseDateCompare(DateTime? dateTime1, DateTime? dateTime2) {
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

/// Clear the time part of a date time
DateTime dateTimeWithTimeCleared(DateTime dt) {
  if (dt.isUtc) {
    return DateTime.utc(dt.year, dt.month, dt.day);
  } else {
    return DateTime(dt.year, dt.month, dt.day);
  }
}

/// Support string, int or DateTime
DateTime? anyToDateTime(Object? date) {
  try {
    if (date is DateTime) {
      return date;
    } else if (date is String) {
      return parseDateTime(date);
    } else if (date is int) {
      return dateTimeFromInt(date);
    }
  } catch (_) {}
  return null;
}

/// since epoch
/// always convert to utc
DateTime? dateTimeFromInt(int? millis) {
  if (millis == null) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
}

/// millis since epocj
int? dateTimeToInt(DateTime? date) {
  if (date == null) {
    return null;
  }
  return date.millisecondsSinceEpoch;
}

/// always convert to utc
String? dateTimeToString(DateTime? date) {
  if (date == null) {
    return null;
  }
  return date.toUtc().toIso8601String();
}

/// Try to parse a date time
DateTime? parseDateTime(String? text) {
  if (text == null) {
    return null;
  }
  try {
    return DateTime.parse(text);
  } catch (_) {}
  return null;
}
