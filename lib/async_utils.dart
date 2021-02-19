import 'dart:async';

import 'package:synchronized/synchronized.dart';

import 'list_utils.dart';

// create a future delayed for [ms] milliseconds
Future sleep([int ms = 0]) {
  return Future.delayed(Duration(milliseconds: ms));
}

Future<List?> waitAll(List<Future Function()>? computations) async {
  if (listIsEmpty(computations)) {
    return null;
  }
  final futures = List<Future>.generate(
      computations!.length, (int index) => computations[index]());
  return Future.wait(futures);
}

///
/// Run an operation only once
class AsyncOnceRunner {
  final FutureOr Function() _computation;

  /// Helper to load a javascript script only once
  bool _done = false;
  final _lock = Lock();

  AsyncOnceRunner(FutureOr Function() computation) : _computation = computation;

  bool get done => _done;

  Future run() async {
    if (!_done) {
      await _lock.synchronized(() async {
        if (!_done) {
          await _computation();
          _done = true;
        }
      });
    }
  }
}
