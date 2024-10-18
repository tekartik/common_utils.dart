@TestOn('vm')
library;

import 'dart:convert';

import 'package:process_run/shell.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    test('io release debugEnvMap', () async {
      await run('dart compile exe example/env_utils_io/main.dart');
      var text = (await run('./example/env_utils_io/main.exe')).first.outText;
      var map = jsonDecode(text) as Map;
      expect(map, {
        'isDebug': false,
        'kDartIoDebugMode': false,
        'isRelease': true,
        'kDartIoReleaseMode': true,
        'isRunningAsJavascript': false,
        'kDartIsWeb': false,
        'kDebugMode': false,
        'kReleaseMode': true,
        'kProfileMode': false,
        'kIsWeb': false,
        'kDartIsWebWasm': false,
        'kDartIsWebJs': false,
      });
    });
  });
}
