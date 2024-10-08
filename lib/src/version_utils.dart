import 'package:pub_semver/pub_semver.dart';

/// Regex that matches a version number at the beginning of a string.
final _startVersion = RegExp(r'^' // Start at beginning.
    r'(\d+).((\d+))?' // Version number.
    );

/// Like [_startVersion] but matches the entire string.
final _completeVersion = RegExp('${_startVersion.pattern}\$');

// Handle String with 4 numbers
/// Regex that matches a version number at the beginning of a string.
final _fourNumberStartVersion = RegExp(r'^' // Start at beginning.
        r'(\d+).(\d+).(\d+).([0-9A-Za-z-]*)') // Version number.
    ;

/// Like [_startVersion] but matches the entire string.
final _fourNumberCompleteVersion =
    RegExp('${_fourNumberStartVersion.pattern}\$');

/// Add support for version X, X.X not supported in platform version
Version parseVersion(String text) {
  try {
    return Version.parse(text);
  } on FormatException catch (e) {
    Match? match = _completeVersion.firstMatch(text);
    if (match != null) {
      try {
        //      print(match[0]);
        //      print(match[1]);
        //      print(match[2]);
        var major = int.parse(match[1]!);
        var minor = int.parse(match[2]!);

        return Version(major, minor, 0);
      } on FormatException catch (_) {
        throw e;
      }
    } else {
      match = _fourNumberCompleteVersion.firstMatch(text);
      if (match != null) {
        try {
          //      print(match[0]);
          //      print(match[1]);
          //      print(match[2]);
          var major = int.parse(match[1]!);
          var minor = int.parse(match[2]!);
          var patch = int.parse(match[3]!);
          var build = match[4];

          return Version(major, minor, patch, build: build);
        } on FormatException catch (_) {
          throw e;
        }
      } else {
        throw FormatException('Could not parse "$text".');
      }
    }
  }
}

List<Object> _bumpPreReleaseOrBuild(List<Object> list) {
  for (var part in list.reversed.indexed) {
    var (index, item) = part;

    if (item is int) {
      return List.of(list)..[index] = item + 1;
    }
  }
  return [...list, 0];
}

/// Common helper
extension TekartikVersionExt on Version {
  /// Remove pre release and build
  Version get noPreReleaseOrBuild {
    return Version(major, minor, patch);
  }

  /// Bump the last number in either pre release or build
  Version get nextPreReleaseOrBuild {
    if (isPreRelease) {
      return Version(major, minor, patch,
          pre: _bumpPreReleaseOrBuild(preRelease).join('.'));
    } else {
      return Version(major, minor, patch,
          build: _bumpPreReleaseOrBuild(build).join('.'));
    }
  }
}
