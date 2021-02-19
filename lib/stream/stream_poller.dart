import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/queue/fifo.dart';

abstract class StreamPollerEvent<T> {
  T get data;
  bool get done;
}

class _StreamPollerNext<T> implements StreamPollerEvent<T?> {
  @override
  final T? data;

  @override
  final bool done;

  _StreamPollerNext({T? event, bool? done})
      : done = done ?? false,
        data = event;
}

class StreamPoller<T> {
  late StreamSubscription<T> _subscription;
  final bool _lastOnly;
  bool _done = false;
  Completer? _completer;
  final _lock = Lock();
  final _events = Fifo<_StreamPollerNext<T>>();
  void _addEvent(T event) {
    if (_lastOnly) {
      _events.pop();
    }
    _events.push(_StreamPollerNext<T>(event: event));
    _triggetNext();
  }

  StreamPoller(Stream<T> stream, {bool? lastOnly})
      : _lastOnly = lastOnly == true {
    _subscription = stream.listen(_addEvent, onDone: cancel);
  }

  // called after addAvent or cancel
  void _triggetNext() {
    // notiy next if needed
    if (_completer?.isCompleted == false) {
      _completer!.complete();
    }
  }

  Future<StreamPollerEvent<T?>> getNext() async {
    var next = _events.pop();
    if (next != null) {
      return next;
    }
    if (_done) {
      return _StreamPollerNext(done: _done);
    }

    return await _lock.synchronized(() async {
      _completer = Completer.sync();
      await _completer!.future;
    }).then((_) async {
      return await getNext();
    } as FutureOr<StreamPollerEvent<T?>> Function(Null));
  }

// Make sure to cancel the pending completer
  Future cancel() async {
    _done = true;
    await _subscription.cancel();
    _triggetNext();
  }
}
