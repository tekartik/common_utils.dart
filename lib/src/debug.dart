import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart' as fundation;

import 'env_utils.dart';

/// debug environment map
Map<String, Object?> get debugEnvMap {
  var map = {
    'isDebug': isDebug,
    'kDartIoDebugMode': kDartIoDebugMode,
    'isRelease': isRelease,
    'kDartIoReleaseMode': kDartIoReleaseMode,
    'isRunningAsJavascript': isRunningAsJavascript,
    'kDartIsWeb': kDartIsWeb,
    'kFlutterDebugMode': fundation.kFlutterDebugMode,
    'kFlutterReleaseMode': fundation.kFlutterReleaseMode,
    'kFlutterProfileMode': fundation.kFlutterProfileMode,
    'kFlutterIsWeb': fundation.kFlutterIsWeb,
    'kDartIsWebWasm': kDartIsWebWasm,
    'kDartIsWebJs': kDartIsWebJs,
  };
  return map;
}
