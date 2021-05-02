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
  var rawRules = (yaml['linter'] as Map)['rules'];
  List<String> rules;
  if (rawRules is List) {
    rules = rawRules.cast<String>();
    return rules;
  }
  throw UnsupportedError('invalid rawRules type ${rawRules.runtimeType}');
}

Future<void> main() async {
  var rules = List<String>.from(await getRules(
      join('lib', 'pedantic', 'analysis_options.strong_mode.yaml')))
    ..sort();

  var dotPackagesMap = await getDotPackagesMap('.');

  var pedanticLibPath = Uri.parse(dotPackagesMap['pedantic']!).toFilePath();
  var pedanticRules =
      await getRules(join(pedanticLibPath, 'analysis_options.1.11.0.yaml'));

  rules.removeWhere((element) => pedanticRules.contains(element));
  rules.forEach((element) {
    print('  - $element');
  });
}
