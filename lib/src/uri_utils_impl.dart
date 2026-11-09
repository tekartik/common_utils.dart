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
    // Only pass the authority parts the uri has: an empty host or the
    // default port would add an empty authority (`///a` for `/a`).
    return Uri(
      scheme: scheme,
      userInfo: hasAuthority ? userInfo : null,
      host: hasAuthority ? host : null,
      port: hasPort ? port : null,
      path: path,
    );
  }
}
