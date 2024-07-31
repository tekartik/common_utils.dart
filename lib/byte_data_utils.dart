import 'dart:typed_data';

/// Convert a [ByteData] to a [Uint8List].
Uint8List byteDataToUint8List(ByteData data) {
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

/// Convert a [Uint8List] to a [ByteData].
ByteData byteDataFromUint8List(Uint8List list) {
  return list.buffer.asByteData(list.offsetInBytes, list.lengthInBytes);
}

/// Create a [ByteData] from a [ByteData] with an offset and optional length.
ByteData byteDataFromOffset(ByteData data, int offset, [int? length]) {
  length ??= data.lengthInBytes - offset;
  return data.buffer.asByteData(data.offsetInBytes + offset, length);
}
