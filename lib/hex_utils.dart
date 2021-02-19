import 'dart:math';

///
int _upperACodeUnit = 'A'.codeUnitAt(0);
int _lowerACodeUnit = 'a'.codeUnitAt(0);
int _digit0CodeUnit = '0'.codeUnitAt(0);

int? hexCharValue(int charCode) {
  if (charCode >= _upperACodeUnit && charCode < _upperACodeUnit + 6) {
    return charCode - _upperACodeUnit + 10;
  }
  if (charCode >= _lowerACodeUnit && charCode < _lowerACodeUnit + 6) {
    return charCode - _lowerACodeUnit + 10;
  }
  if (charCode >= _digit0CodeUnit && charCode < _digit0CodeUnit + 10) {
    return charCode - _digit0CodeUnit;
  }
  return null;
}

/// Return the hex formated value like A
int hexCodeUint4(int value) {
  value = value & 0xF;
  if (value < 10) {
    return _digit0CodeUnit + value;
  } else {
    return _upperACodeUnit + value - 10;
  }
}

/// Return the hex formated value like A
int lohexCodeUint4(int value) {
  value = value & 0xF;
  if (value < 10) {
    return _digit0CodeUnit + value;
  } else {
    return _lowerACodeUnit + value - 10;
  }
}

int hex1CodeUint8(int value) {
  return hexCodeUint4((value & 0xF0) >> 4);
}

int lohex1CodeUint8(int value) {
  return lohexCodeUint4((value & 0xF0) >> 4);
}

int hex2CodeUint8(int value) {
  return hexCodeUint4(value);
}

int lohex2CodeUint8(int value) {
  return lohexCodeUint4(value);
}

/// Return the hex formated value like 1A
String hexUint8(int value) {
  return String.fromCharCodes([hex1CodeUint8(value), hex2CodeUint8(value)]);
}

/// Return the hex formated value like 1A
String lohexUint8(int value) {
  return String.fromCharCodes([lohex1CodeUint8(value), lohex2CodeUint8(value)]);
}

/// Return the hex formated value like 12AB
String hexUint16(int value) {
  return hexUint8(value >> 8) + hexUint8(value);
}

/// Return the hex formated value like 1234ABCD
String hexUint32(int value) {
  return hexUint16(value >> 16) + hexUint16(value);
}

String hexQuickView(List<int>? data, [int? maxLen]) {
  if (data == null) {
    return '(null)';
  }
  if (maxLen == null) {
    maxLen = data.length;
  } else {
    maxLen = min(data.length, maxLen);
  }
  final out = StringBuffer();
  for (var i = 0; i < maxLen; i++) {
    if (i > 0) {
      out.write(' ');
      if ((i % 4) == 0) {
        out.write(' ');
      }
      if ((i % 16) == 0) {
        out.write(' ');
      }
    }
    final charCode = data[i];
    out.writeCharCode(hex1CodeUint8(charCode));
    out.writeCharCode(hex2CodeUint8(charCode));
  }
  return out.toString();
}

List<String>? hexPrettyLines(List<int>? data) {
  if (data == null) {
    return null;
  } else if (data.isEmpty) {
    return [];
  }
  final lines = <String>[];
  StringBuffer? sb;
  _hexPretty(data, () {
    if (sb != null) {
      lines.add(sb.toString());
    }
    sb = StringBuffer();
    return sb;
  });
  if (sb!.isNotEmpty) {
    // last line
    lines.add(sb.toString());
  }
  return lines;
}

String? hexPretty(List<int>? data) {
  if (data == null) {
    return null;
  } else if (data.isEmpty) {
    return '[nodata]';
  }
  StringBuffer? sb;
  _hexPretty(data, () {
    if (sb == null) {
      sb = StringBuffer();
    } else {
      sb!.writeln();
    }
    return sb;
  });
  return sb.toString();
}

String _hexPretty(List<int> data, StringBuffer? Function() newLine) {
  final blockSize = 16;
  int readSize;
  var lineIndex = 0;
  var position = 0;
  //StringBuffer out = new StringBuffer();
  var out = newLine();
  do {
    if (lineIndex++ > 0) {
      //out.writeln();
      out = newLine();
    }
    int i;
    readSize = data.length - position;
    if (readSize > blockSize) {
      readSize = blockSize;
    } else if (readSize == 0) {
      // handle after 16/32/48...
      break;
    }

    final buffer = data.sublist(position, position + readSize);
    position += readSize;

    for (i = 0; i < buffer.length; i++) {
      if (i > 0) {
        out!.write(' ');
        if ((i % 4) == 0) {
          out.write(' ');
        }
        if ((i % 16) == 0) {
          out.write(' ');
        }
      }
      final charCode = buffer[i];
      out!.writeCharCode(hex1CodeUint8(charCode));
      out.writeCharCode(hex2CodeUint8(charCode));
    }

    if (i > 0) {
      for (; i < blockSize; i++) {
        if (i > 0) {
          out!.write(' ');
          if ((i % 4) == 0) {
            out.write(' ');
          }
          if ((i % 16) == 0) {
            out.write(' ');
          }
        }
        out!.write('..');
      }
    }

    out!.write('  ');

    for (i = 0; i < readSize; i++) {
      if (i > 0) {
        if ((i % 4) == 0) {
          out.write(' ');
        }
        if ((i % 16) == 0) {
          out.write(' ');
        }
      }

      final charCode = buffer[i];
      bool isPrintable(int charCode) =>
          charCode >= 32 && charCode <= 126; // not including delete
      if (isPrintable(charCode)) {
        out.writeCharCode(charCode);
      } else {
        out.write('?');
      }
    }
    if (i > 0) {
      for (; i < blockSize; i++) {
        if (i > 0) {
          if ((i % 4) == 0) {
            out.write(' ');
          }
          if ((i % 16) == 0) {
            out.write(' ');
          }
        }
        out.write('.');
      }
    }
    // out.println(len);

  } while (readSize == blockSize);

  return out.toString();
}

String oldhexPretty(List<int> data) {
  final blockSize = 16;
  int readSize;
  var lineIndex = 0;
  var position = 0;
  final out = StringBuffer();
  do {
    if (lineIndex++ > 0) {
      out.writeln();
    }
    int i;
    readSize = data.length - position;
    if (readSize > blockSize) {
      readSize = blockSize;
    }

    var buffer = data.sublist(position, position + readSize);
    position += readSize;

    for (i = 0; i < buffer.length; i++) {
      if (i > 0) {
        out.write(' ');
        if ((i % 4) == 0) {
          out.write(' ');
        }
        if ((i % 16) == 0) {
          out.write(' ');
        }
      }
      var charCode = buffer[i];
      out.writeCharCode(hex1CodeUint8(charCode));
      out.writeCharCode(hex2CodeUint8(charCode));
    }

    if (i > 0) {
      for (; i < blockSize; i++) {
        if (i > 0) {
          out.write(' ');
          if ((i % 4) == 0) {
            out.write(' ');
          }
          if ((i % 16) == 0) {
            out.write(' ');
          }
        }
        out.write('..');
      }
    }

    out.write('  ');

    for (i = 0; i < readSize; i++) {
      if (i > 0) {
        if ((i % 4) == 0) {
          out.write(' ');
        }
        if ((i % 16) == 0) {
          out.write(' ');
        }
      }

      final charCode = buffer[i];
      bool isPrintable(int charCode) =>
          charCode >= 32 && charCode <= 126; // not including delete
      if (isPrintable(charCode)) {
        out.writeCharCode(charCode);
      } else {
        out.write('?');
      }
    }
    if (i > 0) {
      for (; i < blockSize; i++) {
        if (i > 0) {
          if ((i % 4) == 0) {
            out.write(' ');
          }
          if ((i % 16) == 0) {
            out.write(' ');
          }
        }
        out.write('.');
      }
    }
    // out.println(len);

  } while (readSize == blockSize);

  return out.toString();
}

// parse any hex string
List<int> parseHexString(String text) {
  final data = <int>[];
  int? firstNibble;

  text.codeUnits.forEach((int charCode) {
    if (firstNibble == null) {
      firstNibble = hexCharValue(charCode);
    } else {
      var secondNibble = hexCharValue(charCode);
      if (secondNibble != null) {
        data.add(firstNibble! * 16 + secondNibble);
        firstNibble = null;
      } else {
        firstNibble = null;
      }
    }
  });
  return data;
}

///
/// convert [data] to "01A1..."
/// returns null if data is null
///
String? toHexString(List<int>? data) {
  if (data == null) {
    return null;
  }
  var sb = StringBuffer();
  for (var byte in data) {
    sb.write(hexUint8(byte));
  }
  return sb.toString();
}

///
/// convert [data] to "01a1..."
/// returns null if data is null
///
String? toLohexString(List<int>? data) {
  if (data == null) {
    return null;
  }
  final sb = StringBuffer();
  for (var byte in data) {
    sb.write(lohexUint8(byte));
  }
  return sb.toString();
}
