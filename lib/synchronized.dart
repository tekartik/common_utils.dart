// Copyright (c) 2016, Alexandre Roux Tekartik. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library synchronized;

import 'dart:async';

import 'package:func/func.dart';

import 'src/lock_impl.dart';

// Re-entrant lock
class Lock {
  final LockImpl _impl = new LockImpl();

  Lock();

  Future/*<T>*/ synchronized/*<T>*/(Func0/*<T>*/ fn) {
    return _impl.synchronized(fn);
  }

  @override
  String toString() {
    return _impl.toString();
  }
}
