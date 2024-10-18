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
/// Work in non-flutter environment too
const bool kDartIsWeb = bool.fromEnvironment('dart.library.js_util');

/// Borrowed from flutter - not valid on the web if not flutter
const bool kDartIoReleaseMode = bool.fromEnvironment('dart.vm.product');

/// Borrowed from flutter - not valid on the web if not flutter
const bool kDartIoProfileMode = bool.fromEnvironment('dart.vm.profile');

/// Borrowed from flutter - not valid on the web if not flutter
const bool kDartIoDebugMode = !kDartIoReleaseMode && !kDartIoProfileMode;

/// True if we wasm
const kDartIsWebWasm = kDartIsWeb && !isRunningAsJavascript;

/// True in web js
const kDartIsWebJs = kDartIsWeb && isRunningAsJavascript;
