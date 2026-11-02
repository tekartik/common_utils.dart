import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';
import 'package:test/test.dart';

void main() {
  group('Lazy runner', () {
    test('periodic', () async {
      var stopwatch = Stopwatch()..start();
      var runner = LazyRunner.periodic(
        duration: const Duration(milliseconds: 10),
        action: (count) async {},
      );
      // A fixed sleep is not reliable: on windows a 10ms timer can take
      // 15ms or more (60ms gave only 2 runs on CI), so wait for 3 runs.
      while (runner.count < 3) {
        if (stopwatch.elapsed > const Duration(seconds: 10)) {
          fail('only ${runner.count} runs in ${stopwatch.elapsed}');
        }
        await sleep(5);
      }
      runner.dispose();
      // Each run waits for the duration first: 3 runs take at least 30ms
      // (some tolerance for the clocks).
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(25));
    });
    test('trigger', () async {
      var runner = LazyRunner(
        action: (count) async {
          await sleep(20);
        },
      );
      for (var i = 0; i < 10; i++) {
        await sleep(5);
        runner.trigger();
      }
      runner.dispose();
      expect(runner.count, lessThan(7));
      expect(runner.count, greaterThan(2));
    });
  });
}
