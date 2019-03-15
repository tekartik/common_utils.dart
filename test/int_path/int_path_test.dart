import 'dart:math';

import 'package:path/path.dart';
import 'package:tekartik_common_utils/env_utils.dart';
import 'package:tekartik_common_utils/int_path/int_path.dart';
import 'package:test/test.dart';

void main() {
  group('int_path', () {
    test('intShiftRight', () {
      expect(intShiftRight(0x1FF, 8), 1);
      expect(intShiftRight(0x100, 8), 1);
      if (isRunningAsJavascript) {
        expect(intShiftRight(-1, 8), 16777215);
      } else {
        expect(intShiftRight(-1, 8), 17592186044415);
      }
      expect(intShiftRight(-1, 0), 0x000FFFFFFFFFFFFF);
      expect(intShiftRight(-1, 8), 0x00000FFFFFFFFFFF);
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
    });

    test('intToPathParts', () {
      expect(intToFilePath(0), '0');
      expect(intToFilePath(1), '1');
      expect(intToFilePath(15), 'F');
      expect(intToFilePath(16), 'G0');
      expect(intToFilePath(255), 'UF');
      expect(intToFilePath(256), join('Z2', '1', '0'));
      expect(intToFilePath(65535), join('Z2', 'UF', 'UF'));
      expect(intToFilePath(65536), join('Z3', '1', '0', '0'));
      // expect(intToFilePath(pow(2, 53).toInt() -1),     joinAll(['Z7', 'GF',  'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
      // expect(intToFilePath(pow(2, 53).toInt() - 1),          joinAll(['Z7', 'GF', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));

//       expect(intToFilePath(0x000FFFFFFFFFFFFF),          joinAll(['Z4', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
      expect(intToFilePath(pow(2, 51).toInt() - 1),
          joinAll(['Z7', '7', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
      if (!isRunningAsJavascript) {
        expect(intToFilePath(pow(2, 52).toInt() - 1),
            joinAll(['Z7', 'F', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));


        expect(intToFilePath(-1),
            joinAll(['Z7', 'F', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
        expect(intToFilePath(-2),
            joinAll(['Z7', 'F', 'UF', 'UF', 'UF', 'UF', 'UF', 'UE']));
      } else {
        expect(intToFilePath(pow(2, 52).toInt() - 1),
            joinAll(['Z4', 'UF', 'UF', 'UF', 'UF']));

        try {
          expect(intToFilePath(pow(2, 53).toInt() - 1),
              joinAll(['Z7', 'H0', '0', '0', '0', '0', '0', '0']));
        } on Exception catch (e) {
          print(e);
        }
      }
    });

  });
}
