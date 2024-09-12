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

/// Uri extension
extension TekartikUriExtension on Uri {
  /// Remove parameters and fragment
  Uri removeParametersAndFragment() {
    return Uri(
      scheme: scheme,
      userInfo: userInfo,
      host: host,
      port: port,
      path: path,
    );
  }
}
