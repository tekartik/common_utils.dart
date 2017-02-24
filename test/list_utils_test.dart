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

    test('truncate', () {
      expect(truncate(null, 0), isNull);
      expect(truncate(null, 1), isNull);
      expect(truncate([], 0), []);
      expect(truncate([], -1), []);
      expect(truncate([], 1), []);
      expect(truncate([1], 1), [1]);
      expect(truncate([1], 2), [1]);
      expect(truncate([1], 0), []);
      expect(truncate([1], -1), []);
      expect(truncate([1, 2], -1), []);
      expect(truncate([1, 2], 0), []);
      expect(truncate([1, 2], 1), [1]);
      expect(truncate([1, 2], 2), [1, 2]);
      expect(truncate([1, 2], 3), [1, 2]);
    });
  });
}
