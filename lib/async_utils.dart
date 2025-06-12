import 'dart:async';

import 'package:synchronized/synchronized.dart';

import 'list_utils.dart';

export 'src/async_utils.dart'
    show
        TekartikCommonCompleterExt,
        TekartikCommonStreamControllerExt,
        TekartikStopwatchExt,
        sleep;

/// Wait for all futures to complete
/// @Deprecated('Use Future.wait')
Future<List?> waitAll(List<Future Function()>? computations) async {
  if (listIsEmpty(computations)) {
    return null;
  }
  final futures = List<Future>.generate(
    computations!.length,
    (int index) => computations[index](),
  );
  return Future.wait(futures);
}

///
/// Run an operation only once
class AsyncOnceRunner {
  final FutureOr Function() _computation;

  /// Helper to load a javascript script only once
  bool _done = false;
  final _lock = Lock();

  /// Constructor
  AsyncOnceRunner(FutureOr Function() computation) : _computation = computation;

  /// true if the operation has been done
  bool get done => _done;

  /// Run the operation
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
