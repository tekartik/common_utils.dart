// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/pack/pack.dart';
import 'package:tekartik_common_utils/pack/pack.dart' as pack;
import 'package:test/test.dart';

import '../list_utils_test.dart';
import '../map_utils_test.dart';

void main() {
  group('json_pack', () {
    test('pack', () {
      expect(packList(null), isNull);
      expect(packList([]), {'columns': emptyList, 'rows': emptyList});
      expect(
          packList([
            {'field1': 'text1', 'field2': 123456}
          ]),
          {
            'columns': ['field1', 'field2'],
            'rows': [
              ['text1', 123456]
            ]
          });
      expect(
          packList([
            {'field1': 'text1', 'field2': 123456},
            {'field3': 'text3', 'field2': 789, 'field4': null}
          ]),
          {
            'columns': ['field1', 'field2', 'field3', 'field4'],
            'rows': [
              ['text1', 123456, null, null],
              [null, 789, 'text3', null]
            ]
          });
    });

    test('compack', () {
      expect(compackAny(null), isNull);
      expect(compackAny(emptyList), isEmpty);
      expect(
          compackAny([
            {'field1': 'text1', 'field2': 123456}
          ]),
          [
            {'field1': 'text1', 'field2': 123456}
          ]);

      expect(compackAny({r'$c': 1}), {r'$c': 1});
      expect(compackAny({r'$r': 1}), {r'$r': 1});
      expect(
          compackAny({r'$c': 1, r'$r': 2}), {r'$c': 1, r'$r': 2, r'$v': true});
      expect(compackAny({r'$c': 1, r'$r': 2, r'$v': true}),
          {r'$c': 1, r'$r': 2, r'$v': true, r'$v$v': true});
      expect(
          compackAny([
            {r'$c': 1, r'$r': 2}
          ]),
          [
            {r'$c': 1, r'$r': 2, r'$v': true}
          ]);
      expect(
          compackAny([
            {'field2': 'text2'},
            {'field1': 'text1'}
          ]),
          {
            r'$c': ['field1', 'field2'],
            r'$r': [
              [null, 'text2'],
              ['text1', null]
            ]
          });
      expect(
          compackAny([
            {'field1': 'text1', 'field2': 123456},
            {'field3': 'text3', 'field2': 789, 'field4': null}
          ]),
          {
            r'$c': ['field1', 'field2', 'field3', 'field4'],
            r'$r': [
              ['text1', 123456, null, null],
              [null, 789, 'text3', null]
            ]
          });

      expect(
          compackAny({
            'test': [
              {'field1': 'text1', 'field2': 123456},
              {'field3': 'text3', 'field2': 789, 'field4': null}
            ]
          }),
          {
            'test': {
              r'$c': ['field1', 'field2', 'field3', 'field4'],
              r'$r': [
                ['text1', 123456, null, null],
                [null, 789, 'text3', null]
              ]
            }
          });
    });

    test('uncompack', () {
      dynamic uncompackAny(dynamic packed) {
        // devPrint(jsonEncode(packed));
        return pack.uncompackAny(packed);
      }

      expect(uncompackAny(null), isNull);
      expect(uncompackAny(emptyList), isEmpty);
      expect(uncompackAny(emptyMap), emptyMap);
      expect(uncompackAny(1), 1);
      expect(uncompackAny(true), true);
      expect(uncompackAny(emptyList), const TypeMatcher<List>());
      expect(
          uncompackAny([
            {'field1': 'text1', 'field2': 123456}
          ]),
          [
            {'field1': 'text1', 'field2': 123456}
          ]);
      expect(
          uncompackAny({
            r'$c': ['field'],
            r'$r': [
              ['value']
            ]
          }),
          [
            {'field': 'value'}
          ],
          reason: jsonEncode({
            r'$c': ['field'],
            r'$r': [
              ['value']
            ]
          }));
      expect(
          uncompackAny({
            r'$c': ['field1', 'field2', 'field3', 'field4'],
            r'$r': [
              ['text1', 123456, null, null],
              [null, 789, 'text3', null]
            ]
          }),
          [
            {'field1': 'text1', 'field2': 123456},
            {'field3': 'text3', 'field2': 789}
          ]);
      expect(uncompackAny({r'$c': 1}), {r'$c': 1});
      expect(uncompackAny({r'$r': 1}), {r'$r': 1});
      expect(uncompackAny({r'$v': 1}), {r'$v': 1});
      expect(uncompackAny({r'$c': 1, r'$r': 2, r'$v': true}),
          {r'$c': 1, r'$r': 2});
      expect(
          uncompackAny([
            {r'$c': 1, r'$r': 2, r'$v': true}
          ]),
          [
            {r'$c': 1, r'$r': 2}
          ]);
      expect(
          uncompackAny([
            {r'$c': 1, r'$r': 2, r'$v': true, r'$v$v': true}
          ]),
          [
            {r'$c': 1, r'$r': 2, r'$v': true}
          ]);
      expect(
        uncompackAny({
          'test': {
            r'$c': ['field1', 'field2', 'field3', 'field4'],
            r'$r': [
              ['text1', 123456, null, null],
              [null, 789, 'text3', null]
            ]
          }
        }),
        {
          'test': [
            {'field1': 'text1', 'field2': 123456},
            {'field3': 'text3', 'field2': 789}
          ]
        },
      );
    });

    void loop(dynamic unpacked) {
      var packed = compackAny(unpacked);
      var unpackResult = uncompackAny(packed);
      // devPrint(jsonEncode(unpacked));
      // devPrint(jsonEncode(packed));
      expect(unpackResult, unpacked);
    }

    test('loop', () {
      loop(emptyMap);
      loop(1);
      loop(true);
      loop('text');
      loop(emptyList);
      loop({r'$c': 1, r'$r': 2});
      loop({r'$c': 1, r'$r': 2, r'$v': true});
      loop([
        {'a': 1},
        {
          'b': [
            {'a': 1},
            {'b': emptyList}
          ]
        }
      ]);
      //loop({r'$c': 1, r'$r': 2, r'$v1': true});
    });

    test('packItemList', () {
      expect(
          packItemList(<String>['1', '3'], (String item) {
            return {'item': item};
          }),
          {
            'columns': ['item'],
            'rows': [
              ['1'],
              ['3']
            ]
          });
    });

    test('json compack', () {
      void check(dynamic any) {
        var compack = compackAny(any);
        compack = json.decode(json.encode(compack));
        expect(uncompackAny(compack), any);
      }

      check(emptyList);
      check(emptyMap);
      check({
        'test': [
          {'field1': 'text1', 'field2': 123456},
          {'field3': 'text3', 'field2': 789}
        ]
      });
    });
    test('unpack', () {
      expect(unpackList(null), isNull);
      expect(unpackList({}), isNull);

      expect(unpackList({'columns': [], 'rows': []}), isEmpty);
      expect(
          unpackList({
            'columns': ['field1', 'field2'],
            'rows': [
              ['text1', 123456]
            ]
          }),
          [
            {'field1': 'text1', 'field2': 123456}
          ]);

      var packed1 = {
        'columns': ['field1', 'field2', 'field3', 'field4'],
        'rows': [
          ['text1', 123456, null, null],
          [null, 789, 'text3', null]
        ]
      };
      var unpack = JsonUnpack(packed1);
      var count = 0;
      unpack.forEach((Map map) {
        if (count == 0) {
          expect(map['field1'], 'text1');
        }
        count++;
      });
      expect(count, 2);
      expect(unpackList(packed1), [
        {'field1': 'text1', 'field2': 123456},
        {'field3': 'text3', 'field2': 789}
      ]);
    });
  });
}
