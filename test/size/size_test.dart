import 'package:tekartik_common_utils/size/size.dart';
import 'package:test/test.dart';

void main() {
  group('size', () {
    test('toString', () {
      expect(const Size(1, 2).toString(), '1x2');
    });
    test('equals', () {
      expect(const Size(1, 2), const Size(1, 2));
      expect(const Size(1, 2), isNot(const Size(1, 3)));
      expect(const Size(1, 2), isNot(const Size(2, 2)));
    });
    test('ratio', () {
      expect(const Size(1, 2).ratio, closeTo(0.5, 0.000001));
    });
    test('ratio', () {
      expect(const Size(1, 2).ratio, closeTo(0.5, 0.000001));
    });
    test('sizeIntContainedWithRatio', () {
      expect(sizeIntContainedWithRatio(const Size(1, 2), 1), const Size(1, 1));
      expect(
          sizeIntContainedWithRatio(const Size(3, 3), 1.5), const Size(3, 2));
      expect(
          sizeIntContainedWithRatio(const Size(3, 3), 0.7), const Size(2, 3));
    });
  });
}
