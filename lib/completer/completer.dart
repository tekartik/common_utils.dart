@deprecated
library tekartik_common_utils_completer;

import 'dart:async';

import 'package:tekartik_common_utils/model/model.dart';

/// Cancel exception thrown when cancelling a completer
class CancelException implements Exception {
  final String? reason;

  CancelException(this.reason);

  @override
  String toString() {
    var result = 'Request cancelled';
    if (reason != null) {
      result = '$result due to: $reason';
    }
    return result;
  }
}

/// A completer that can be cancelled and with value that could be accessed
/// immediately.
abstract class CancellableCompleter<T> {
  /// Only completed immediately if value is not null
  factory CancellableCompleter({bool? sync, T? value}) =>
      _CancellableCompleter(sync: sync, value: value);

  /// Completes with the supplied values.
  void complete([T? value]);

  /// Safe to cancel any time.
  void cancel({String? reason});

  /// true when completed of cancelled
  bool get isCompleted;

  /// true when cancelled
  bool get isCancelled;

  /// Value direct access if completed, future if pending
  FutureOr<T>? get value;

  /// The error if any
  dynamic get error;

  // Complete [with an error.
  void completeError(Object error, [StackTrace? stackTrace]);

  /// The future that is completed by this completer.
  /// error if cancelled or failed
  Future<T> get future;
}

/// A completer that can be cancelled and with value that could be accessed
/// immediately.
///
/// Set the completer before any action
mixin CancellableCompleterMixin<T> implements CancellableCompleter<T> {
  set completer(Completer<T> completer) {
    assert(_completer == null, 'completer can only be set once');
    _completer = completer;
  }

  Completer<T>? _completer;
  bool _isCancelled = false;

  dynamic _error;
  T? _value;

  /// Completes with the supplied values.
  @override
  void complete([T? value]) {
    _value = value;
    _completer!.complete(value);
  }

  /// Safe to cancel any time.
  @override
  void cancel({String? reason}) {
    if (!_isCancelled) {
      _isCancelled = true;
      if (!isCompleted) {
        completeError(CancelException(reason));
      }
    }
  }

  /// true when completed of cancelled
  @override
  bool get isCompleted => _completer!.isCompleted;

  /// true when cancelled
  @override
  bool get isCancelled => _isCancelled;

  /// Value direct access if successfully completed, future if pending
  @override
  FutureOr<T>? get value {
    if (isCompleted && _error == null) {
      return _value;
    }
    return future;
  }

  /// The error if any
  @override
  dynamic get error => _error;

  // Complete [with an error.
  @override
  void completeError(Object error, [StackTrace? stackTrace]) {
    _error = error;
    _completer!.completeError(error, stackTrace);
  }

  /// The future that is completed by this completer.
  /// error if cancelled or failed
  @override
  Future<T> get future => _completer!.future;

  Model toDebugModel() {
    var model = Model();
    model['completer'] = identityHashCode(_completer);
    model.setValue('error', _error);
    model.setValue('completed', isCompleted);
    model.setValue('value', isCompleted ? _value : null,
        presentIfNull: isCompleted);
    return model;
  }

  @override
  String toString() => 'CancellableCompleter(${toDebugModel()})';
}

class _CancellableCompleter<T> with CancellableCompleterMixin<T> {
  /// Only completed immediately if value is not null
  _CancellableCompleter({bool? sync, T? value}) {
    completer = sync == true ? Completer.sync() : Completer<T>();
    if (value != null) {
      complete(value);
    }
  }
}
