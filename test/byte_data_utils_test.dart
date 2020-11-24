import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:tekartik_common_utils/byte_data_utils.dart';

void main() {
  group('byte_data utils', () {
    test('toFromUint8', () {
      var list = Uint8List.fromList([1, 2, 3, 4]);
      expect(byteDataToUint8List(byteDataFromUint8List(list)), [1, 2, 3, 4]);
    });

    test('fromOffset', () {
      var buffer = Uint8List.fromList([1, 2, 3, 4]).buffer;
      var data = ByteData.view(buffer);
      expect(byteDataToUint8List(data), [1, 2, 3, 4]);

      var data2 = byteDataFromOffset(data, 1);
      expect(byteDataToUint8List(data2), [2, 3, 4]);

      var data3 = byteDataFromOffset(data, 1, 2);
      expect(byteDataToUint8List(data3), [2, 3]);
    });

    test('asUint8List', () {
      expect(asUint8List(null), null);
      var list = [1, 2, 3];
      var uint8List = Uint8List.fromList(list);

      expect(identical(asUint8List(uint8List), uint8List), true);
      expect(identical(asUint8List(list), uint8List), false);
      expect(asUint8List(list), uint8List);
    });
  });
}
