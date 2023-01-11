import 'dart:typed_data';

/// Convert if necessary
Uint8List asUint8List(List<int> data) {
  if (data is Uint8List) {
    return data;
  }
  return Uint8List.fromList(data);
}

/// Read a stream of bytes
Future<Uint8List> listStreamGetBytes(Stream<List<int>> stream) async {
  var bytes = Uint8List.fromList(
      (await stream.toList()).expand((element) => element).toList());
  return bytes;
}
