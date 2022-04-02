import 'package:tekartik_common_utils/list_utils.dart';
import 'package:test/test.dart' hide isEmpty;

void main() {
  group('list_utils', () {
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

    test('listGet', () {
      expect(listGet([], 0), isNull);
      expect(listGet([1], 0), 1);
      expect(listGet([1], -1), isNull);
      expect(listGet([1], 1), isNull);
      expect(listGet([1, 2], 1), 2);
    });

    test('truncate', () {
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
      expect(listSubList([1, 2], 1, -1), []);
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

      var list1 = [1, [], {}];
      var listFrom = List.from(list1);
      var list2 = cloneList(list1);
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
    test('LazyReadOnlyList', () {
      Iterable<int> src = <int>[1];
      var dst = LazyReadOnlyList<int, String>(src, (item) => item.toString());
      expect(dst.isTransformed(0), isFalse);
      expect(dst[0], '1');
      expect(dst.isTransformed(0), isTrue);

      src = <int>[1, 2];
      var lazy = src.lazy<String>((src) => src.toString());
      expect(lazy, ['1', '2']);
    });
    test('listFlatten', () {
      expect(
          listFlatten([
            [1],
            [2, 3]
          ]),
          [1, 2, 3]);
      expect(
          listFlatten<int>([
            [1]
          ]),
          const TypeMatcher<List<int>>());
    });
    test('listSingleOrNull', () {
      expect(listSingleOrNull([]), isNull);
      expect(listSingleOrNull([1]), 1);
      expect(listSingleOrNull(['test']), 'test');
      expect(listSingleOrNull(['test', 1]), isNull);
      expect(listSingleOrNull([null]), isNull);
      // handle iterable
      Iterable<int> iterable = [1];
      expect(listSingleOrNull(iterable), 1);
    });
  });
}
