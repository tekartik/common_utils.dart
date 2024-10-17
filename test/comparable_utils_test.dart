import 'package:tekartik_common_utils/comparable_utils.dart';
import 'package:tekartik_common_utils/version_utils.dart';
import 'package:test/test.dart';

void main() {
  group('comparable_utils', () {
    var version1 = Version(1, 2, 3);
    var version2 = Version(4, 5, 6);
    var version3 = Version(7, 8, 9);
    test('comparableMax', () {
      expect(comparableMax(1, 2), 2);
      expect(comparableMax(2, 1), 2);
      expect(comparableMax(version1, version2), version2);
      expect(comparableMax(version2, version1), version2);
    });
    test('comparableMin', () {
      expect(comparableMin(1, 2), 1);
      expect(comparableMin(2, 1), 1);
      expect(comparableMin(version1, version2), version1);
      expect(comparableMin(version2, version1), version1);
    });
    test('bounded', () {
      expect(version2.boundedMin(version1), version2);
      expect(version2.boundedMin(version3), version3);
      expect(version2.boundedMax(version1), version1);
      expect(version2.boundedMax(version3), version2);
      expect(version2.bounded(version1, version3), version2);
      expect(version1.bounded(version2, version3), version2);
      expect(version3.bounded(version1, version2), version2);
      expect(version2.bounded(version3, version3), version3);
      expect(version2.bounded(version3, version1), version3);
      expect(version2.bounded(version1, version1), version1);
    });
  });
}
