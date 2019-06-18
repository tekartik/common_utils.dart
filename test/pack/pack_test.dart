// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:test/test.dart';
import 'package:tekartik_common_utils/pack/pack.dart';

void main() {
  group('json_pack', () {
    test('pack', () {
      expect(packList(null), isNull);
      expect(packList([]), {'columns': [], 'rows': []});
      expect(
          packList([
            {"field1": "text1", "field2": 123456}
          ]),
          {
            'columns': ['field1', 'field2'],
            'rows': [
              ['text1', 123456]
            ]
          });
      expect(
          packList([
            {"field1": "text1", "field2": 123456},
            {"field3": "text3", "field2": 789, "field4": null}
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
      expect(compackAny([]), []);
      expect(
          compackAny([
            {"field1": "text1", "field2": 123456}
          ]),
          [
            {"field1": "text1", "field2": 123456}
          ]);
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
            {"field1": "text1", "field2": 123456},
            {"field3": "text3", "field2": 789, "field4": null}
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
              {"field1": "text1", "field2": 123456},
              {"field3": "text3", "field2": 789, "field4": null}
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
      expect(uncompackAny(null), isNull);
      expect(uncompackAny([]), []);
      expect(uncompackAny([]), const TypeMatcher<List>());
      expect(
          uncompackAny([
            {"field1": "text1", "field2": 123456}
          ]),
          [
            {"field1": "text1", "field2": 123456}
          ]);
      expect(
          uncompackAny({
            r'$c': ['field1', 'field2', 'field3', 'field4'],
            r'$r': [
              ['text1', 123456, null, null],
              [null, 789, 'text3', null]
            ]
          }),
          [
            {"field1": "text1", "field2": 123456},
            {"field3": "text3", "field2": 789}
          ]);
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
            {"field1": "text1", "field2": 123456},
            {"field3": "text3", "field2": 789}
          ]
        },
      );
    });

    test("packItemList", () {
      expect(
          packItemList(<String>["1", "3"], (String item) {
            return {"item": item};
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
      void _check(dynamic any) {
        var compack = compackAny(any);
        compack = json.decode(json.encode(compack));
        expect(uncompackAny(compack), any);
      }

      _check([]);
      _check({});
      _check({
        'test': [
          {"field1": "text1", "field2": 123456},
          {"field3": "text3", "field2": 789}
        ]
      });
    });
    test('unpack', () {
      expect(unpackList(null), isNull);
      expect(unpackList({}), isNull);

      expect(unpackList({'columns': [], 'rows': []}), []);
      expect(
          unpackList({
            'columns': ['field1', 'field2'],
            'rows': [
              ['text1', 123456]
            ]
          }),
          [
            {"field1": "text1", "field2": 123456}
          ]);

      var packed1 = {
        'columns': ['field1', 'field2', 'field3', 'field4'],
        'rows': [
          ['text1', 123456, null, null],
          [null, 789, 'text3', null]
        ]
      };
      JsonUnpack unpack = JsonUnpack(packed1);
      int count = 0;
      unpack.forEach((Map map) {
        if (count == 0) {
          expect(map['field1'], "text1");
        }
        count++;
      });
      expect(count, 2);
      expect(unpackList(packed1), [
        {"field1": "text1", "field2": 123456},
        {"field3": "text3", "field2": 789}
      ]);
    });
  });
}
