library tekartik_log_utils;

import 'package:logging/logging.dart';

export 'package:logging/logging.dart';

/// quick replacement for `print()` - use `info()` or `debug()`
bool _quickLoggingSetup = false;

/// To user when you want to make sure code is removed
@deprecated
void debugQuickLogging(Level level) {
  setupQuickLogging(level);
}

void setupQuickLogging([Level? level]) {
  if (!_quickLoggingSetup) {
    hierarchicalLoggingEnabled = true;
    final handler = _PrintHandler();
    Logger.root.onRecord.listen((LogRecord logRecord) {
      handler.call(logRecord);
    });
    _quickLoggingSetup = true;
  }
  if (level != null) {
    Logger.root.level = level;
    //log.info('QuickLoggingSetup');
  }
}

class _PrintHandler {
  void call(LogRecord logRecord) {
    print(
        '${logRecord.time} ${logRecord.loggerName} ${logRecord.level} ${logRecord.message}');
  }
}

@Deprecated('Use logLevel')
// ignore: non_constant_identifier_names
final List<Level> LOG_LEVELS = logLevels;
final List<Level> logLevels = [
  Level.OFF,
  Level.SHOUT,
  Level.SEVERE,
  Level.WARNING,
  Level.INFO,
  Level.CONFIG,
  Level.FINE,
  Level.FINER,
  Level.FINEST,
  Level.ALL
];

Level parseLogLevel(String levelText, [Level defaultLevel = Level.OFF]) {
  levelText = levelText.toUpperCase();
  for (var level in logLevels) {
    if (level.name == levelText) {
      //print('level: $level');
      return level;
    }
  }

  return defaultLevel;
}

Logger? _log;

Logger? get log {
  _log ??= Logger('Quick');
  return _log;
}

String _stringPrefilled(String text, int len, String char) {
  var length = text.length;
  final out = StringBuffer();
  while (length < len) {
    out.write(char);
    length += char.length;
  }
  out.write(text);
  return out.toString();
}

String formatTimestampMs(num? timestamp) {
  // Allow 6 digits => 1000s
  final size = 6;
  //String txt;

  if (timestamp == null) {
    return _stringPrefilled('(null)', size, ' ');
  } else {
    var s = (timestamp ~/ 1000);
    var ms = (timestamp - s * 1000).round();
    if (ms == 1000) {
      s += 1;
      ms = 0;
    }
    return '${_stringPrefilled('${s % 100}', 2, '0')}.${_stringPrefilled('$ms', 3, '0')}';
  }
}

/// from 00.00 to 100.0
String format0To1AsPercent(num? value) {
  //int size = 6;
  //String txt;

  if (value == null) {
    return _stringPrefilled('(nul)', 5, ' ');
  } else {
    var per10000 = value * 10000;
    var per100 = per10000 ~/ 100;
    var cents = (per10000 - per100 * 100).round();
    if (cents == 100) {
      per100 += 1;
      cents = 0;
    }
    var centsDigitCount = 2;
    if (per100 >= 100) {
      centsDigitCount = 1;
      cents ~/= 10;
    }
    return '${_stringPrefilled('$per100', 2, '0')}.${_stringPrefilled('$cents', centsDigitCount, '0')}';
  }
}
