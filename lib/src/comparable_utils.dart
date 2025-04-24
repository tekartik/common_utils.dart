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

/// Helper for sorted list
extension TekartikComparableListExt<T extends Comparable> on List<T> {
  /// Finds the index at which [item] should be inserted into the sorted [list]
  /// to maintain the sorted order.
  ///
  /// The list must be sorted in ascending order according to the natural ordering
  /// of its elements (using `compareTo`).
  ///
  /// Args:
  ///   list: The sorted list of comparable items.
  ///   item: The comparable item to find the insertion index for.
  ///
  /// Returns:
  ///   The index where [item] should be inserted. This index `i` satisfies the
  ///   condition: all elements `list[j]` where `j < i` are less than or equal to
  ///   [item], and all elements `list[k]` where `k >= i` are greater than or equal
  ///   to [item].
  int findInsertionIndex(T item) {
    var list = this;

    // Initialize low and high pointers for binary search.
    // 'high' is set to list.length because the insertion point
    // could potentially be after the last element.
    var low = 0;
    var high = list.length;

    // Perform binary search until low meets high.
    while (low < high) {
      // Calculate the middle index.
      // Using integer division `~/` ensures we get an integer index
      // and helps prevent potential overflow compared to (low + high) ~/ 2.
      final mid = low + ((high - low) ~/ 2);

      // Compare the item with the element at the middle index.
      final comparison = item.compareTo(list[mid]);

      if (comparison > 0) {
        // If item is greater than the middle element,
        // the insertion point must be in the right half (excluding mid).
        low = mid + 1;
      } else {
        // If item is less than or equal to the middle element,
        // the insertion point could be 'mid' or in the left half.
        high = mid;
      }
    }

    // When the loop terminates (low == high), 'low' (or 'high')
    // is the correct insertion index.
    return low;
  }
}
