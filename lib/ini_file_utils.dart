/// Parse ini lines from file
Map<String, String> parseIniLines(Iterable<String> contents) {
  final results = <String, String>{};

  final properties = contents
      .map<String>((String l) => l.trim())
      // Strip blank lines/comments
      .where((String l) => l != '' && !l.startsWith('#'))
      // Discard anything that isn't simple name=value
      .where((String l) => l.contains('='))
      // Split into name/value
      .map<List<String>>((String l) => l.split('='));

  for (var property in properties) {
    results[property[0].trim()] = property[1].trim();
  }

  return results;
}
