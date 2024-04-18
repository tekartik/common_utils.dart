import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart';

Map<String, Object?> get debugEnvMap {
  var map = {
    'isDebug': isDebug,
    'kDartIoDebugMode': kDartIoDebugMode,
    'isRelease': isRelease,
    'kDartIoReleaseMode': kDartIoReleaseMode,
    'isRunningAsJavascript': isRunningAsJavascript,
    'kDartIsWeb': kDartIsWeb,
    'kDebugMode': kDebugMode,
    'kReleaseMode': kReleaseMode,
    'kProfileMode': kProfileMode,
    'kIsWeb': kIsWeb,
  };
  return map;
}
