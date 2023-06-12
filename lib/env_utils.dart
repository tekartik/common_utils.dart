// environment utils
import 'package:tekartik_common_utils/foundation/constants.dart' as foundation;

/// Check whether in release mode
bool get isRelease => !isDebug;

/// Check whether running in debug mode
/// Use flutter way since 2023-06-12
bool get isDebug => foundation.kDebugMode;

/// Special runtime trick to known whether we are in the javascript world
const isRunningAsJavascript = identical(1, 1.0);
