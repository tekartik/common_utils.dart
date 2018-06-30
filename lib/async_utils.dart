import 'dart:async';
import 'package:func/func.dart';
import 'list_utils.dart';
import 'package:synchronized/synchronized.dart';

// create a future delayed for [ms] milliseconds
Future sleep([int ms = 0]) {
  return new Future.delayed(new Duration(milliseconds: ms));
}

Future<List> waitAll(List<Func0<Future>> computations) async {
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
  final Func0<FutureOr> _computation;

  /// Helper to load a javascript script only once
  bool _done = false;
  var _lock = new Lock();
  AsyncOnceRunner(Func0<FutureOr> computation) : _computation = computation;

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
