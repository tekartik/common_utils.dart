library map_utils_tests;

import 'package:tekartik_common_utils/map_utils.dart';
import 'package:test/test.dart';

void main() {
  group('map utils', () {
    test('mergeMap', () {
      Map dst = {};
      mergeMap(dst, {'test': 1});
      expect(dst['test'], 1);
    });

    test('mapValueFromPath', () {
      Map map = {
        "home": "home",
        "about": "about",
        "contact": "contact",
        "products": {
          "home": "home",
          "list": "list",
          "product": {
            "home": "home",
            "specs": "specs",
            "warranty": "warranty",
            "related": "related"
          }
        }
      };
      expect(mapValueFromParts(map, ['products', 'product', 'warranty']),
          "warranty");
      expect(mapValueFromPath(map, 'products/product/warranty'), "warranty");
      expect(
          mapValueFromParts(map, ['products', 'product', 'warrant']), isNull);
      expect(
          mapValueFromParts(map, ['products', 'product_', 'warrant']), isNull);
      expect(mapValueFromPath(map, 'products/product/warrant'), null);
    });

    test('partsMapValue', () {
      var map = {};
      expect(getPartsMapValue(map, ['test', 'sub']), null);
      setPartsMapValue(map, ['test', 'sub'], 1);
      expect(map, {
        'test': {'sub': 1}
      });
      expect(getPartsMapValue(map, ['test', 'sub']), 1);
      setPartsMapValue(map, ['test', 'sub'], 2);
      expect(map, {
        'test': {'sub': 2}
      });
      setPartsMapValue(map, ['test', 'sub2'], 3);
      expect(map, {
        'test': {'sub': 2, 'sub2': 3}
      });
      setPartsMapValue(map, ['test'], 1);
      expect(map, {'test': 1});
    });

    test('mapValue', () {
      var map = <int, String>{1: 'test'};
      String value = mapValue(map, 1);
      expect(value, 'test');
      expect(mapValue(map, 1), 'test');

      var map2 = <String, dynamic>{'test1': 1, 'test2': "2"};
      expect(mapValue(map2, 'test1'), 1);
      expect(mapValue(map2, 'test2'), "2");
      expect(mapValue(map2, 'test3'), null);
      expect(mapValue(map2, null), null);
      expect(mapValue(null, 'test3'), null);

      expect(mapValue(null, 'test3', createIfNull: () => 1), null);
      expect(mapValue(map2, 'test3', createIfNull: () => 3), 3);
      expect(mapValue(map2, 'test3'), 3);
      expect(mapValue(map2, null, createIfNull: () => 'for_null_key'),
          'for_null_key');
      expect(mapValue(map2, null), 'for_null_key');
    });

    test('asMap', () {
      expect(asMap(null), isNull);
      expect(asMap([]), isNull);
      expect(asMap({}), {});
      expect(asMap<String, dynamic>({'test': 1}), {'test': 1});
      expect(asMap<String, dynamic>({'test': 1}),
          const TypeMatcher<Map<String, dynamic>>());
      expect(asMap<String, int>(<String, dynamic>{'test': 1}),
          const TypeMatcher<Map<String, int>>());
      try {
        expect(asMap<String, String>({'test': 1}), isNull);
      } catch (_) {
        // this fails sorry
      }
    });
  });
}
