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
    'kDebugMode': fundation.kDebugMode,
    'kReleaseMode': fundation.kReleaseMode,
    'kProfileMode': fundation.kProfileMode,
    'kIsWeb': fundation.kIsWeb,
    'kDartIsWebWasm': kDartIsWebWasm,
  };
  return map;
}
