import 'package:tekartik_common_utils/cooperator/cooperator.dart';
import 'package:test/test.dart';

void main() {
  group('cooperator', () {
    test('cooperate', () async {
      var sw = Stopwatch()..start();
      var cooperator = Cooperator();
      while (!cooperator.needCooperate) {}
      expect(sw.elapsedMilliseconds, greaterThan(4));

      sw = Stopwatch()..start();
      await cooperator.cooperate();
      while (!cooperator.needCooperate) {}
      expect(sw.elapsedMilliseconds, greaterThan(4));
    });
    test('global', () async {
      // Wait first since this is a global object
      while (!cooperator.needCooperate) {}
      var sw = Stopwatch()..start();
      await cooperator.cooperate();
      while (!cooperator.needCooperate) {}
      expect(sw.elapsedMilliseconds, greaterThan(4));

      sw = Stopwatch()..start();
      await cooperator.cooperate();
      while (!cooperator.needCooperate) {}
      expect(sw.elapsedMilliseconds, greaterThan(4));
    });
  });
}
