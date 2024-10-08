library;

//import 'package:unittest/vm_config.dart';
import 'package:tekartik_common_utils/version_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

Version _vp(String versionText) => Version.parse(versionText);

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

    test('noPreReleaseOrBuild', () {
      var version = _vp('1.2.3+1');
      expect(version.noPreReleaseOrBuild, Version(1, 2, 3));
      version = _vp('1.2.3-1');
      expect(version.noPreReleaseOrBuild, Version(1, 2, 3));
    });

    test('nextPreReleaseOrBuild', () {
      var version = _vp('1.2.3+1');
      expect(version.nextPreReleaseOrBuild, Version(1, 2, 3, build: '2'));
      version = _vp('1.2.3-1');
      expect(version.nextPreReleaseOrBuild, Version(1, 2, 3, pre: '2'));
      version = _vp('1.2.3');
      expect(version.nextPreReleaseOrBuild, Version(1, 2, 3, build: '0'));
    });
  });
}
