import 'dart:async';
import 'list_utils.dart';
import 'package:synchronized/synchronized.dart';

// create a future delayed for [ms] milliseconds
Future sleep([int ms = 0]) {
  return new Future.delayed(new Duration(milliseconds: ms));
}

Future<List> waitAll(List<Future Function()> computations) async {
  if (listIsEmpty(computations)) {
    return null;
  }
  List<Future> futures = new List.generate(
      computations.length, (int index) => computations[index]());
  return Future.wait(futures);
}

///
/// Run an operation only once
class AsyncOnceRunner {
  final FutureOr Function() _computation;

  /// Helper to load a javascript script only once
  bool _done = false;
  var _lock = new Lock();
  AsyncOnceRunner(FutureOr computation()) : _computation = computation;

  get done => _done;
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
