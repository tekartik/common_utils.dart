import 'dart:async';

import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

/// Single operation with eventually a delay between each run
class Operation {
  /// The action to run (can return a future and in this case it is ran
  /// only one at a time)
  final Function action;

  /// The delay between each action
  final Duration delay;
  final _lock = Lock();
  bool _pending = false;

  Operation({@required this.action, this.delay});

  /// Trigger the action, if already running wait at least [delay] before
  /// running another one
  void trigger() {
    if (!_pending) {
      _pending = true;
      _lock.synchronized(() async {
        _pending = false;
        await action();
        if (delay != null) {
          await Future.delayed(delay);
        }
      });
    }
  }
}
