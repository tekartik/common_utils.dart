/// Returns the maximum of two values.
T comparableMax<T extends Comparable>(T a, T b) {
  if (a.compareTo(b) < 0) {
    return b;
  } else {
    return a;
  }
}

/// Returns the minimum of two values.
T comparableMin<T extends Comparable>(T a, T b) {
  if (a.compareTo(b) < 0) {
    return a;
  } else {
    return b;
  }
}

/// Comparable extension
extension TekartikComparableBoundedExt<T extends Comparable> on T {
  /// Bounded value between a mix and a max
  ///
  /// maxValue is evaluated first.
  T bounded(T minValue, T maxValue) {
    return boundedMax(maxValue).boundedMin(minValue);
  }

  /// Min bounded value (i.e. take the max of the two values)
  T boundedMin(T minValue) {
    return comparableMax(minValue, this);
  }

  /// Max bounded value (i.e. take the min of the two values)
  T boundedMax(T maxValue) {
    return comparableMin(maxValue, this);
  }
}
