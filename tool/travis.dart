import 'package:dev_test/package.dart';
import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();

  await packageRunCi('.', noTest: true);

  await shell.run('''
  dart pub run build_runner test -- -p vm,chrome
  ''');

  await shell.run('''
  dart test -p vm,firefox,chrome
  ''');
}
