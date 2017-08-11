class OutBuffer {
  int _maxLineCount;
  List<String> lines = [];

  OutBuffer(int maxLineCount) {
    _maxLineCount = maxLineCount ?? 100;
  }

  void add(String text) {
    lines.add(text);
    while (lines.length > _maxLineCount) {
      lines.removeAt(0);
    }
  }

  String toString() => lines.join("\n");
}
