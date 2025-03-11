import 'dart:async';
export 'stream_join_gen.dart';

/// Join item for [streamJoinAllOrError ]
class StreamJoinItem<T> {
  /// The value
  final T? value;

  /// The error
  final Object? error;

  /// Constructor
  StreamJoinItem({this.value, this.error}) {
    // Value can be null!
    // assert(value != null || error != null);
  }

  /// Cast
  StreamJoinItem<R> cast<R>() {
    if (this is StreamJoinItem<R>) {
      return this as StreamJoinItem<R>;
    }
    return StreamJoinItem<R>(value: value as R, error: error);
  }

  @override
  int get hashCode {
    return value?.hashCode ?? error?.hashCode ?? 0;
  }

  @override
  bool operator ==(Object other) {
    if (other is StreamJoinItem) {
      return value == other.value && error == other.error;
    }
    return super == other;
  }

  @override
  String toString() {
    var sb = StringBuffer('Item(');
    if (error != null) {
      sb.write('error: $error');
    }
    if (error == null || value != null) {
      if (error != null) {
        sb.write(', ');
      }
      sb.write('${value ?? '<null>'}');
    }
    sb.write(')');
    return sb.toString();
  }
}

/// Join all streams into one. First emit when all values are received once.
Stream<List<T>> streamJoinAll<T>(List<Stream<T>> streams) {
  late StreamController<List<T>> controller;
  controller = StreamController<List<T>>(
      sync: true,
      onListen: () {
        var filled = streams.map((e) => false).toList();
        var done = streams.map((e) => false).toList();
        var values = streams.map<T?>((e) => null).toList();

        var allFilled = false;
        var subscriptions = <StreamSubscription>[];
        for (var i = 0; i < streams.length; i++) {
          var index = i;
          var stream = streams[i];
          subscriptions.add(stream.listen((event) {
            if (!allFilled) {
              filled[index] = true;
              allFilled = filled.every((e) => e);
            }
            values[index] = event;
            if (allFilled) {
              controller.add(List<T>.from(values));
            }
          }, onDone: () {
            done[index] = true;

            subscriptions[index].cancel();
            var allDone = done.every((e) => e);

            if (allDone) {
              controller.close();
            }
          }));
        }
        controller.onCancel = () {
          for (var subscription in subscriptions) {
            subscription.cancel();
          }
        };
      });
  return controller.stream;
}

/// Join all streams into one. First emit when all values are received once.
Stream<List<StreamJoinItem<T>>> streamJoinAllOrError<T>(
    List<Stream<T>> streams) {
  late StreamController<List<StreamJoinItem<T>>> controller;
  controller = StreamController<List<StreamJoinItem<T>>>(
      sync: true,
      onListen: () {
        var filled = streams.map((e) => false).toList();
        var done = streams.map((e) => false).toList();
        var values = streams.map<StreamJoinItem<T>?>((e) => null).toList();

        var allFilled = false;
        var subscriptions = <StreamSubscription>[];
        void addItem(int index, StreamJoinItem<T> item) {
          if (!allFilled) {
            filled[index] = true;
            allFilled = filled.every((e) => e);
          }
          values[index] = item;
          if (allFilled) {
            controller.add(List<StreamJoinItem<T>>.from(values));
          }
        }

        for (var i = 0; i < streams.length; i++) {
          var index = i;
          var stream = streams[i];
          subscriptions.add(stream.listen((event) {
            addItem(index, StreamJoinItem<T>(value: event));
          }, onDone: () {
            done[index] = true;

            subscriptions[index].cancel();
            var allDone = done.every((e) => e);

            if (allDone) {
              controller.close();
            }
          }, onError: (Object error) {
            addItem(index, StreamJoinItem<T>(error: error));
          }));
        }
        controller.onCancel = () {
          for (var subscription in subscriptions) {
            subscription.cancel();
          }
        };
      });
  return controller.stream;
}

/// Join 2 streams
Stream<(T1, T2)> streamJoin2<T1 extends Object?, T2 extends Object?>(
    Stream<T1> stream1, Stream<T2> stream2) {
  return streamJoinAll<Object?>([stream1, stream2])
      .map((event) => (event[0] as T1, event[1] as T2));
}

/// Join 3 streams
Stream<(T1, T2, T3)>
    streamJoin3<T1 extends Object?, T2 extends Object?, T3 extends Object?>(
        Stream<T1> stream1, Stream<T2> stream2, Stream<T3> stream3) {
  return streamJoinAll<Object?>([stream1, stream2, stream3])
      .map((event) => (event[0] as T1, event[1] as T2, event[2] as T3));
}

/// Join 4 streams
Stream<(T1, T2, T3, T4)> streamJoin4<T1 extends Object?, T2 extends Object?,
        T3 extends Object?, T4 extends Object?>(Stream<T1> stream1,
    Stream<T2> stream2, Stream<T3> stream3, Stream<T4> stream4) {
  return streamJoinAll<Object?>([stream1, stream2, stream3, stream4]).map(
      (event) =>
          (event[0] as T1, event[1] as T2, event[2] as T3, event[3] as T4));
}
