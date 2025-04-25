/// Adds extensions to num (ie. int & double) to make creating durations simple:
///
/// ```
/// 200.ms // equivalent to Duration(milliseconds: 200)
/// 3.seconds // equivalent to Duration(milliseconds: 3000)
/// 1.5.days // equivalent to Duration(hours: 36)
/// ```
extension TekartikNumDurationExtensions on num {
  /// Microseconds
  Duration get microseconds => Duration(microseconds: round());

  /// milliseconds
  Duration get ms => (this * 1000).microseconds;

  /// milliseconds
  Duration get milliseconds => (this * 1000).microseconds;

  /// seconds
  Duration get seconds => (this * 1000 * 1000).microseconds;

  /// minutes
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;

  /// hours
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;

  /// days
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;

  /// week
  Duration get weeks => (this * 1000 * 1000 * 60 * 60 * 24 * 7).microseconds;
}
