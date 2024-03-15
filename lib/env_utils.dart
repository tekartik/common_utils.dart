// environment utils
import 'package:tekartik_common_utils/src/assert_utils.dart' as assert_utils;

/// Check whether in release mode
bool get isRelease => assert_utils.isRelease;

/// Check whether running in debug mode
/// Use flutter way since 2023-06-12
bool get isDebug => assert_utils.isDebug;

/// Special runtime trick to known whether we are in the javascript world
const isRunningAsJavascript = identical(1, 1.0);

/// Borrowed from flutter (isRunningAsJavascript is false in wasm)
const bool kDartIsWeb = bool.fromEnvironment('dart.library.js_util');
