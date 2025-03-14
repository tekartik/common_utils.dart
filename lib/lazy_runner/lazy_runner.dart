import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/env_utils.dart';

/// Count the number of times the function is called
/// Could be ignored, but potentially useful for debugging
typedef LazyRunnerFunction = Future<void> Function(int count);

/// Turn on debug
bool debugLazyRunner = false; // devWarning(true);

/// Lazy runner extension
extension LazyRunnerExtension on LazyRunner {
  /// Count of action ran
  @visibleForTesting
  int get count => (this as _LazyRunner).count;
}

/// Lazy runner
abstract class LazyRunner {
  /// Trigger the action
  void trigger();

  /// Create a lazy runner controller
  factory LazyRunner({required LazyRunnerFunction action}) =>
      _LazyRunner(action: action);

  /// Create a lazy runner controller
  /// First action is run after duration, simple call trigger() to call it right away
  factory LazyRunner.periodic({
    required Duration duration,
    required LazyRunnerFunction action,
  }) =>
      _PeriodicLazyRunner(duration: duration, action: action);

  /// Dispose
  void dispose();
}

void _log(Object? message) {
  // ignore: avoid_print
  print('/LazyRunner $message');
}

class _PeriodicLazyRunner extends _LazyRunner {
  final Duration duration;

  @override
  Future<void> _waitTrigger() async {
    try {
      await super._waitTrigger().timeout(duration);
    } on TimeoutException catch (_) {
      if (_debug) {
        _log('duration timeout $duration');
      }
    }
  }

  _PeriodicLazyRunner({required this.duration, required super.action});
}

/// Lazy runner
class _LazyRunner implements LazyRunner {
  bool get _debug => debugLazyRunner;

  int count = 0;

  final LazyRunnerFunction action;

  var _disposed = false;
  final _lock = Lock();
  var _triggerCompleter = Completer<void>();

  /// Trigger the action
  @override
  void trigger() {
    if (_debug) {
      _log('manual trigger');
    }
    if (!_triggerCompleter.isCompleted) {
      _triggerCompleter.complete();
    }
  }

  Future<void> _callAction() async {
    if (_disposed) {
      return;
    }
    await _lock.synchronized(() async {
      var actionIndex = count++;
      if (_debug) {
        _log('start action $actionIndex');
      }
      try {
        await action(actionIndex);
      } finally {
        if (_debug) {
          _log('end action $actionIndex');
        }
      }
    });
  }

  Future<void> _waitTrigger() async {
    if (_debug) {
      _log('wait trigger');
    }
    await _triggerCompleter.future;
    if (_debug) {
      _log('triggered');
    }
    _triggerCompleter = Completer<void>();
  }

  /// Create a lazy runner controller
  _LazyRunner({required this.action}) {
    () async {
      while (!_disposed) {
        await _waitTrigger();
        try {
          await _callAction();
        } catch (e) {
          if (_debug || isDebug) {
            // ignore: avoid_print
            print('/LazyRunner: error in triggered action $count $e');
          }
        }
      }
    }();
  }

  /// Dispose
  @override
  void dispose() {
    if (_debug) {
      _log('dispose');
    }
    _disposed = true;
  }
}
