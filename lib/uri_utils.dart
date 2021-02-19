/// Typically the argument is window.location.search
Map<String, String> locationSearchGetArguments(String? search) {
  final params = <String, String>{};
  if (search != null) {
    var questionMarkIndex = search.indexOf('?');
    if (questionMarkIndex != -1) {
      search = search.substring(questionMarkIndex + 1);
    }
    return Uri.splitQueryString(search);
  }
  return params;
}
