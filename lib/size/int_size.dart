import 'package:tekartik_common_utils/int_utils.dart';

import 'size.dart' as size_common;

/// 2 dimension interface
abstract interface class D2 implements size_common.D2<int> {}

/// Integer sizes
class Size extends size_common.Size<int> implements D2 {
  /// Create an int size with a given width & height
  const Size(super.width, super.height);

  /// Wrap if needed
  factory Size.from(size_common.D2<int> size) {
    if (size is Size) {
      return size;
    }
    return Size(size.x, size.y);
  }
}

/// Integer point
class Point extends size_common.Point<int> implements D2 {
  /// Create an int point with a given [x] and [y]
  const Point(super.x, super.y);

  /// Wrap if needed
  factory Point.from(size_common.D2<int> point) {
    if (point is Point) {
      return point;
    }
    return Point(point.x, point.y);
  }
}

/// Integer rectangle
class Rect extends size_common.Rect<int> {
  /// top left [point] and rectable [size]
  const Rect(super.point, super.size);

  /// Helper from left, top, width, height
  factory Rect.fromLTWH(int left, int top, int width, int height) {
    return Rect(Point(left, top), Size(width, height));
  }

  /// Construct a rectangle from its left, top, right, bottom
  factory Rect.fromLTRB(int left, int top, int right, int bottom) {
    return Rect(Point(left, top), Size(right - left, bottom - top));
  }
}

/// Return the contained rectangle
Size sizeContainedWithRatio(Size size, num ratio) {
  var computedSize = size_common.sizeIntContainedWithRatio(size, ratio);
  return Size(computedSize.width, computedSize.height);
}

/// Parse size like 123x456
Size? stringParseSize(String name) {
  var parts = name.split('x');
  if (parts.length > 1) {
    // Find height
    for (var i = parts.length - 1; i >= 1; i--) {
      var height = stringParseStartingInt(parts[i]);
      if (height != null) {
        // Find width
        var width = stringParseEndingInt(parts[i - 1]);
        if (width != null) {
          return Size(width, height);
        }
      }
    }
  }
  return null;
}
