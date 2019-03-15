import 'size.dart' as size_common;

abstract class D2 implements size_common.D2<int> {}

class Size extends size_common.Size<int> implements D2 {
  Size(int width, int height) : super(width, height);
}

class Point extends size_common.Point<int> implements D2 {
  Point(int x, int y) : super(x, y);
}

class Rect extends size_common.Rect<int> {
  Rect(Point point, Size size) : super(point, size);
}

Size sizeContainedWithRatio(Size size, num ratio) {
  var _size = size_common.sizeIntContainedWithRatio(size, ratio);
  return Size(_size.width, _size.height);
}
