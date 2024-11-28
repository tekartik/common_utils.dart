import 'dart:typed_data';

import 'package:tekartik_common_utils/byte_utils.dart';
import 'package:tekartik_common_utils/hex_utils.dart';

/// Parse as hex bytes
Uint8List parseHexBytes(String text) {
  var list = parseHexString(text);
  return asUint8List(list);
}
