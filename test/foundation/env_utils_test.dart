import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/foundation/constants.dart' as foundation;
import 'package:tekartik_common_utils/src/assert_utils.dart' as assert_utils;

void main() => defineTests();

void defineTests() {
  group('env', () {
    // assuming we are testing in debug mode...
    test('isRelease', () {
      expect(isRelease, isFalse);
      expect(isDebug, isTrue);
      expect(foundation.kDebugMode, isDebug);
      expect(assert_utils.isDebug, isDebug);
    });
  });
}
