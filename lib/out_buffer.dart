/// Simple buffer to keep the last lines
class OutBuffer {
  late int _maxLineCount;

  /// List of lines
  List<String> lines = [];

  /// Create a buffer with a max line count
  OutBuffer(int maxLineCount) {
    _maxLineCount = maxLineCount;
  }

  /// Add a line
  void add(String text) {
    lines.add(text);
    while (lines.length > _maxLineCount) {
      lines.removeAt(0);
    }
  }

  @override
  String toString() => lines.join('\n');
}
