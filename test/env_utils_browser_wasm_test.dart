@TestOn('browser && wasm')
library;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/src/debug.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    test('web debugEnvMap', () async {
      expect(debugEnvMap, {
        'isDebug': isDebug,
        'kDartIoDebugMode': true,
        'isRelease': isRelease,
        'kDartIoReleaseMode': false,
        'isRunningAsJavascript': false,
        'kDartIsWeb': true,
        'kDebugMode': true,
        'kReleaseMode': false,
        'kProfileMode': false,
        'kIsWeb': true,
        'kDartIsWebWasm': true,
        'kDartIsWebJs': false,
      });
    });
  });
}
