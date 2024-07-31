/// A simple FIFO queue implementation.
class Fifo<T> {
  final _list = <T>[];

  /// Push a value to the end of the queue.
  void push(T value) => _list.add(value);

  /// Pop a value from the front of the queue.
  T? pop() {
    if (_list.isNotEmpty) {
      var value = _list.first;
      _list.removeAt(0);
      return value;
    }
    return null;
  }

  /// True if empty
  bool get isEmpty => _list.isEmpty;

  /// True if not empty
  bool get isNotEmpty => _list.isNotEmpty;
}
