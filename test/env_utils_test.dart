import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/src/debug.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    // assuming we are testing in debug mode...
    test('debugEnvMap', () {
      var js = isRunningAsJavascript;
      expect(debugEnvMap, {
        'isDebug': true,
        'kDartIoDebugMode': true,
        'isRelease': false,
        'kDartIoReleaseMode': false,
        'isRunningAsJavascript': js,
        'kDartIsWeb': js,
        'kDebugMode': true,
        'kReleaseMode': false,
        'kProfileMode': false,
        'kIsWeb': js
      });
    });
  });
}
