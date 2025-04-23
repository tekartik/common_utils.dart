// ignore_for_file: unnecessary_statements

import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:test/test.dart';

void main() {
  test('common_utils_import api', () {
    castAsNullable;
    castAsOrNull;

    // Unfortunately from log_utils...that we start deprecating
    // ignore: deprecated_member_use_from_same_package
    log;
    Logger;
    Level;
    // ignore: deprecated_member_use_from_same_package
    debugQuickLogging;
    setupQuickLogging;
    parseLogLevel;
    logLevels;
    formatTimestampMs;
    format0To1AsPercent;
  });
}
