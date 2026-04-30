import 'package:dev_build/shell.dart';

Future<void> main(List<String> args) async {
  await run('dart test test/env_utils_test.dart -p vm --compiler exe');
}
