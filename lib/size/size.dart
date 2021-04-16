export 'dart:math' show Point;

/// Generic 2D value
abstract class D2<T extends num> {
  final T x;
  final T y;

  @override
  int get hashCode => ((x ?? 0) * 17 + (y ?? 0)).toInt();

  @override
  bool operator ==(other) {
    if (other is D2<T>) {
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

/// Generic point definition
class Point<T extends num> extends D2<T> {
  const Point(T x, T y) : super(x, y);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    return other is Point<T> && super == (other);
  }
}

/// A rectangle has a top left point and a size
class Rect<T extends num> {
  /// top left point
  final Point<T> point;

  /// Rectangle size
  final Size<T> size;

  /// Create a rectangle with a given point and size
  const Rect(this.point, this.size);

  /// left
  T get left => point.x;

  /// right
  T get right =>
      // ignore: unnecessary_cast
      (point.x + size.width) as T;

  /// top
  T get top => point.y;

  /// bottom
  T get bottom =>
      // ignore: unnecessary_cast
      (point.y + size.height) as T;

  /// width
  T get width => size.width;

  /// height
  T get height => size.height;

  @override
  int get hashCode => ((point?.hashCode ?? 0) << 16) | (size.hashCode ?? 0);

  @override
  bool operator ==(other) {
    return other is Rect && point == other.point && size == other.size;
  }

  @override
  String toString() {
    return '$point ($size)';
  }
}

/// Generic size
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
    return other is Size<T> && super == (other);
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

Rect<int> sizeIntCenteredRectWithRatio(Size<int> size, num ratio) {
  var innerSize = sizeIntContainedWithRatio(size, ratio);
  return Rect<int>(
      Point<int>((size.width - innerSize.width) ~/ 2,
          (size.height - innerSize.height) ~/ 2),
      innerSize);
}
