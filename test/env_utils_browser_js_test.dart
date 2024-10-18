@TestOn('browser && js')
library;

import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/src/debug.dart';
import 'package:test/test.dart';

void main() => defineBrowserJsTests();
void defineBrowserJsTests() {
  group('debugEnvMapWebJs', () {
    // assuming we are testing in debug mode...
    test('kDartIsWebJs', () {
      expect(kDartIsWebJs, isTrue);
      expect(debugEnvMap['kDartIsWebJs'], isTrue);
    });
  });
}
