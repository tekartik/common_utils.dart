library dev_utils_test;

import 'package:tekartik_common_utils/dev_utils.dart';
import 'package:test/test.dart';

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
      debugDevPrint("dev print message");
    });
    test('devError', () {
      if (disableOutput) {
        debugDevPrintEnabled = false;
      }
      try {
        debugDevError("from test not supported");
        fail('no');
      } catch (e) {}
      if (disableOutput) {
        debugDevPrintEnabled = true;
      }
    });
  });
}
