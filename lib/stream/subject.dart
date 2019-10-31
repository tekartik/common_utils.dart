import 'dart:async';

abstract class StreamWithValue<T> extends Stream<T> {
  T get value;
}

class Subject<T> extends Stream<T>
    implements StreamSink<T>, StreamController<T>, StreamWithValue<T> {
  final StreamController<T> _controller;
  final bool _sync;

  /// _seeded is set to true if needed when a value is added
  bool _seeded;
  @override
  T get value => _value;
  T _value;

  // Error
  Object _error;
  StackTrace stackTrace;

  bool _addStreamActive = false;

  /// Seed value even if null
  Subject.seeded({T value, void onListen(), void onCancel(), bool sync})
      : this._(
            value: value,
            seeded: true,
            onListen: onListen,
            onCancel: onCancel,
            sync: sync);

  // Value is seeded if non null
  Subject._({T value, bool seeded, void onListen(), void onCancel(), bool sync})
      : _value = value,
        _seeded = seeded,
        _sync = sync == true,
        _controller = StreamController<T>.broadcast(
            onListen: onListen, onCancel: onCancel, sync: true);

  /// Create a subject, seeded if non null
  Subject({T value, void onListen(), void onCancel(), bool sync})
      : this._(
            value: value,
            seeded: value != null,
            onListen: onListen,
            onCancel: onCancel,
            sync: sync);

  @override
  bool get isClosed => _controller.isClosed;

  @override
  void add(T data) {
    if (_addStreamActive) {
      throw StateError('cannot call add when addStream is active');
    }
    _add(data);
  }

  void _add(T data) {
    _error = null;
    _seeded = true;
    _value = data;
    _controller.add(data);
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    if (_addStreamActive) {
      throw StateError('cannot call addError when addStream is active');
    }
    _addError(error, stackTrace);
  }

  void _addError(Object error, [StackTrace stackTrace]) {
    _value = null;
    this._error = error;
    this.stackTrace = stackTrace;
    _controller.addError(error, stackTrace);
  }

  @override
  Future close() {
    if (_addStreamActive) {
      throw StateError('cannot call close when addStream is active');
    }
    return _close();
  }

  Future _close() {
    return _controller.close();
  }

  @override
  Stream<T> get stream => this;

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    var _subscriptionController = StreamController<T>(sync: _sync);
    var _internalSubscription = _controller.stream.listen((T event) {
      _subscriptionController.add(event);
    }, onDone: () {
      _subscriptionController.close();
    }, onError: (error, [StackTrace stackTrace]) {
      _subscriptionController.addError(error, stackTrace);
    });
    _subscriptionController.onCancel = () {
      _internalSubscription?.cancel();
    };

    var subscription = _subscriptionController.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);

    // Send initial data
    if (_error != null) {
      _subscriptionController.addError(_error, stackTrace);
    } else {
      if (_seeded) {
        _subscriptionController.add(value);
      }
    }
    return subscription;
  }

  @override
  Future get done => _controller.sink.done;

  @override
  ControllerCallback get onPause =>
      throw UnsupportedError("Subjects do not support pause callbacks");

  @override
  set onPause(void onPauseHandler()) =>
      throw UnsupportedError("Subjects do not support pause callbacks");

  @override
  ControllerCallback get onResume =>
      throw UnsupportedError("Subjects do not support resume callbacks");

  @override
  set onResume(void onResumeHandler()) =>
      throw UnsupportedError("Subjects do not support resume callbacks");

  @override
  ControllerCancelCallback get onCancel => _controller.onCancel;

  @override
  set onCancel(void onCancelHandler()) {
    _controller.onCancel = onCancelHandler;
  }

  @override
  bool get isPaused => _controller.isPaused;

  @override
  Future addStream(Stream<T> source, {bool cancelOnError}) {
    if (_addStreamActive) {
      throw StateError('addStream active');
    }
    _addStreamActive = true;
    var completer = Completer.sync();
    StreamSubscription<T> subscription;

    subscription = source.listen((T event) {
      _add(event);
    }, onError: (Object error, [StackTrace stackTrace]) {
      _addError(error, stackTrace);
      if (cancelOnError == true) {
        if (subscription != null) {
          subscription.cancel().then((_) {
            _addStreamActive = false;
            completer.completeError(error, stackTrace);
          });
          subscription = null;
        }
      }
    }, onDone: () {
      if (subscription != null) {
        subscription.cancel().then((_) {
          _addStreamActive = false;
          completer.complete();
        });
        subscription = null;
      }
    }, cancelOnError: cancelOnError);
    return completer.future;
  }

  @override
  bool get hasListener => _controller.hasListener;

  @override
  StreamSink<T> get sink => this;

  @override
  ControllerCallback get onListen => _controller.onListen;

  @override
  set onListen(void onListenHandler()) {
    _controller.onListen = onListenHandler;
  }

  @override
  String toString() {
    return 'Subject<$T>($value)';
  }
}
