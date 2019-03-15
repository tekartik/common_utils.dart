export 'dart:math' show Point;

abstract class D2<T extends num> {
  final T x;
  final T y;

  @override
  int get hashCode => ((x ?? 0) * 17 + (y ?? 0)).toInt();

  @override
  bool operator ==(other) {
    if (other is D2) {
      return (other.x == x && other.y == y);
    }
    return false;
  }

  const D2(this.x, this.y);

  // x / y ratio
  num get ratio => x / y;

  @override
  String toString() => '${x}x$y';
}

class Point<T extends num> extends D2<T> {
  const Point(T x, T y) : super(x, y);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return other is Point && super == (other);
  }
}

class Rect<T extends num> {
  final Point<T> point;
  final Size<T> size;

  Rect(this.point, this.size);
  @override
  String toString() {
    return '$point ($size)';
  }
}

class Size<T extends num> extends D2<T> {
  T get width => x;
  T get height => y;

  bool get isAnyEmpty => x == 0 || y == 0;

  bool get isEmpty => x == 0 && y == 0;

  const Size(T width, T height) : super(width, height);
  // const Size.empty() : super(0, 0);
  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return other is Size && super == (other);
  }

  bool get isLandscape => width > height;
  bool get isPortrait => !isLandscape;
}

Size<int> sizeIntContainedWithRatio(Size<int> size, num ratio) {
  var sizeRatio = size.ratio;
  if (sizeRatio > ratio) {
    return Size((size.height * ratio).toInt(), size.height);
  } else if (sizeRatio < ratio) {
    return Size(size.width, size.width ~/ ratio);
  }
  return size;
}
