library;

import 'package:tekartik_common_utils/src/log_format_impl.dart';
import 'package:test/test.dart';

Object? anyToJsAny(Object? any) => logFormatConvert(any);

void main() {
  group('log_format', () {
    test('logFormatConvert', () {
      expect(logFormatConvert(null), isNull);
      expect(logFormatConvert(1), 1);
      var list = [1];
      expect(logFormatConvert([1]), list);
      expect(logFormatConvert(logFormatConvert(list)), list);
      expect(logFormatConvert(list), list);
      var map = <String, Object?>{'test': 1};
      expect(logFormatConvert(map), map);
      map = {
        'test': [1]
      };
      expect(logFormatConvert(map), map);

      final map1 = {'int': 1, 'string': 'text'};
      final list1 = [1, 'test', null, 1.1, map1];
      final map2 = {'map1': map1, 'list1': list1};

      final list2 = [list1, map2];
      expect(logFormatConvert(map2), map2);
      expect(logFormatConvert(list2, options: const LogFormatOptions()), list2);
    });

    test('asCollectionDepth', () {
      expect(logFormatConvert(null, options: const LogFormatOptions(depth: 0)),
          isNull);
      expect(logFormatConvert(1, options: const LogFormatOptions(depth: 0)), 1);
      expect(logFormatConvert(null, options: const LogFormatOptions(depth: 1)),
          isNull);

      var map1 = {'int': 1, 'string': 'text'};
      var list1 = [1, 'test', null, 1.1, map1];
      var map2 = {'map1': map1, 'list1': list1};
      var list2 = [list1, map2];
      expect(logFormatConvert(map2, options: const LogFormatOptions(depth: 0)),
          {'.': '.'});
      expect(logFormatConvert(list2, options: const LogFormatOptions(depth: 0)),
          ['..']);
      expect(
          logFormatConvert(map2, options: const LogFormatOptions(depth: 1)), {
        'map1': {'.': '.'},
        'list1': ['..']
      });
      expect(
          logFormatConvert(list2, options: const LogFormatOptions(depth: 1)), [
        ['..'],
        {'.': '.'}
      ]);
      expect(
          logFormatConvert(list2, options: const LogFormatOptions(depth: 1)), [
        ['..'],
        {'.': '.'}
      ]);
      expect(logFormat(list2, options: const LogFormatOptions(depth: 4)),
          '[[1, test, null, 1.1, {int: 1, string: text}], {map1: {int: 1, string: text}, list1: [1, test, null, 1.1, {int: 1, string: text}]}]');
      expect(
          logFormat(list2, options: const LogFormatOptions(depth: 2)),
          //'[[1, test, null, 1.1, {.: .}], {map1: {}, list1: [1, test, null, 1.1, {.: .}]}]');
          '[[1, test, null, 1.1, {.: .}], {map1: {.: .}, list1: [..]}]');
      expect(logFormat(list2, options: const LogFormatOptions(depth: 1)),
          '[[..], {.: .}]');
      expect(logFormat(map2, options: const LogFormatOptions(depth: 3)),
          '{map1: {int: 1, string: text}, list1: [1, test, null, 1.1, {int: 1, string: text}]}');
      expect(logFormat(map2, options: const LogFormatOptions(depth: 2)),
          '{map1: {int: 1, string: text}, list1: [1, test, null, 1.1, {.: .}]}');
      expect(logFormat(map2, options: const LogFormatOptions(depth: 1)),
          '{map1: {.: .}, list1: [..]}');
    });

    test('toDebugString', () {
      expect(logFormat(null), '<null>');
      expect(logFormat('null'), 'null');
      expect(logFormat(<String, Object?>{}), '{}');
      expect(logFormat(<int>[]), '[]');
    });
  });
}
