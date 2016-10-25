import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/env_utils.dart';

void main() => defineTests();

void defineTests() {
  group('env', () {
    // assuming we are testing in debug mode...
    test('isRelease', () {
      expect(isRelease, isFalse);
      expect(isDebug, isTrue);
    });
  });
}
