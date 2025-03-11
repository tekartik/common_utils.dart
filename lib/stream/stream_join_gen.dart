import 'dart:async';
import 'package:tekartik_common_utils/stream/stream_join.dart';

/// Common stream join items extension
extension StreamJoinItemList2Ext<T1 extends Object?, T2 extends Object?> on (
  StreamJoinItem<T1>,
  StreamJoinItem<T2>
) {
  /// item1
  StreamJoinItem<T1> get item1 => $1;

  /// item2
  StreamJoinItem<T2> get item2 => $2;

  /// Grouped values
  (T1?, T2?) get values {
    return (item1.value, item2.value);
  }
}

/// Join 2 streams or error
Stream<(StreamJoinItem<T1>, StreamJoinItem<T2>)>
    streamJoin2OrError<T1 extends Object?, T2 extends Object?>(
        Stream<T1> stream1, Stream<T2> stream2) {
  return streamJoinAllOrError<Object?>([stream1, stream2])
      .map((event) => (event[0].cast<T1>(), event[1].cast<T2>()));
}

/// Common stream join items extension
extension StreamJoinItemList3Ext<T1 extends Object?, T2 extends Object?,
    T3 extends Object?> on (
  StreamJoinItem<T1>,
  StreamJoinItem<T2>,
  StreamJoinItem<T3>
) {
  /// item1
  StreamJoinItem<T1> get item1 => $1;

  /// item2
  StreamJoinItem<T2> get item2 => $2;

  /// item3
  StreamJoinItem<T3> get item3 => $3;

  /// Grouped values
  (T1?, T2?, T3?) get values {
    return (item1.value, item2.value, item3.value);
  }
}

/// Join 3 streams or error
Stream<(StreamJoinItem<T1>, StreamJoinItem<T2>, StreamJoinItem<T3>)>
    streamJoin3OrError<T1 extends Object?, T2 extends Object?,
            T3 extends Object?>(
        Stream<T1> stream1, Stream<T2> stream2, Stream<T3> stream3) {
  return streamJoinAllOrError<Object?>([stream1, stream2, stream3]).map(
      (event) =>
          (event[0].cast<T1>(), event[1].cast<T2>(), event[2].cast<T3>()));
}

/// Common stream join items extension
extension StreamJoinItemList4Ext<T1 extends Object?, T2 extends Object?,
    T3 extends Object?, T4 extends Object?> on (
  StreamJoinItem<T1>,
  StreamJoinItem<T2>,
  StreamJoinItem<T3>,
  StreamJoinItem<T4>
) {
  /// item1
  StreamJoinItem<T1> get item1 => $1;

  /// item2
  StreamJoinItem<T2> get item2 => $2;

  /// item3
  StreamJoinItem<T3> get item3 => $3;

  /// item4
  StreamJoinItem<T4> get item4 => $4;

  /// Grouped values
  (T1?, T2?, T3?, T4?) get values {
    return (item1.value, item2.value, item3.value, item4.value);
  }
}

/// Join 4 streams or error
Stream<
    (
      StreamJoinItem<T1>,
      StreamJoinItem<T2>,
      StreamJoinItem<T3>,
      StreamJoinItem<T4>
    )> streamJoin4OrError<T1 extends Object?, T2 extends Object?,
        T3 extends Object?, T4 extends Object?>(Stream<T1> stream1,
    Stream<T2> stream2, Stream<T3> stream3, Stream<T4> stream4) {
  return streamJoinAllOrError<Object?>([stream1, stream2, stream3, stream4])
      .map((event) => (
            event[0].cast<T1>(),
            event[1].cast<T2>(),
            event[2].cast<T3>(),
            event[3].cast<T4>()
          ));
}
