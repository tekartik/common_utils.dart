import 'dart:async';

import 'package:func/func.dart';

class LockImpl {
  bool locked = false;

  LockImpl();

  Completer completer;

  Future lock() async {
    if (!locked) {
      locked = true;
      completer = new Completer.sync();
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
      /*=T*/
      var result = fn();

      if (result is Future) {
        result = await result;
      }
      return result;
    } finally {
      unlock();
    }
  }

  void unlock() {
    locked = false;
    completer.complete();
  }

  @override
  String toString() {
    return "Lock($locked)";
  }
}
