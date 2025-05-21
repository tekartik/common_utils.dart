import 'package:tekartik_common_utils/size/int_size.dart';
import 'package:tekartik_common_utils/size/size.dart' as common;
import 'package:test/test.dart';

class My2D extends common.D2<int> {
  const My2D(super.x, super.y);
}

class MySize extends common.Size<int> {
  const MySize(super.width, super.height);
}

class MyPoint extends common.Point<int> {
  const MyPoint(super.x, super.y);
}

class MyRect extends common.Rect<int> {
  const MyRect(super.point, super.size);
}

void main() {
  group('int_size', () {
    group('size', () {
      test('equals', () {
        expect(const common.Size<num>(1, 2), isNot(const Size(1, 2)));
        expect(const common.Size<int>(1, 2), const Size(1, 2));
        expect(const My2D(1, 2), const Size(1, 2));
        expect(const MySize(1, 2), const Size(1, 2));
      });
      test('from', () {
        expect(Size.from(const My2D(1, 2)), const Size(1, 2));
      });
    });
    group('point', () {
      test('equals', () {
        expect(const common.Point<num>(1, 2), isNot(const Point(1, 2)));
        expect(const common.Point<int>(1, 2), const Point(1, 2));
        expect(const My2D(1, 2), const Point(1, 2));
        expect(const Point(1, 2), const My2D(1, 2));
        expect(const MyPoint(1, 2), const My2D(1, 2));
      });

      test('from', () {
        expect(Point.from(const My2D(1, 2)), const Point(1, 2));
      });
    });
    group('rect', () {
      test('equals', () {
        expect(
          const common.Rect<num>(
            common.Point<num>(1, 2),
            common.Size<num>(3, 4),
          ),
          isNot(const Rect(Point(1, 2), Size(3, 4))),
        );
        expect(
          const common.Rect<int>(
            common.Point<int>(1, 2),
            common.Size<int>(3, 4),
          ),
          const Rect(Point(1, 2), Size(3, 4)),
        );
        expect(
          const MyRect(MyPoint(1, 2), MySize(3, 4)),
          const Rect(Point(1, 2), Size(3, 4)),
        );
      });
      test('Rect', () {
        var rct = const Rect(Point(1, 2), Size(3, 4));
        expect(Rect.fromLTWH(1, 2, 3, 4), rct);
        expect(
          const common.Rect<int>(
            common.Point<int>(1, 2),
            common.Size<int>(3, 4),
          ),
          rct,
        );
        expect(
          const Rect(common.Point<int>(1, 2), common.Size<int>(3, 4)),
          rct,
        );

        expect(rct.left, 1);
        expect(rct.top, 2);
        expect(rct.right, 4);
        expect(rct.bottom, 6);
        expect(rct.width, 3);
        expect(rct.height, 4);

        expect(Rect.fromLTRB(1, 2, 4, 6), rct);
      });
      test('stringParseSize', () {
        expect(stringParseSize('1234'), isNull);
        expect(stringParseSize(''), isNull);
        expect(stringParseSize('x'), isNull);
        expect(stringParseSize('xx'), isNull);
        expect(stringParseSize('12x34'), const Size(12, 34));
        expect(stringParseSize('1_12x34_3x'), const Size(12, 34));
      });
    });
  });
}
