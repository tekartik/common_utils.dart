class Fifo<T> {
  List<T> _list = [];
  void push(T value) => _list.add(value);
  T pop() {
    if (_list.isNotEmpty) {
      T value = _list.first;
      _list.removeAt(0);
      return value;
    }
    return null;
  }

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;
}
