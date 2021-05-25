import 'dart:typed_data';

/// Convert if necessary
Uint8List asUint8List(List<int> data) {
  if (data is Uint8List) {
    return data;
  }
  return Uint8List.fromList(data);
}
