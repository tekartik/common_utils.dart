import 'package:test/test.dart';
import 'package:tekartik_common_utils/hex_utils.dart';

main() {
  group('hex utils', () {
    test('Uint4', () {
      expect(hexCodeUint4(0), '0'.codeUnitAt(0));
      expect(hexCodeUint4(9), '9'.codeUnitAt(0));
      expect(hexCodeUint4(10), 'A'.codeUnitAt(0));
      expect(hexCodeUint4(15), 'F'.codeUnitAt(0));
      expect(hexCodeUint4(16), '0'.codeUnitAt(0));
    });

    test('Uint8', () {
      expect(hexUint8(0), '00');
      expect(hexUint8(15), '0F');
      expect(hexUint8(16), '10');
      expect(hexUint8(255), 'FF');
      expect(hexUint8(256), '00');
    });

    test('hexPretty', () {
      expect(hexPretty([0xff]), startsWith('FF'));
      expect(hexPretty([1, 0x23]), startsWith('01 23'));
      expect(hexPretty([1, 2, 3, 4, 5]), startsWith('01 02 03 04  05'));
      List<int> list = new List.generate(256, (index) => index);
      //expect(hexPretty([0xff, 0xfe, 128, 127]), 'FF');
      expect(
          hexPretty(list),
          '00 01 02 03  04 05 06 07  08 09 0A 0B  0C 0D 0E 0F  ???? ???? ???? ????\n'
          '10 11 12 13  14 15 16 17  18 19 1A 1B  1C 1D 1E 1F  ???? ???? ???? ????\n'
          '20 21 22 23  24 25 26 27  28 29 2A 2B  2C 2D 2E 2F   !"# \$%&\' ()*+ ,-./\n'
          '30 31 32 33  34 35 36 37  38 39 3A 3B  3C 3D 3E 3F  0123 4567 89:; <=>?\n'
          '40 41 42 43  44 45 46 47  48 49 4A 4B  4C 4D 4E 4F  @ABC DEFG HIJK LMNO\n'
          '50 51 52 53  54 55 56 57  58 59 5A 5B  5C 5D 5E 5F  PQRS TUVW XYZ[ \\]^_\n'
          '60 61 62 63  64 65 66 67  68 69 6A 6B  6C 6D 6E 6F  `abc defg hijk lmno\n'
          '70 71 72 73  74 75 76 77  78 79 7A 7B  7C 7D 7E 7F  pqrs tuvw xyz{ |}~?\n'
          '80 81 82 83  84 85 86 87  88 89 8A 8B  8C 8D 8E 8F  ???? ???? ???? ????\n'
          '90 91 92 93  94 95 96 97  98 99 9A 9B  9C 9D 9E 9F  ???? ???? ???? ????\n'
          'A0 A1 A2 A3  A4 A5 A6 A7  A8 A9 AA AB  AC AD AE AF  ???? ???? ???? ????\n'
          'B0 B1 B2 B3  B4 B5 B6 B7  B8 B9 BA BB  BC BD BE BF  ???? ???? ???? ????\n'
          'C0 C1 C2 C3  C4 C5 C6 C7  C8 C9 CA CB  CC CD CE CF  ???? ???? ???? ????\n'
          'D0 D1 D2 D3  D4 D5 D6 D7  D8 D9 DA DB  DC DD DE DF  ???? ???? ???? ????\n'
          'E0 E1 E2 E3  E4 E5 E6 E7  E8 E9 EA EB  EC ED EE EF  ???? ???? ???? ????\n'
          'F0 F1 F2 F3  F4 F5 F6 F7  F8 F9 FA FB  FC FD FE FF  ???? ???? ???? ????\n'
          '  ');
    });

    test('hexQuickView', () {
      expect(hexQuickView([0xff]), 'FF');
      expect(hexQuickView([1, 0x23]), '01 23');
      expect(hexQuickView([1, 2, 3, 4, 5]), '01 02 03 04  05');
    });

    test('parseHexString', () {
      expect(parseHexString("01 83 3d 79"), [0x01, 0x83, 0x3d, 0x79]);
      expect(parseHexString("01 83 3d79 FF"), [0x01, 0x83, 0x3d, 0x79, 0xFF]);
      expect(parseHexString("0x01"), [0x01]);
      expect(parseHexString("0xFFFE ED xDC"), [0xFF, 0xFE, 0xED, 0xDC]);
      // parseHexString
    });
  });
}
