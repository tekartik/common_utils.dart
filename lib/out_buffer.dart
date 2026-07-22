/// A fixed-size line buffer that retains only the last appended lines.
class OutBuffer {
  late int _maxLineCount;

  /// The current list of stored lines.
  List<String> lines = [];

  /// Creates an [OutBuffer] holding at most [maxLineCount] lines.
  OutBuffer(int maxLineCount) {
    _maxLineCount = maxLineCount;
  }

  /// Adds a line of [text] to the buffer, trimming oldest lines if capacity is exceeded.
  void add(String text) {
    lines.add(text);
    while (lines.length > _maxLineCount) {
      lines.removeAt(0);
    }
  }

  @override
  String toString() => lines.join('\n');
}
