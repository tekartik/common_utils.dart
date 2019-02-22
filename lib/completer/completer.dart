import 'dart:async';

/// Cancel exception thrown when cancelling a completer
class CancelException implements Exception {
  final String reason;

  CancelException(this.reason);

  @override
  String toString() {
    String result = "Request cancelled";
    if (reason != null) {
      result = "$result due to: $reason";
    }
    return result;
  }
}

/// A completer that can be cancelled and with value that could be accessed
/// immediately.
class CancellableCompleter<T> {
  final Completer<T> _completer;
  bool _isCancelled = false;

  /// Only completed immediately if value is not null
  CancellableCompleter({bool sync, T value})
      : _completer = sync == true ? Completer.sync() : Completer<T>() {
    if (value != null) {
      complete(value);
    }
  }

  T _value;

  /// Completes with the supplied values.
  void complete([T value]) {
    this._value = value;
    _completer.complete(value);
  }

  /// Safe to cancel any time.
  void cancel({String reason}) {
    if (!_isCancelled) {
      if (!isCompleted) {
        completeError(CancelException(reason));
      }
      _isCancelled = true;
    }
  }

  /// true when completed of cancelled
  bool get isCompleted => _completer.isCompleted;

  /// true when cancelled
  bool get isCancelled => _isCancelled;

  /// Value direct access if completer, future if pending
  FutureOr<T> get value {
    if (_completer.isCompleted) {
      return _value;
    }
    return _completer.future;
  }

  // Complete [with an error.
  void completeError(Object error, [StackTrace stackTrace]) {
    if (!isCancelled) {
      _completer.completeError(error, stackTrace);
    }
  }

  /// The future that is completed by this completer.
  /// error if cancelled or failed
  Future<T> get future => _completer.future;
}
