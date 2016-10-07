import 'dart:async';

import 'package:func/func.dart';

var _zoneTag = #tekartik_synchronized;

class LockImpl {
  bool locked = false;
  int lockCount = 0;

  LockImpl();

  Completer completer;

  Future lock() async {
    if (!locked) {
      lockCount++;
      locked = true;
      completer = new Completer.sync();
      return;
    }
    if (Zone.current[_zoneTag] == true) {
      lockCount++;
      return;
    }
    // wait for previous to finish
    await completer.future;
    await lock();
  }

  // Usage:
  // locker.synchronized(() { doStuff(); }
  //
  Future/*<T>*/ synchronized/*<T>*/(Func0/*<T>*/ fn) async {
    await lock();
    try {
      return await runZoned(() async {
        /*=T*/
        var result = fn();

        if (result is Future) {
          result = await result;
        }
        return result;
      }, zoneValues: {_zoneTag: true});
    } finally {
      unlock();
    }
  }

  void unlock() {
    --lockCount;
    if (lockCount < 0) {
      throw new Exception("lockCount cannot be < 0");
    } else if (lockCount == 0) {
      locked = false;
      completer.complete();
    }
  }

  @override
  String toString() {
    return "Lock($locked)";
  }
}
