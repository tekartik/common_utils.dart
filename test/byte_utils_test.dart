import 'dart:typed_data';

import 'package:tekartik_common_utils/byte_utils.dart';
import 'package:test/test.dart';

void main() {
  group('byte_utils', () {
    test('asUint8List', () {
      var original = [1, 2, 3, 4];
      var list = asUint8List(original);
      expect(original, isNot(const TypeMatcher<Uint8List>()));
      expect(list, const TypeMatcher<Uint8List>());
      expect(identical(list, original), false);

      original = Uint8List.fromList([1, 2, 3, 4]);
      list = asUint8List(original);
      expect(original, const TypeMatcher<Uint8List>());
      expect(list, const TypeMatcher<Uint8List>());
      expect(identical(list, original), true);
    });
    test('listStreamGetBytes', () async {
      expect(
          await listStreamGetBytes(Stream.fromIterable([
            [1, 2],
            [3]
          ])),
          [1, 2, 3]);
    });
  });
}
