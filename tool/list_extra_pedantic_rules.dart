import 'dart:io';

import 'package:path/path.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:yaml/yaml.dart';

/// Read info from `.packages` file, key being the package, value being the path
Future<Map<String, String>> getDotPackagesMap(String packageRoot) async {
  final yamlPath = join(packageRoot, '.packages');
  final content = await File(yamlPath).readAsString();

  final map = <String, String>{};
  final lines = LineSplitter.split(content);
  for (var line in lines) {
    line = line.trim();
    if (!line.startsWith('#')) {
      final separator = line.indexOf(':');
      if (separator != -1) {
        map[line.substring(0, separator)] = line.substring(separator + 1);
      }
    }
  }
  return map;
}

Future<List<String>> getRules(String path) async {
  var yaml = loadYaml(await File(path).readAsString()) as Map;
  try {
    var rawRules = (yaml['linter'] as Map)['rules'];
    List<String> rules;
    if (rawRules is List) {
      rules = List<String>.from(rawRules.cast<String>())..sort();
      return rules;
    }
    throw UnsupportedError('invalid rawRules type ${rawRules.runtimeType}');
  } catch (e) {
    stderr.writeln('fail to read linter rules in $path');
    rethrow;
  }
}

Future<void> _writeRules(String name, List<String> rules) async {
  var sb = StringBuffer();
  for (var element in rules) {
    sb.writeln('  - $element');
  }
  await Directory('.local').create(recursive: true);
  await File(join('.local', '${name}_rules.txt')).writeAsString(sb.toString());
}

Future<void> main() async {
  var rules = await getRules(join('lib', 'pedantic', 'analysis_options.yaml'));
  await _writeRules('tekartik', rules);

  var dotPackagesMap = await getDotPackagesMap('.');

  var pedanticLibPath = Uri.parse(dotPackagesMap['pedantic']!).toFilePath();
  var lintsLibPath = Uri.parse(dotPackagesMap['lints']!).toFilePath();
  var pedanticRules = await getRules(
    join(pedanticLibPath, 'analysis_options.1.11.0.yaml'),
  );
  await _writeRules('pedantic', pedanticRules);
  var lintsRules = await getRules(join(lintsLibPath, 'recommended.yaml'));
  await _writeRules('lints', lintsRules);

  var diffRules = List<String>.from(rules);
  diffRules.removeWhere((element) => pedanticRules.contains(element));
  await _writeRules('pedantic_diff', diffRules);
  diffRules = List<String>.from(rules);
  diffRules.removeWhere((element) => lintsRules.contains(element));
  await _writeRules('lints_diff', diffRules);
  diffRules = List<String>.from(lintsRules);
  diffRules.removeWhere((element) => pedanticRules.contains(element));
  await _writeRules('lints_over_pedantic', diffRules);
  diffRules = List<String>.from(pedanticRules);
  diffRules.removeWhere((element) => lintsRules.contains(element));
  await _writeRules('pedantic_over_lints', diffRules);

  var all =
      <String>{}
        ..addAll(rules)
        ..addAll(pedanticRules)
        ..addAll(lintsRules);
  diffRules = List<String>.from(all)..sort();
  diffRules.removeWhere((element) => lintsRules.contains(element));
  await _writeRules('tekartik_recommended_over_lints', diffRules);
}
