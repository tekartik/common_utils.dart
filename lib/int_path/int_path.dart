import 'dart:math';

import 'package:path/path.dart' as path;
import 'package:tekartik_common_utils/hex_utils.dart';

int intShiftRight(int value, int count) {
  var powValue = pow(2, count).round();
  int getRemaining(int value) {
    // var shiftValue = pow(2, count) - 1;
    return value ~/ powValue;
  }
  if (value < 0) {
   return -getRemaining(-value);
  } else {
    return getRemaining(value);

  }
  // return ((value & 0x000FFFFFFFFFFFFF) >> count);
}
/// Convert a value to a variable lenght uint8 array, little endian
List<int> intToInts(int value) {
  if (value == null) {
    return null;
  }

  List<int> next(int value) {
    if ((value & 0xFF) != value) {
      var part = value & 0xFF;
      // This does not compile on js
      // value = ((value >> 8) & 0x00FFFFFFFFFFFFFF);
      // This compile, limited to 2^52
      value = intShiftRight(value, 8);

      var parts = next(value)..add(part);
      return parts;
    } else {
      return [value];
    }
  }

  // trigger
  return next(value);
}

/// Return the hex formated value like 0123456789ABCDEF single letter
/// or G0,G1...GF....up to
String intPartToHex(int value) {
  if (value < 16) {
    return String.fromCharCode(hexCodeUint4(value));
  }
  return String.fromCharCodes(
      [_hexAbove16CodeUint4((value & 0xF0) >> 4), hex2CodeUint8(value)]);
}

final int _upperFCodeUnit = 'F'.codeUnitAt(0);

int _hexAbove16CodeUint4(int value) {
  value = value & 0xF;
  return _upperFCodeUnit + value;
}

/// Opiniated file path based on an int.
///
/// path is ok on all platforms and dispatch elements with a maximum of 256
/// files/directory per directory
String intToFilePath(int value) {
  return path.joinAll(intToFileParts(value));
}

/// Safe generation (Windows ok) of unique file path parts based on an integer
List<String> intToFileParts(int value) {
  var ints = intToInts(value);
  List<String> parts = [];
  for (var i = 0; i < ints.length; i++) {
    parts.add(intPartToHex(ints[i]));
  }
  if (ints.length > 1) {
    parts.insert(0, 'Z${ints.length}');
  }
  return parts;
}
