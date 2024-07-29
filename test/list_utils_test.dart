import 'package:tekartik_common_utils/list_utils.dart' hide isEmpty;

import 'package:test/test.dart';

import 'map_utils_test.dart';

List<Object?> get emptyList => <Object?>[];

void main() {
  group('list_utils', () {
    test('isEmpty', () {
      expect(listIsEmpty(null), isTrue);
      expect(listIsEmpty(emptyList), isTrue);
      expect(listIsEmpty([null]), isFalse);
    });

    test('first', () {
      // ignore: deprecated_member_use_from_same_package
      expect(first<Object?>(null), isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(first(emptyList), isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(first([null]), isNull);
      // ignore: deprecated_member_use_from_same_package
      expect(first([1]), 1);
      // ignore: deprecated_member_use_from_same_package
      expect(first([1, 2]), 1);
    });

    test('listLength', () {
      expect(listLength(null), 0);
      expect(listLength(emptyList), 0);
      expect(listLength([null]), 1);
      expect(listLength([1]), 1);
      expect(listLength([1, 2]), 2);
    });

    test('listFirst', () {
      expect(listFirst<Object?>(null), isNull);
      expect(listFirst(emptyList), isNull);
      expect(listFirst([null]), isNull);
      expect(listFirst([1]), 1);
      expect(listFirst([1, 2]), 1);
    });

    test('listLast', () {
      expect(listLast<Object?>(null), isNull);
      expect(listLast(emptyList), isNull);
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
      expect(listTruncate([], 0), isEmpty);
      expect(listTruncate([], -1), isEmpty);
      expect(listTruncate([], 1), isEmpty);
      expect(listTruncate([1], 1), [1]);
      expect(listTruncate([1], 2), [1]);
      expect(listTruncate([1], 0), isEmpty);
      expect(listTruncate([1], -1), isEmpty);
      expect(listTruncate([1, 2], -1), isEmpty);
      expect(listTruncate([1, 2], 0), isEmpty);
      expect(listTruncate([1, 2], 1), [1]);
      expect(listTruncate([1, 2], 2), [1, 2]);
      expect(listTruncate([1, 2], 3), [1, 2]);
    });

    test('subList', () {
      expect(listSubList([], 0), isEmpty);
      expect(listSubList([], -1), isEmpty);
      expect(listSubList([], 1), isEmpty);
      expect(listSubList([1], 1), isEmpty);
      expect(listSubList([1], 2), isEmpty);
      expect(listSubList([1], 0), [1]);
      expect(listSubList([1], -1), [1]);
      expect(listSubList([1, 2], -1), [1, 2]);
      expect(listSubList([1, 2], 0), [1, 2]);
      expect(listSubList([1, 2], 1), [2]);
      expect(listSubList([1, 2], 2), isEmpty);
      expect(listSubList([1, 2], 3), isEmpty);
      expect(listSubList([1, 2], 1, 3), [2]);
      expect(listSubList([1, 2], 1, 2), [2]);
      expect(listSubList([1, 2], 1, 1), isEmpty);
      expect(listSubList([1, 2], 1, -1), isEmpty);
    });

    test('asList', () {
      expect(asList<Object?>(null), isNull);
      expect(asList<Object?>(emptyList), isEmpty);
      expect(asList<Object?>(emptyMap), isNull);
      expect(asList<Object?>(1), isNull);
      expect(asList<Object?>([1]), [1]);
      expect(asList<String>([1]), isNull);
    });

    test('equals', () {
      expect(cloneList(emptyList), isEmpty);
      expect(identical(cloneList(emptyList), isEmpty), isFalse);

      var list1 = [1, emptyList, emptyMap];
      var listFrom = List<Object?>.from(list1);
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
      expect(listChunk([], null), isEmpty);
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
      expect(listSingleOrNull(emptyList), isNull);
      expect(listSingleOrNull([1]), 1);
      expect(listSingleOrNull(['test']), 'test');
      expect(listSingleOrNull(['test', 1]), isNull);
      expect(listSingleOrNull([null]), isNull);
      // handle iterable
      Iterable<int> iterable = [1];
      expect(listSingleOrNull(iterable), 1);
    });
    test('flatten', () {
      expect(
          (<Iterable>[
            [1],
            [2, 3]
          ].flatten()),
          [1, 2, 3]);
      expect(
          ([
            [1]
          ].flatten()),
          const TypeMatcher<List<int>>());
    });
    test('nonEmpty', () {
      List? nullList = emptyList;
      expect(nullList.nonEmpty(), isNull);
      nullList = null;
      expect(nullList?.nonEmpty(), isNull);
      nullList = [1];
      expect(nullList.nonEmpty(), [1]);
    });
    test('nonNull', () {
      List<int>? listOrNull;
      // ignore: omit_local_variable_types
      List<int> list = listOrNull.nonNull();
      // ignore: omit_local_variable_types
      List<String> stringList = (null as List<String>?).nonNull();
      expect(list, isEmpty);
      expect(stringList, isEmpty);
      expect([1].nonNull(), [1]);
    });
    test('getOrNull', () {
      expect(<Object>[].getOrNull(0), isNull);
      expect([1].getOrNull(0), 1);
      expect([1].getOrNull(-1), isNull);
      expect([1].getOrNull(1), isNull);
      expect([1, 2].getOrNull(1), 2);
    });
  });
}
