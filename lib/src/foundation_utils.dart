import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart';

/// Check whether running in release mode
bool get isFlutterRelease => kFlutterReleaseMode;

/// Compat
@Deprecated('Use isFlutterRelease')
bool get isRelease => isFlutterRelease;

/// Check whether running in debug mode
bool get isFlutterDebug => kFlutterDebugMode;

/// Compat
@Deprecated('Use isFlutterDebug')
bool get isDebug => isFlutterDebug;

/// Special runtime trick to known whether we are in the javascript world
const isFlutterRunningAsJavascript = kDartIsWebJs;

/// Compat
@Deprecated('Use isFlutterRunningAsJavascript')
const isRunningAsJavascript = isFlutterRunningAsJavascript;
