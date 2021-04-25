library version_utils_test;

//import 'package:unittest/vm_config.dart';
import 'package:tekartik_common_utils/version_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  //useVMConfiguration();
  group('version', () {
    test('parse_hack', () {
      expect(parseVersion('4.3.1'), Version(4, 3, 1));
      expect(parseVersion('4.3'), Version(4, 3, 0));
      expect(parseVersion('4.3.1.5'), Version(4, 3, 1, build: '5'));
      //expect(parseVersion('4'), new Version(4, 0, 0));
    });

    test('parse', () {
      expect(Version.parse('4.3.1'), Version(4, 3, 1));
      try {
        expect(Version.parse('4.3'), Version(4, 3, 0));
        fail('should not parse');
      } on FormatException catch (_) {}
      try {
        expect(Version.parse('4.3.1.5'), Version(4, 3, 1, build: '5'));
        fail('should not parse');
      } on FormatException catch (_) {}
    });
  });
}
