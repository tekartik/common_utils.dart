library version_utils_test;

import 'package:test/test.dart';
//import 'package:unittest/vm_config.dart';
import 'package:tekartik_common_utils/version_utils.dart';

void main() => defineTests();

void defineTests() {
  //useVMConfiguration();
  group('version', () {
    test('parse_hack', () {
      expect(parseVersion('4.3.1'), new Version(4, 3, 1));
      expect(parseVersion('4.3'), new Version(4, 3, 0));
      expect(parseVersion('4.3.1.5'), new Version(4, 3, 1, build: '5'));
      //expect(parseVersion('4'), new Version(4, 0, 0));
    });

    test('parse', () {
      expect(new Version.parse('4.3.1'), new Version(4, 3, 1));
      try {
        expect(new Version.parse('4.3'), new Version(4, 3, 0));
        fail('should not parse');
      } on FormatException catch (_) {}
      try {
        expect(new Version.parse('4.3.1.5'), new Version(4, 3, 1, build: '5'));
        fail('should not parse');
      } on FormatException catch (_) {}
    });
  });
}
