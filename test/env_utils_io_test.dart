@TestOn('vm')
library;

import 'dart:convert';

import 'package:dev_test/test.dart';
import 'package:process_run/shell.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    test('io release', () async {
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
        'kIsWeb': false
      });
    });
  });
}
