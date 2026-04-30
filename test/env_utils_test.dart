import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  // ignore: avoid_print
  print('debugEnvMap: ${jsonPretty(debugEnvMap)}');

  test('all', () {
    expect(debugEnvMap, {
      'isDebug': isDebug,
      'kDartIoDebugMode': kDartIoDebugMode,
      'isRelease': isRelease,
      'kDartIoReleaseMode': kDartIoReleaseMode,
      'isRunningAsJavascript': isRunningAsJavascript,
      'kDartIsWeb': kDartIsWeb,
      'kFlutterDebugMode': kFlutterDebugMode,
      'kFlutterReleaseMode': kFlutterReleaseMode,
      'kFlutterProfileMode': false,
      'kFlutterIsWeb': kFlutterIsWeb,
      'kDartIsWebWasm': kDartIsWebWasm,
      'kDartIsWebJs': kDartIsWebJs,
    });
  });
  // assuming we are testing in debug mode...
  if (isRelease) {
    test('debugEnvMap (release)', () {
      expect(debugEnvMap, {
        'isDebug': false,
        'kDartIoDebugMode': kDartIsWeb ? true : false, // !!
        'isRelease': true,
        'kDartIoReleaseMode': kDartIsWeb ? false : true, // !!
        'isRunningAsJavascript': isRunningAsJavascript,
        'kDartIsWeb': kDartIsWeb,
        'kFlutterDebugMode': kDartIsWeb ? true : false, // !!
        'kFlutterReleaseMode': kDartIsWeb ? false : true, // !!
        'kFlutterProfileMode': kDartIsWeb ? true : false, // !!
        'kFlutterIsWeb': kFlutterIsWeb,
        'kDartIsWebWasm': kDartIsWebWasm,
        'kDartIsWebJs': kDartIsWebJs,
      });
    });
  } else {
    test('debugEnvMap (debug)', () {
      expect(debugEnvMap, {
        'isDebug': isDebug,
        'kDartIoDebugMode': true,
        'isRelease': isRelease,
        'kDartIoReleaseMode': false,
        'isRunningAsJavascript': isRunningAsJavascript,
        'kDartIsWeb': kDartIsWeb,
        'kFlutterDebugMode': true,
        'kFlutterReleaseMode': false,
        'kFlutterProfileMode': false,
        'kFlutterIsWeb': kFlutterIsWeb,
        'kDartIsWebWasm': kDartIsWebWasm,
        'kDartIsWebJs': kDartIsWebJs,
      });
    });
  }
}

/** Web release
 * {
    "isDebug": false,
    "kDartIoDebugMode": true,
    "isRelease": true,
    "kDartIoReleaseMode": false,
    "isRunningAsJavascript": true,
    "kDartIsWeb": true,
    "kFlutterDebugMode": true,
    "kFlutterReleaseMode": false,
    "kFlutterProfileMode": false,
    "kFlutterIsWeb": true,
    "kDartIsWebWasm": false,
    "kDartIsWebJs": true
    }
 */
