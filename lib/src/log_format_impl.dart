import 'package:cv/cv.dart';
import 'package:cv/utils/value_utils.dart';
import 'package:tekartik_common_utils/string_utils.dart';

/// Basic type (string) truncate length
const _logBasicTypeTruncateLengthDefault = 100;

/// Final type (typically list or amp) truncate length
const _logFinalTypeTruncateLengthDefault = 320;

/// Map truncate length
const _logMapTruncateLengthDefault = 5;

/// list truncate length
const _logListTruncateLengthDefault = 5;

/// depth truncate size
const _logTruncateDepthDefault = 3;

/// Global log format options, to allow chaning globally
LogFormatOptions globalLogFormatOptions =
    const LogFormatOptions.defaultOptions();

/// Null for no truncation
int? get logMapTruncateLength => globalLogFormatOptions.mapTruncateLength;

/// Null for no truncation
int? get logBasicTypeTruncateLength =>
    globalLogFormatOptions.basicTypeTruncateLength;

/// Log format options
class LogFormatOptions {
  /// Basic type truncate length
  final int? basicTypeTruncateLength;

  /// Final type truncate length
  final int? finalTypeTruncateLength;

  /// Final type truncate depth
  final int? depth;

  /// Map truncate length
  final int? mapTruncateLength;

  /// List truncate length
  final int? listTruncateLength;

  /// Constructor
  const LogFormatOptions(
      {this.basicTypeTruncateLength,
      this.finalTypeTruncateLength,
      this.mapTruncateLength,
      this.listTruncateLength,
      this.depth});

  /// Constructor with default options.
  const LogFormatOptions.defaultOptions(
      {this.basicTypeTruncateLength = _logBasicTypeTruncateLengthDefault,
      this.finalTypeTruncateLength = _logFinalTypeTruncateLengthDefault,
      this.mapTruncateLength = _logMapTruncateLengthDefault,
      this.listTruncateLength = _logListTruncateLengthDefault,
      this.depth = _logTruncateDepthDefault});
}

/// Truncate a string
String logTruncateString(String value, {int? length}) {
  length ??= logBasicTypeTruncateLength;
  if (length != null) {
    return value.truncate(length);
  }
  return value;
}

Object _convertBasicValue(Object object, {int? length}) {
  if (object is String) {
    return logTruncateString(object, length: length);
  }
  return object;
}

class _Converter {
  final LogFormatOptions options;
  final _innerCollections = <Object>{};

  String _truncateString(String value) {
    return logTruncateString(value, length: options.basicTypeTruncateLength);
  }

  _Converter({this.options = const LogFormatOptions()});
  Map<String, Object?> jsObjectToMap(Map map, {int? depth}) {
    // Stop
    if (depth == 0) {
      return {'.': '.'};
    }

    var newMap = newModel();
    var count = 0;
    for (var entry in map.entries) {
      if ((options.mapTruncateLength != null) &&
          (count++ > options.mapTruncateLength!)) {
        break;
      }
      var key = _truncateString(entry.key.toString());
      var value = entry.value;
      newMap[key] = _convertInnerOrNull(value, depth: _nextDepth(depth));
    }
    return newMap;
  }

  Object? _convertInnerOrNull(Object? value, {int? depth}) {
    if (value == null) {
      return null;
    }

    return _convertInner(value, depth: depth);
  }

  Object _convertInner(Object value, {int? depth}) {
    if (value.runtimeType.isBasicType) {
      return _convertBasicValue(value);
    }
    if (value is List) {
      return jsArrayToList(value, depth: depth);
    } else if (value is Map) {
      return jsObjectToMap(value, depth: depth);
    }
    return logTruncateString(value.toString());
  }

  int? _nextDepth(int? depth) {
    if (depth == null) {
      return null;
    }
    return depth - 1;
  }

  List jsArrayToList(List list, {int? depth}) {
    if (depth == 0) {
      return ['..'];
    }
    _innerCollections.add(list);
    return list
        .map((e) => _convertInnerOrNull(e, depth: _nextDepth(depth)))
        .toList();
  }
}

/// Format to a shorted object
Object? logFormatConvert(Object? value, {LogFormatOptions? options}) {
  if (value == null || value is num || value is bool) {
    return value;
  }
  options ??= globalLogFormatOptions;
  var converter = _Converter(options: options);
  return converter._convertInner(value, depth: options.depth);
}

/// Log format any value
String logFormat(Object? value, {LogFormatOptions? options}) {
  var text = logFormatConvert(value, options: options)?.toString();
  if (text == null) {
    return '<null>';
  }
  options ??= globalLogFormatOptions;
  if (options.finalTypeTruncateLength != null) {
    return text.truncate(options.finalTypeTruncateLength!);
  }
  return text;
}
