import 'dart:async';

/// Simple cooperate that checks every 4ms
class Cooperator {
  // Cooperate mode
  //
  final bool cooperateOn = true;
  var cooperateStopWatch = Stopwatch()..start();

  /// Need to cooperate every 16 milliseconds, 4 looks good in experiments
  bool get needCooperate =>
      cooperateOn && cooperateStopWatch.elapsedMilliseconds > 4;

  /// Cooperate if needed
  FutureOr cooperate() {
    if (needCooperate) {
      cooperateStopWatch
        ..stop()
        ..reset()
        ..start();
      // Just don't make it 0, tested for best performance using Flutter
      // on a (non-recent) Nexus 5
      return Future<void>.delayed(const Duration(microseconds: 100));
    } else {
      return null;
    }
    // await Future.value();
    //print('breath');
  }
}

/// The global cooperator to use
final Cooperator cooperator = Cooperator();
