import 'package:dev_build/shell.dart';

Future<void> main(List<String> args) async {
  await run('dart test -p vm --compiler exe');
}
