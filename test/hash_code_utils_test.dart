library;

//import 'package:unittest/vm_config.dart';
import 'package:tekartik_common_utils/hash_code_utils.dart';
import 'package:test/test.dart';

void main() {
  group('hash_code', () {
    test('safe_hash', () {
      expect(safeHashCode(null), 0);
      expect(safeHashCode(0), 0.hashCode);
      expect(safeHashCode(1), 1.hashCode);
      expect(safeHashCode('hi'), 'hi'.hashCode);
    });
  });
}
