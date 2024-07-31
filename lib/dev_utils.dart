/// Development helpers to generate warning in code
library tekartik_dev_utils;

import 'package:tekartik_common_utils/env_utils.dart';

void _devPrint(Object? object) {
  if (_devPrintEnabled) {
    // ignore: avoid_print
    print(object);
  }
}

bool _devPrintEnabled = true;

@Deprecated('Dev only')
set devPrintEnabled(bool enabled) => _devPrintEnabled = enabled;

/// Deprecated to prevent keeping the code used.
@Deprecated('Dev only')
void devPrint(Object? object) => _devPrint(object);

/// Deprecated to prevent keeping the code used.
///
/// Can be use as a todo for weird code. int value = devWarning(myFunction());
/// The function is always called
@Deprecated('Dev only')
T devWarning<T>(T value) => value;

void _devError([Object? object]) {
  // one day remove the print however sometimes the error thrown is hidden
  try {
    throw UnsupportedError('$object');
  } catch (e, st) {
    _devPrint('# ERROR $object');
    _devPrint(st);
    rethrow;
  }
}

/// Deprecated to prevent keeping the code used.
///
/// Will call the action on debug only
@Deprecated('Dev only')
T? devDebugOnly<T>(T Function() action, {String? message}) {
  if (isDebug) {
    _devPrint(
        '[DEBUG_ONLY]${message != null ? ' $message' : ' debug only behavior'}');
    return action();
  } else {
    return null;
  }
}

@Deprecated('Dev only')

/// Dev only error print
void devError([Object? object]) => _devError(object);

/// exported for testing
void debugDevPrint(Object? object) => _devPrint(object);

/// exported for testing
void debugDevError(Object? object) => _devError(object);

set debugDevPrintEnabled(bool enabled) => _devPrintEnabled = enabled;

/// Simple class to add a debug flag
/// off by default
/// turning it on raises a warning so that you don't checkin code like that
class DevFlag {
  /// Explanation of the flag
  final String? explanation;

  /// Constructor
  DevFlag([this.explanation]);

  /// Is the flag on
  bool get on => _on ?? false;
  bool? _on;

  @Deprecated('Dev only')
  set on(bool on) {
    _on = on;
    if (_devPrintEnabled) {
      // ignore: avoid_print
      print('Turning $this');
    }
  }

  @override
  String toString() => "DevFlag($explanation) ${on ? "on" : "off"}";
}
