import 'dart:math';

/// Num extension
extension TekartikNumExt<T extends num> on T {
  /// Bounded value between a mix and a max
  ///
  /// maxValue is evaluated first.
  T bounded(T minValue, T maxValue) {
    return boundedMax(maxValue).boundedMin(minValue);
  }

  /// Min bounded value
  T boundedMin(T minValue) {
    return max(minValue, this);
  }

  /// Max bounded value
  T boundedMax(T maxValue) {
    return min(maxValue, this);
  }
}

/// never fails
/// [value] could be a num or a String
num? parseNum(Object? value, [num? defaultValue]) {
  if (value is num) {
    return value;
  } else if (value is String) {
    var numValue = num.tryParse(value);
    if (numValue != null) {
      return numValue;
    }
  }
  return defaultValue;
}
