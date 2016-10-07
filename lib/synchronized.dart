// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// This simulated the synchronized feature of Java
library synchronized;

import 'dart:async';
import 'package:func/func.dart';

// Re-entrant lock
class Lock {
  Lock();

  //
  // Usage:
  //     Lock lock = new Lock();
  //     lock.synchronized(() { doStuff(); }
  //
  Future/*<T>*/ synchronized/*<T>*/(Func0/*<T>*/ fn) async {
    // Same zone means re-entrant, so run directly
    if (Zone.current[_zoneTag] == true) {
      return fn();
    } else {
      // Create the task and add it to our queue
      _SynchronizedTask task = new _SynchronizedTask(fn);
      _tasks.add(task);
      // Only wait if there was another one running before
      if (_tasks.length > 1) {
        _SynchronizedTask previousTask = _tasks[_tasks.length - 2];
        await previousTask.future;
      }

      // Run in a zone and set a flag to allow re-entrant calls
      try {
        return await runZoned(() async {
          return fn();
        }, zoneValues: {_zoneTag: true});
      } finally {
        // Cleanup
        // remove from queue and complete
        _tasks.remove(task);
        task.completer.complete();
      }
    }
  }

  // list of waiting/running tasks
  List<_SynchronizedTask> _tasks = new List();

}

// unique tag for the running synchronized zone
var _zoneTag = #tekartik_synchronized;

class _SynchronizedTask {
  Completer completer = new Completer.sync();
  Func0 fn;
  Future get future => completer.future;
  _SynchronizedTask(this.fn);
}

