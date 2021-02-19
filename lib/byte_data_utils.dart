import 'dart:typed_data';

Uint8List byteDataToUint8List(ByteData data) {
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}

ByteData byteDataFromUint8List(Uint8List list) {
  return list.buffer.asByteData(list.offsetInBytes, list.lengthInBytes);
}

ByteData byteDataFromOffset(ByteData data, int offset, [int? length]) {
  length ??= data.lengthInBytes - offset;
  return data.buffer.asByteData(data.offsetInBytes + offset, length);
}
