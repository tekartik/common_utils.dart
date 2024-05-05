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

    group('rect', () {
      test('equals', () {
        expect(const Rect<int>(Point(1, 2), Size(3, 4)),
            const Rect(Point(1, 2), Size(3, 4)));
        expect(const Rect<num>(Point(1, 2), Size(3, 4)),
            const Rect(Point<num>(1, 2), Size<num>(3, 4)));
      });
    });

    group('utils', () {
      test('sizeIntContainedWithRatio', () {
        expect(
            sizeIntContainedWithRatio(const Size(1, 2), 1), const Size(1, 1));
        expect(
            sizeIntContainedWithRatio(const Size(3, 3), 1.5), const Size(3, 2));
        expect(
            sizeIntContainedWithRatio(const Size(3, 3), 0.7), const Size(2, 3));
      });
      test('sizeIntCenteredRectWithRatio', () {
        expect(sizeIntCenteredRectWithRatio(const Size(1, 2), 1),
            const Rect<int>(Point(0, 0), Size(1, 1)));

        expect(sizeIntCenteredRectWithRatio(const Size(3, 3), 1.5),
            const Rect<int>(Point(0, 0), Size(3, 2)));
        expect(sizeIntCenteredRectWithRatio(const Size(3, 3), 3),
            const Rect<int>(Point(0, 1), Size(3, 1)));
        expect(sizeIntCenteredRectWithRatio(const Size(3, 3), 0.7),
            const Rect<int>(Point(0, 0), Size(2, 3)));
        expect(sizeIntCenteredRectWithRatio(const Size(3, 3), 0.334),
            const Rect<int>(Point(1, 0), Size(1, 3)));
      });
      test('sizeDoubleContainedWithRatio', () {
        expect(sizeDoubleContainedWithRatio(const Size(1, 2), 1),
            const Size<double>(1, 1));
        expect(sizeDoubleContainedWithRatio(const Size(1.5, 2.5), 1),
            const Size<double>(1.5, 1.5));
        expect(sizeDoubleContainedWithRatio(const Size(3, 3), 1.5),
            const Size<double>(3, 2));
      });
      test('sizeDoubleCenteredRectWithRatio', () {
        expect(sizeDoubleCenteredRectWithRatio(const Size(1, 2), 1),
            const Rect<double>(Point(0.0, 0.5), Size(1, 1)));

        expect(sizeDoubleCenteredRectWithRatio(const Size(3, 3), 1.5),
            const Rect<double>(Point(0, 0.5), Size(3, 2)));
        expect(sizeDoubleCenteredRectWithRatio(const Size(3, 3), 3),
            const Rect<double>(Point(0, 1), Size(3, 1)));
      });
      test('sizeDoubleCenteredRectWithRatioMinMax', () {
        expect(sizeDoubleCenteredRectWithRatioMinMax(const Size(1, 2), 1, 2),
            const Rect<double>(Point(0.0, 0.5), Size(1, 1)));
        expect(sizeDoubleCenteredRectWithRatioMinMax(const Size(1, 2), 0.3, 2),
            const Rect<double>(Point(0.0, 0.0), Size(1, 2)));
        var rct =
            sizeDoubleCenteredRectWithRatioMinMax(const Size(1, 2), 0.6, 2);
        expect(rct.left, closeTo(0.0, 0.001));
        expect(rct.top, closeTo(0.166, 0.001));
        expect(rct.width, closeTo(1.0, 0.001));
        expect(rct.height, closeTo(1.666, 0.001));
        rct = sizeDoubleCenteredRectWithRatioMinMax(const Size(1, 2), 0.1, 0.4);
        expect(rct.left, closeTo(0.1, 0.001));
        expect(rct.top, closeTo(0.0, 0.001));
        expect(rct.width, closeTo(0.8, 0.001));
        expect(rct.height, closeTo(2.0, 0.001));
      });
    });
  });
}
