//import 'package:quiver/strings.dart';

String formatYYYYdashMMdashDD(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month
      .toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

const int secondInMillis = 1000;
const int minuteInMillis = 60 * secondInMillis;
const int hourInMillis = 60 * minuteInMillis;
const int dayInMillis = 24 * hourInMillis;
const int weekInMillis = 7 * dayInMillis;

@deprecated
DateTime newDateTimeClearTime(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day);
}

DateTime dateTimeWithTimeCleared(DateTime dt) {
  if (dt.isUtc) {
    return new DateTime.utc(dt.year, dt.month, dt.day);
  } else {
    return new DateTime(dt.year, dt.month, dt.day);
  }
}

DateTime dateTimeWithOffset(DateTime dt, int offset) {
  return new DateTime.fromMillisecondsSinceEpoch(
      dt.millisecondsSinceEpoch + offset,
      isUtc: dt.isUtc);
}
