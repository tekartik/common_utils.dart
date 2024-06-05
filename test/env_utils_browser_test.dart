@TestOn('browser')
library;

import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/src/debug.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    test('web debugEnvMap', () async {
      expect(debugEnvMap, {
        'isDebug': isDebug,
        'kDartIoDebugMode': true,
        'isRelease': isRelease,
        'kDartIoReleaseMode': false,
        'isRunningAsJavascript': isRunningAsJavascript,
        'kDartIsWeb': true,
        'kDebugMode': true,
        'kReleaseMode': false,
        'kProfileMode': false,
        'kIsWeb': true,
        'kDartIsWebWasm': kDartIsWebWasm,
      });
    });
  });
}
