import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/src/debug.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    // assuming we are testing in debug mode...
    test('debugEnvMap', () {
      expect(isRelease, isFalse, reason: 'isRelease');

      expect(debugEnvMap, {
        'isDebug': isDebug,
        'kDartIoDebugMode': true,
        'isRelease': isRelease,
        'kDartIoReleaseMode': false,
        'isRunningAsJavascript': isRunningAsJavascript,
        'kDartIsWeb': kDartIsWeb,
        'kDebugMode': true,
        'kReleaseMode': false,
        'kProfileMode': false,
        'kIsWeb': kDartIsWeb,
        'kDartIsWebWasm': kDartIsWebWasm,
        'kDartIsWebJs': kDartIsWebJs,
      });
    });
  });
}
