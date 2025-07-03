import 'package:tekartik_common_utils/iterable_utils.dart';
import 'package:test/test.dart' hide isEmpty;

void main() {
  group('iterable_utils', () {
    test('firstWhereOrNull', () {
      expect(<int>[].firstWhereOrNull((_) => true), isNull);
      expect([null].firstWhereOrNull((_) => true), isNull);
      expect([1].firstWhereOrNull((_) => true), 1);
      expect([1, 2].firstWhereOrNull((_) => true), 1);
    });
    test('containsAny', () {
      expect(<int>[].containsAny(<int>[]), isFalse);
      expect(<int>[].containsAny(<int>[1]), isFalse);
      expect([1].containsAny(<int>[]), isFalse);
      expect([1].containsAny(<int>[1]), isTrue);
      expect([1].containsAny(<int>[2]), isFalse);
      expect([1, 2].containsAny(<int>[2]), isTrue);
      expect([1, 2].containsAny(<int>[3]), isFalse);
      expect([1, 2].containsAny(<int>[1, 3]), isTrue);
    });
  });
}
