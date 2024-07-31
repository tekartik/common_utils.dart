// ignore_for_file: avoid_print

import 'package:dev_build/build_support.dart';
import 'package:process_run/shell.dart';

Future<void> main() async {
  await checkAndActivateWebdev();
  await run('webdev build --output example:build/example');
  print('http://localhost:8080');
  await Shell().cd('build/example/env_utils').run('dhttpd');
}
