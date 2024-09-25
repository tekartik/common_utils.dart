library;

import 'package:tekartik_common_utils/dev_utils.dart';
import 'package:test/test.dart';

// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package
void main() => defineTests(true);

void defineTests([bool disableOutput = true]) {
  //useVMConfiguration();
  group('dev_utils', () {
    setUp(() {
      if (disableOutput) {
        debugDevPrintEnabled = false;
      }
    });
    tearDown(() {
      if (disableOutput) {
        debugDevPrintEnabled = true;
      }
    });

    test('devPrint', () {
      debugDevPrint('dev print message');
    });
    test('debugEnvMap', () {
      expect(debugEnvMap, isNotNull);
    });
    test('devError', () {
      if (disableOutput) {
        debugDevPrintEnabled = false;
      }
      try {
        debugDevError({'some': 'data'});
        fail('no');
      } on UnsupportedError catch (_) {}
      if (disableOutput) {
        debugDevPrintEnabled = true;
      }
    });

    test('devWarning', () {
      // ignore: unnecessary_statements
      devWarning;
      expect(devWarning(true), isTrue);
      expect(devWarning(3), 3);
    });

    test('DevFlag', () {
      var debug = DevFlag();
      expect(debug.on, isFalse);

      // could not get rid of warnings...
      // debug.on = true; // ignore: deprecated_member_use
      // expect(debug.on, isTrue);
      // debug.on = null; // ignore: deprecated_member_use
      // expect(debug.on, isFalse);
      // debug.on = true; // ignore: deprecated_member_use
      // expect(debug.on, isTrue);
      // debug.on = false; // ignore: deprecated_member_use
      // expect(debug.on, isFalse);
    });
  });
}
