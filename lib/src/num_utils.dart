import 'dart:math';

/// Num extension
extension TekartikNumExt<T extends num> on T {
  /// Bounded value between a mix and a max
  ///
  /// maxValue is evaluated first.
  T bounded(T minValue, T maxValue) {
    return max(minValue, min(maxValue, this));
  }
}

/// never fails
/// [value] could be a num or a String
num? parseNum(dynamic value, [num? defaultValue]) {
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
