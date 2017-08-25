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

    test('listFirst', () {
      expect(listFirst(null), isNull);
      expect(listFirst([]), isNull);
      expect(listFirst([null]), isNull);
      expect(listFirst([1]), 1);
      expect(listFirst([1, 2]), 1);
    });

    test('listLast', () {
      expect(listLast(null), isNull);
      expect(listLast([]), isNull);
      expect(listLast([null]), isNull);
      expect(listLast([1]), 1);
      expect(listLast([1, 2]), 2);
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

    test('equals', () {
      expect(cloneList([]), []);
      expect(identical(cloneList([]), []), isFalse);

      List list1 = [1, [], {}];
      List listFrom = new List.from(list1);
      List list2 = cloneList(list1);
      expect(listFrom, list1);
      expect(list2, list1);

      // however their map/list content is not identical (i.e. cloned)
      expect(identical(listFrom[0], list1[0]), isTrue);
      expect(identical(list2[0], list1[0]), isTrue);
      expect(identical(listFrom[1], list1[1]), isTrue);
      expect(identical(list2[1], list1[1]), isFalse);
      expect(identical(listFrom[2], list1[2]), isTrue);
      expect(identical(list2[2], list1[2]), isFalse);
    });
  });
}
