import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';
import 'package:test/test.dart';

void main() {
  group('Lazy runner', () {
    test('periodic', () async {
      var runner = LazyRunner.periodic(
          duration: const Duration(milliseconds: 10), action: (count) async {});
      await sleep(50);
      expect(runner.count, lessThan(6));
      expect(runner.count, greaterThan(2));
    });
    test('trigger', () async {
      var runner = LazyRunner(action: (count) async {
        await sleep(20);
      });
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
