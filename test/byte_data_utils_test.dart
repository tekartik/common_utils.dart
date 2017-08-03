import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:tekartik_common_utils/byte_data_utils.dart';

main() {
  group('byte_data utils', () {
    test('toFromUint8', () {
      Uint8List list = new Uint8List.fromList([1, 2, 3, 4]);
      expect(byteDataToUint8List(byteDataFromUint8List(list)), [1, 2, 3, 4]);
    });

    test('fromOffset', () {
      ByteBuffer buffer = new Uint8List.fromList([1, 2, 3, 4]).buffer;
      ByteData data = new ByteData.view(buffer);
      expect(byteDataToUint8List(data), [1, 2, 3, 4]);

      data = byteDataFromOffset(data, 1);
      expect(byteDataToUint8List(data), [2, 3, 4]);
    });
  });
}
