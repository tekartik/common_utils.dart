library tekartik_version_utils;

import 'package:pub_semver/pub_semver.dart';
export 'package:pub_semver/pub_semver.dart';

/// Regex that matches a version number at the beginning of a string.
final _startVersion = RegExp(r'^' // Start at beginning.
    r'(\d+).((\d+))?' // Version number.
    );

/// Like [_startVersion] but matches the entire string.
final _completeVersion = RegExp("${_startVersion.pattern}\$");

// Handle String with 4 numbers
/// Regex that matches a version number at the beginning of a string.
final _fourNumberStartVersion = RegExp(r'^' // Start at beginning.
        r'(\d+).(\d+).(\d+).([0-9A-Za-z-]*)') // Version number.
    ;

/// Like [_startVersion] but matches the entire string.
final _fourNumberCompleteVersion =
    RegExp("${_fourNumberStartVersion.pattern}\$");

/// Add support for version X, X.X not supported in platform version
Version parseVersion(String text) {
  try {
    return Version.parse(text);
  } on FormatException catch (e, _) {
    Match match = _completeVersion.firstMatch(text);
    if (match != null) {
      try {
        //      print(match[0]);
        //      print(match[1]);
        //      print(match[2]);
        int major = int.parse(match[1]);
        int minor = int.parse(match[2]);

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
          int major = int.parse(match[1]);
          int minor = int.parse(match[2]);
          int patch = int.parse(match[3]);
          String build = match[4];

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
