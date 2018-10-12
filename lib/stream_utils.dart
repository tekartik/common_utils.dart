import 'dart:async';

class Subject<T> extends Stream<T>
    implements StreamSink<T>, StreamController<T> {
  final StreamController<T> _controller;
  final bool sync;
  T value;

  // Error
  Object error;
  StackTrace stackTrace;

  bool _addStreamActive = false;

  Subject({this.value, void onListen(), void onCancel(), bool sync})
      : this.sync = sync == true,
        this._controller = StreamController<T>.broadcast(
            onListen: onListen, onCancel: onCancel, sync: true) {}

  bool get isClosed => _controller.isClosed;

  @override
  void add(T data) {
    if (_addStreamActive) {
      throw StateError('cannot call add when addStream is active');
    }
    _add(data);
  }

  void _add(T data) {
    error = null;
    if (data != value) {
      value = data;
      _controller.add(data);
    }
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    if (_addStreamActive) {
      throw StateError('cannot call addError when addStream is active');
    }
    _addError(error, stackTrace);
  }

  void _addError(Object error, [StackTrace stackTrace]) {
    value = null;
    this.error = error;
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

  Stream<T> get stream => this;

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    var _subscriptionController = StreamController<T>(sync: sync);
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
    if (error != null) {
      _subscriptionController.addError(error, stackTrace);
    } else {
      _subscriptionController.add(value);
    }
    return subscription;
  }

  @override
  Future get done => _controller.sink.done;

  @override
  ControllerCallback get onPause =>
      throw new UnsupportedError("Subjects do not support pause callbacks");

  @override
  set onPause(void onPauseHandler()) =>
      throw new UnsupportedError("Subjects do not support pause callbacks");

  @override
  ControllerCallback get onResume =>
      throw new UnsupportedError("Subjects do not support resume callbacks");

  @override
  set onResume(void onResumeHandler()) =>
      throw new UnsupportedError("Subjects do not support resume callbacks");

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
