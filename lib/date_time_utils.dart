//import 'package:quiver/strings.dart';

String formatYYYYdashMMdashDD(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

const int secondInMillis = 1000;
const int minuteInMillis = 60 * secondInMillis;
const int hourInMillis = 60 * minuteInMillis;
const int dayInMillis = 24 * hourInMillis;
const int weekInMillis = 7 * dayInMillis;

@Deprecated('Do not use')
DateTime newDateTimeClearTime(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day);
}

DateTime dateTimeWithTimeCleared(DateTime dt) {
  if (dt.isUtc) {
    return DateTime.utc(dt.year, dt.month, dt.day);
  } else {
    return DateTime(dt.year, dt.month, dt.day);
  }
}

DateTime dateTimeWithOffset(DateTime dt, int offset) {
  return DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch + offset,
      isUtc: dt.isUtc);
}

// Support string, int or DateTime
DateTime? anyToDateTime(dynamic date) {
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

DateTime? parseDateTime(String? text) {
  if (text == null) {
    return null;
  }
  try {
    return DateTime.parse(text);
  } catch (_) {}
  return null;
}
