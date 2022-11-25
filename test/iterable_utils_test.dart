import 'package:tekartik_common_utils/src/iterable_utils.dart';
import 'package:test/test.dart' hide isEmpty;

void main() {
  group('iterable_utils', () {
    test('firstOrNull', () {
      expect([].firstOrNull, isNull);
      expect([null].firstOrNull, isNull);
      expect([1].firstOrNull, 1);
      expect([1, 2].firstOrNull, 1);
    });
  });
}
