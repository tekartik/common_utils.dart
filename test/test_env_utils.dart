import 'package:tekartik_common_utils/env_utils.dart';

/// True if we wasm
bool get isWebWasm => kDartIsWeb && !isRunningAsJavascript;
