library map_utils_tests;

import 'package:test/test.dart';
import 'package:tekartik_common_utils/map_utils.dart';

main() {
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
  });
}
