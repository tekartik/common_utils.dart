import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/queue/fifo.dart';

/*

class SimSubscription<T> {
  final int id;
  final StreamSubscription<T> _firestoreSubscription;
  final List<T> _list = [];

  void add(T data) {
    _list.add(data);
    if (completer != null) {
      completer.complete();
    }
  }

  bool cancelled = false;
  Completer<T> completer;

  Future<T> get next async {
    if (cancelled) {
      return null;
    }
    if (_list.isNotEmpty) {
      var data = _list.first;
      _list.removeAt(0);
      return data;
    }
    completer = Completer();
    await completer.future;
    return await next;
  }

  SimSubscription(this.id, this._firestoreSubscription);

  // Make sure to cancel the pending completer
  cancel() {
    cancelled = true;
    _firestoreSubscription.cancel();
    if (!completer.isCompleted) {
      completer.complete(null);
    }
  }
}

 */
abstract class StreamPollerNext<T> {
  T get event;
  bool get done;
}

class _StreamPollerNext<T> implements StreamPollerNext<T> {
  @override
  final T event;

  @override
  final bool done;

  _StreamPollerNext({T event, bool done})
      : done = done ?? false,
        event = event;
}

class StreamPoller<T> {
  StreamSubscription<T> _subscription;
  final bool _lastOnly;
  bool _done = false;
  Completer _completer;
  final _lock = Lock();
  final _events = Fifo<_StreamPollerNext<T>>();
  void _addEvent(T event) {
    if (_lastOnly) {
      _events.pop();
    }
    _events.push(_StreamPollerNext<T>(event: event));
    _triggetNext();
  }

  StreamPoller(Stream<T> stream, {bool lastOnly})
      : _lastOnly = lastOnly == true {
    _subscription = stream.listen(_addEvent, onDone: cancel);
  }

  // called after addAvent or cancel
  void _triggetNext() {
    // notiy next if needed
    if (_completer?.isCompleted == false) {
      _completer.complete();
    }
  }

  Future<StreamPollerNext<T>> getNext() async {
    if (_done) {
      return _StreamPollerNext(done: _done);
    }
    var next = _events.pop();
    if (next != null) {
      return next;
    }
    return await _lock.synchronized(() async {
      _completer = Completer.sync();
      await _completer.future;
      return await getNext();
    });
  }

// Make sure to cancel the pending completer
  Future cancel() async {
    _done = true;
    await _subscription.cancel();
    _triggetNext();
  }
}
