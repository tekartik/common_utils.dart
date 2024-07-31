import 'package:tekartik_common_utils/string_utils.dart';

/// Time of the day to utc
TimeOfDay timeOfDayLocalToUtc(TimeOfDay tod) {
  var dt = DateTime.now();
  dt = DateTime(dt.year, dt.month, dt.day, tod.hour, tod.minute);
  dt = dt.toUtc();
  return TimeOfDay(dt.hour, dt.minute);
}

/// Time of the day to local
TimeOfDay timeOfDayUtcToLocal(TimeOfDay tod) {
  var dt = DateTime.now().toUtc();
  dt = DateTime.utc(dt.year, dt.month, dt.day, tod.hour, tod.minute);
  dt = dt.toLocal();
  return TimeOfDay(dt.hour, dt.minute);
}

/// Time of the day
class TimeOfDay {
  /// Hour
  int hour;

  /// minute.
  int minute;

  /// Milliseconds
  int get milliseconds => (hour * 60 + minute) * 60 * 1000;

  /// Create a time of day
  TimeOfDay([this.hour = 0, this.minute = 0]) {
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
  }

  @override
  int get hashCode => hour + minute * 13;

  @override
  bool operator ==(Object other) {
    return other is TimeOfDay && other.hour == hour && other.minute == minute;
  }

  @override
  String toString() {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }

  /// Parse a time of day, default to 00:00
  static TimeOfDay parse(String? text) {
    var minute = 0;
    var hour = 0;
    try {
      if (!stringIsEmpty(text)) {
        var parts = text!.split(':');
        hour = int.parse(parts[0]);
        minute = int.parse(parts[1]);
      }
    } catch (_) {}
    return TimeOfDay(hour, minute);
  }
}
