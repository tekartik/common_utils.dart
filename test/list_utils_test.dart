import 'package:dev_test/test.dart' hide isEmpty;
import 'package:tekartik_common_utils/list_utils.dart';

void main() {
  group("list_utils", () {
    test('isEmpty', () {
      expect(listIsEmpty(null), isTrue);
      expect(listIsEmpty([]), isTrue);
      expect(listIsEmpty([null]), isFalse);
    });

    test('first', () {
      expect(first(null), isNull);
      expect(first([]), isNull);
      expect(first([null]), isNull);
      expect(first([1]), 1);
      expect(first([1, 2]), 1);
    });

    test('listLength', () {
      expect(listLength(null), 0);
      expect(listLength([]), 0);
      expect(listLength([null]), 1);
      expect(listLength([1]), 1);
      expect(listLength([1, 2]), 2);
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
      expect(listTruncate(null, 0), isNull);
      expect(listTruncate(null, 1), isNull);
      expect(listTruncate([], 0), []);
      expect(listTruncate([], -1), []);
      expect(listTruncate([], 1), []);
      expect(listTruncate([1], 1), [1]);
      expect(listTruncate([1], 2), [1]);
      expect(listTruncate([1], 0), []);
      expect(listTruncate([1], -1), []);
      expect(listTruncate([1, 2], -1), []);
      expect(listTruncate([1, 2], 0), []);
      expect(listTruncate([1, 2], 1), [1]);
      expect(listTruncate([1, 2], 2), [1, 2]);
      expect(listTruncate([1, 2], 3), [1, 2]);
    });

    test('subList', () {
      expect(listSubList(null, 0), isNull);
      expect(listSubList(null, 1), isNull);
      expect(listSubList([], 0), []);
      expect(listSubList([], -1), []);
      expect(listSubList([], 1), []);
      expect(listSubList([1], 1), []);
      expect(listSubList([1], 2), []);
      expect(listSubList([1], 0), [1]);
      expect(listSubList([1], -1), [1]);
      expect(listSubList([1, 2], -1), [1, 2]);
      expect(listSubList([1, 2], 0), [1, 2]);
      expect(listSubList([1, 2], 1), [2]);
      expect(listSubList([1, 2], 2), []);
      expect(listSubList([1, 2], 3), []);
      expect(listSubList([1, 2], 1, 3), [2]);
      expect(listSubList([1, 2], 1, 2), [2]);
      expect(listSubList([1, 2], 1, 1), []);
    });

    test('asList', () {
      expect(asList(null), isNull);
      expect(asList([]), []);
      expect(asList({}), isNull);
      expect(asList(1), isNull);
      expect(asList([1]), [1]);
      expect(asList<String>([1]), isNull);
    });

    test('equals', () {
      expect(cloneList([]), []);
      expect(identical(cloneList([]), []), isFalse);

      List list1 = [1, [], {}];
      List listFrom = List.from(list1);
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

    test('chunk', () {
      expect(listChunk(null, null), []);
      expect(listChunk([], null), []);
      expect(listChunk([1], null), [
        [1]
      ]);
      expect(listChunk([1], 0), [
        [1]
      ]);
      expect(listChunk([1, 2], 0), [
        [1, 2]
      ]);
      expect(listChunk([1, 2], 2), [
        [1, 2]
      ]);
      expect(listChunk([1, 2], 3), [
        [1, 2]
      ]);
      expect(listChunk([1, 2], 1), [
        [1],
        [2]
      ]);
      expect(listChunk([1, 2, 3], 2), [
        [1, 2],
        [3]
      ]);
    });
  });
}
