import 'package:dev_test/test.dart' hide isEmpty;
import 'package:tekartik_common_utils/list_utils.dart';

void main() {
  group("list_utils", () {
    test('isEmpty', () {
      expect(isEmpty(null), isTrue);
      expect(isEmpty([]), isTrue);
      expect(isEmpty([null]), isFalse);
    });

    test('first', () {
      expect(first(null), isNull);
      expect(first([]), isNull);
      expect(first([null]), isNull);
      expect(first([1]), 1);
      expect(first([1, 2]), 1);
    });
  });
}
