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
    });

    test('parseVersionOrNull default', () {
      expect(parseVersionOrNull(null), isNull);
      expect(parseVersionOrNull('4.3.1'), Version(4, 3, 1));
      expect(parseVersionOrNull('4.3'), Version(4, 3, 0));
      expect(parseVersionOrNull('4.3.1.5'), Version(4, 3, 1, build: '5'));
      expect(parseVersionOrNull('4'), isNull);
    });
    test('parseVersionOrNull strict', () {
      expect(parseVersionOrNull(null, strict: true), isNull);
      expect(parseVersionOrNull('4.3.1', strict: true), Version(4, 3, 1));
      expect(parseVersionOrNull('4.3', strict: true), Version(4, 3, 0));
      expect(
        parseVersionOrNull('4.3.1.5', strict: true),
        Version(4, 3, 1, build: '5'),
      );
      expect(
        () => parseVersionOrNull('4', strict: true),
        throwsFormatException,
      );
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
      version = _vp('1.2.3-dev.1');
      expect(version.nextPreReleaseOrBuild, Version(1, 2, 3, pre: 'dev.2'));
    });
    test('bump', () {
      var version = _vp('1.2.3+1');
      expect(version.bump(), Version(1, 2, 3, build: '2'));
      expect(version.bump(ext: true).toString(), '1.2.3+2');
      expect(version.bump(ext: true, patch: true).toString(), '1.2.4+2');
      expect(version.bump(major: true).toString(), '2.0.0');
      expect(version.bump(major: true, ext: true).toString(), '2.0.0+2');
      expect(version.bump(minor: true).toString(), '1.3.0');
      expect(version.bump(patch: true).toString(), '1.2.4');
      expect(version.bump(major: true, ext: true).toString(), '2.0.0+2');
      version = _vp('1.2.3-dev.1');
      expect(version.bump(minor: true, ext: true).toString(), '1.3.0-dev.2');
    });
  });
}
