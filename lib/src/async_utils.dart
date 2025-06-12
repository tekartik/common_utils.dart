import 'dart:async';

export 'dart:async';

/// Safe call to complete or complete error
extension TekartikCommonCompleterExt<T> on Completer<T> {
  /// Complete the completer if not completed
  void safeComplete([FutureOr<T>? value]) {
    if (!isCompleted) {
      complete(value);
    }
  }

  /// Complete the completer with an error if not completed
  void safeCompleteError(Object error, [StackTrace? stackTrace]) {
    if (!isCompleted) {
      completeError(error, stackTrace);
    }
  }
}

/// Safe call to complete or complete error
extension TekartikCommonStreamControllerExt<T> on StreamController<T> {
  /// Complete the completer if not completed
  void safeAdd(T event) {
    if (!isClosed) {
      add(event);
    }
  }

  /// Complete the completer with an error if not completed
  void safeAddError(Object error, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(error, stackTrace);
    }
  }
}

/// Stopwatch extension methods.
extension TekartikStopwatchExt on Stopwatch {
  /// Sleep at least the specified number of milliseconds.
  /// Stopwatch must be running.
  Future<void> sleepAtLeast(int milliseconds) async {
    assert(isRunning);
    if (elapsedMilliseconds < milliseconds) {
      final remaining = milliseconds - elapsedMilliseconds;
      await sleep(remaining);
    }
  }

  /// Returns the elapsed time in milliseconds.
  int get elapsedMilliseconds => elapsed.inMilliseconds;
}

/// create a future delayed for [ms] milliseconds
Future sleep([int ms = 0]) {
  return Future<void>.delayed(Duration(milliseconds: ms));
}
