import 'dart:typed_data';

import 'package:tekartik_common_utils/byte_utils.dart';
import 'package:tekartik_common_utils/hex_utils.dart' as hex_utils;
import 'package:tekartik_common_utils/hex_utils.dart';

/// Parse as hex bytes
Uint8List parseHexBytes(String text) {
  var list = parseHexString(text);
  return asUint8List(list);
}

/// Convert to hex
extension TekartikUint8ListToHexExt on Uint8List {
  /// Convert 1,2,3 to 010203
  String toHexString() {
    return hex_utils.toHexString(this)!;
  }

  /// Convert 1,2,3 to 0x00010203
  int toUint32() {
    return (this[0] << 24) + (this[1] << 16) + (this[2] << 8) + this[3];
  }
}

/// Convert to hex
extension TekartikUint32ToHexExt on int {
  /// Convert 1,2,3 to 010203
  String uint32ToHex() {
    return uint32ToUint8List().toHexString();
  }

  /// Convert 1,2,3 to 010203
  Uint8List uint32ToUint8List() {
    return Uint8List.fromList([this >> 24, this >> 16, this >> 8, this]);
  }
}

/// Convert from hex
extension TekartikStringFromHexExt on String {
  /// Convert "010203" to 1,2,3
  Uint8List hexParseUint8List() {
    return parseHexBytes(this);
  }

  /// Convert "010203" to 0x00010203
  int hexParseUint32() {
    return hexParseUint8List().toUint32();
  }
}
