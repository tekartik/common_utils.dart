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
      expect(const Size(1, 2), const Size<int>(1, 2));
      expect(const Size(1.0, 2.0), const Size<double>(1, 2));
      expect(const Size<int>(1, 2), isNot(const Size<double>(1, 2)));
      expect(const Point(1.0, 2.0), const Point<double>(1, 2));
      expect(const Point<int>(1, 2), isNot(const Point<double>(1, 2)));
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

    group('rect', () {
      test('equals', () {
        expect(const Rect<int>(Point(1, 2), Size(3, 4)),
            const Rect(Point(1, 2), Size(3, 4)));
        expect(const Rect<num>(Point(1, 2), Size(3, 4)),
            const Rect(Point<num>(1, 2), Size<num>(3, 4)));
      });
    });
  });
}
