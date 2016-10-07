import 'dart:async';

import '../common_utils_import.dart';

var _zoneTag = #tekartik_synchronized;

class _Task {
  Completer completer = new Completer.sync();
  Func0 fn;
  _Task(this.fn);
  Future get future => completer.future;

}

class LockImpl {
  LockImpl();

  List<_Task> _tasks = [];

  // Usage:
  // locker.synchronized(() { doStuff(); }
  //
  Future/*<T>*/ synchronized/*<T>*/(Func0/*<T>*/ fn) async {
    // Same zone run
    if (Zone.current[_zoneTag] == true) {
      return fn();
    } else {
      _Task task = new _Task(fn);
      _tasks.add(task);
      if (_tasks.length > 1) {
        // wait previous
        _Task previousTask = _tasks[_tasks.length - 2];
        await previousTask.future;
      }

      try {
        return await runZoned(() async {
          return fn();
        }, zoneValues: {_zoneTag: true});
      } finally {
        _tasks.remove(task);
        task.completer.complete();
      }
    }
  }
}
