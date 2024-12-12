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

/// Parse a version or return null, add support for version X.X, X.X.X.X
/// if strict, null or valid version are allowed
Version? parseVersionOrNull(String? text, {bool? strict}) {
  if (text == null) {
    return null;
  }
  try {
    return parseVersion(text);
  } on FormatException catch (_) {
    if (strict ?? false) {
      rethrow;
    }
    return null;
  }
}

/// Add support for version X.X, X.X.X.X not supported in platform version
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
      return List.of(list)..[list.length - 1 - index] = item + 1;
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

  /// Bump a version
  /// If nothing is specified, it will bump the build or prelease number if present
  /// or the patch version if no build or prelease is present.
  Version bump({bool? patch, bool? minor, bool? major, bool? ext}) {
    major ??= false;
    minor ??= false;

    patch ??= false;

    ext ??= false;
    var version = this;

    if (!patch && !minor && !major && !ext) {
      if (version.isPreRelease || version.build.isNotEmpty) {
        ext = true;
      } else {
        patch = true;
      }
    }
    var majorVersion = version.major;
    var minorVersion = version.minor;
    var patchVersion = version.patch;
    if (major) {
      majorVersion++;
      minorVersion = 0;
      patchVersion = 0;
    } else if (minor) {
      minorVersion++;
      patchVersion = 0;
    } else if (patch) {
      patchVersion++;
    }
    version = Version(majorVersion, minorVersion, patchVersion,
        pre:
            (ext && version.isPreRelease) ? version.preRelease.join('.') : null,
        build:
            (ext && version.build.isNotEmpty) ? version.build.join('.') : null);
    if (ext) {
      version = version.nextPreReleaseOrBuild;
    }
    return version;
  }
}
