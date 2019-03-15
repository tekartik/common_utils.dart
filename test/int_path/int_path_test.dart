import 'package:path/path.dart';
import 'package:tekartik_common_utils/int_path/int_path.dart';
import 'package:test/test.dart';

void main() {
  group('int_path', () {
    test('intToPathInts', () async {
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
      expect(intToFilePath(-1),
          joinAll(['Z8', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF', 'UF']));
    });
  });
}
