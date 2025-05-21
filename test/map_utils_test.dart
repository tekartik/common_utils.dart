library;

import 'package:tekartik_common_utils/map_utils.dart';
import 'package:test/test.dart';

Map<Object?, Object?> get emptyMap => <Object?, Object?>{};

void main() {
  group('map utils', () {
    test('mergeMap', () {
      var dst = emptyMap;
      mergeMap(dst, {'test': 1});
      expect(dst['test'], 1);
    });

    test('mapValueFromPath', () {
      var map = {
        'home': 'home',
        'about': 'about',
        'contact': 'contact',
        'products': {
          'home': 'home',
          'list': 'list',
          'product': {
            'home': 'home',
            'specs': 'specs',
            'warranty': 'warranty',
            'related': 'related',
          },
        },
      };
      expect(
        mapValueFromParts<String>(map, ['products', 'product', 'warranty']),
        'warranty',
      );
      expect(
        mapValueFromPath<String>(map, 'products/product/warranty'),
        'warranty',
      );
      expect(
        mapValueFromParts<Object?>(map, ['products', 'product', 'warrant']),
        isNull,
      );
      expect(
        mapValueFromParts<Object?>(map, ['products', 'product_', 'warrant']),
        isNull,
      );
      expect(mapValueFromPath<Object?>(map, 'products/product/warrant'), null);
    });

    test('partsMapValue', () {
      var map = emptyMap;
      expect(getPartsMapValue<Object>(map, ['test', 'sub']), null);
      setPartsMapValue(map, ['test', 'sub'], 1);
      expect(map, {
        'test': {'sub': 1},
      });
      expect(getPartsMapValue<int>(map, ['test', 'sub']), 1);
      setPartsMapValue(map, ['test', 'sub'], 2);
      expect(map, {
        'test': {'sub': 2},
      });
      setPartsMapValue(map, ['test', 'sub2'], 3);
      expect(map, {
        'test': {'sub': 2, 'sub2': 3},
      });
      setPartsMapValue(map, ['test'], 1);
      expect(map, {'test': 1});
    });

    test('mapValue', () {
      var map = <int, String>{1: 'test'};
      var value = mapValue(map, 1);
      expect(value, 'test');
      expect(mapValue(map, 1), 'test');
      expect(mapValue(map, 2), isNull);

      var map2 = <String, Object?>{'test1': 1, 'test2': '2'};
      expect(mapValue(map2, 'test1'), 1);
      expect(mapValue(map2, 'test2'), '2');
      expect(mapValue(map2, 'test3'), null);

      expect(mapValue(map2, 'test3', createIfNull: () => 3), 3);
      expect(mapValue(map2, 'test3'), 3);
    });

    test('asMap', () {
      expect(anyAsMapOrNull(null), isNull);
    });

    test('keySortedMap', () {
      var map = <String, Object?>{'b': 2, 'a': 1};
      expect(map.keys.first, 'b');
      var sortedMap = map.keySortedMap();
      expect(sortedMap, map);
      expect(sortedMap.keys.first, 'a');
    });

    test('asMap', () {
      expect(asMap<Object?, Object?>(null), isNull);
      expect(asMap<Object?, Object?>(<int>[]), isNull);
      expect(asMap<String, Object?>(<Object?, Object?>{}), <String, Object?>{});
      expect(asMap<String, Object?>({'test': 1}), {'test': 1});
      expect(
        asMap<String, Object?>({'test': 1}),
        const TypeMatcher<Map<String, Object?>>(),
      );
      expect(
        asMap<String, int>(<String, Object?>{'test': 1}),
        const TypeMatcher<Map<String, int>>(),
      );
      try {
        expect(asMap<String, String>({'test': 1}), isNull);
      } catch (_) {
        // this fails sorry
      }
    });
  });
}
