import 'dart:math';

import 'package:path/path.dart';
import 'package:tekartik_common_utils/int_path/int_path.dart';
import 'package:test/test.dart';

void main() {
  group('int_path', () {
    test('intShiftRight', () {
      expect(intShiftRight(0x1FF, 8), 1);
      expect(intShiftRight(0x100, 8), 1);
      expect(intShiftRight(-1, 0), -1);
      expect(intShiftRight(-1, 8), 0x0010000000000000);
    });
    test('intToPathInts', () {
      expect(intToInts(0), [0]);
      expect(intToInts(1), [1]);
      expect(intToInts(255), [255]);
      expect(intToInts(256), [1, 0]);
      expect(intToInts(257), [1, 1]);
      expect(intToInts(256), [1, 0]);
      expect(intToInts(512), [2, 0]);
      expect(intToInts(65535), [255, 255]);
      expect(intToInts(65536), [1, 0, 0]);
      expect(intToInts(65537), [1, 0, 1]);
      expect(intToInts(pow(2, 52).toInt() - 1),
          [15, 255, 255, 255, 255, 255, 255]);
      expect(intToInts(-1), [16, 0, 0, 0, 0, 0, 0, 255]);
      expect(intToInts(-2), [16, 0, 0, 0, 0, 0, 0, 254]);
    });

    test('intToPathParts', () {
      expect(intToFilePath(0), '0');
      expect(intToFilePath(1), '1');
      expect(intToFilePath(15), 'F');
      expect(intToFilePath(16), 'G0');
      expect(intToFilePath(255), 'UF');
      expect(intToFilePath(256), join('Z2', '1', '0'));
      expect(intToFilePath(257), join('Z2', '1', '1'));
      expect(intToFilePath(65535), join('Z2', 'UF', 'UF'));
      expect(intToFilePath(65536), join('Z3', '1', '0', '0'));
      expect(intToFilePath(65537), join('Z3', '1', '0', '1'));
      expect(intToFilePath(65536 * 256 - 1), join('Z3', 'UF', 'UF', 'UF'));
      expect(intToFilePath(65536 * 256), join('Z4', '1', '0', '0', '0'));

      expect(65536 * 256, 16777216);
      expect(65536 * 65536, 4294967296);
      expect(intToFilePath(4294967295), join('Z4', 'UF', 'UF', 'UF', 'UF'));
      expect(intToFilePath(4294967296), join('Z5', '1', '0', '0', '0', '0'));
      expect(intToFilePath(pow(2, 52).toInt() - 1),
          joinAll(['Z7', 'F', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));

      expect(intToFilePath(intPathMax),
          joinAll(['Z7', 'F', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
      expect(intToFilePath(intPathMin),
          joinAll(['Z8', 'F', 'U0', '0', '0', '0', '0', '1', '1']));
      expect(intToFilePath(-1),
          joinAll(['Z8', 'G0', '0', '0', '0', '0', '0', '0', 'UF']));
      expect(intToFilePath(-2),
          joinAll(['Z8', 'G0', '0', '0', '0', '0', '0', '0', 'UE']));
      expect(intToFilePath(pow(2, 51).toInt() - 1),
          joinAll(['Z7', '7', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
    });
  });
}
