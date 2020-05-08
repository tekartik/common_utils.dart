import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

Version parsePlatformVersion(String text) {
  return Version.parse(text.split(' ').first);
}

Future main() async {
  var shell = Shell();

  await shell.run('''
  dartanalyzer --fatal-warnings  --fatal-infos lib test tool example
  dartfmt -w lib test tool example --set-exit-if-changed
  ''');

  await shell.run('''
  pub run build_runner test -- -p vm,chrome
  ''');

  await shell.run('''
  pub run test -p vm,firefox,chrome

  ''');
}
