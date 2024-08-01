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
  });
}
