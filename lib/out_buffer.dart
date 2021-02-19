class OutBuffer {
  late int _maxLineCount;
  List<String> lines = [];

  OutBuffer(int maxLineCount) {
    _maxLineCount = maxLineCount;
  }

  void add(String text) {
    lines.add(text);
    while (lines.length > _maxLineCount) {
      lines.removeAt(0);
    }
  }

  @override
  String toString() => lines.join('\n');
}
