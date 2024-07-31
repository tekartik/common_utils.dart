import 'package:tekartik_common_utils/foundation/constants.dart';

/// Check whether running in release mode
bool get isRelease => kReleaseMode;

/// Check whether running in debug mode
bool get isDebug => kDebugMode;

/// Special runtime trick to known whether we are in the javascript world
const isRunningAsJavascript = kIsWeb;
