import 'package:tekartik_common_utils/out_buffer.dart';
import 'package:test/test.dart';

main() {
  group('out_buffer', () {
    test('add', () {
      var buffer = new OutBuffer(3);
      for (int i = 0; i < 4; i++) {
        buffer.add("$i");
      }
      expect(buffer.toString(), "1\n2\n3");
    });
  });
}
