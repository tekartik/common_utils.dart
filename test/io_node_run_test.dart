@TestOn('vm')
library;

import 'package:dev_build/shell.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var nodeIsSupported = (await which('node')) != null;
  test('[dart test -p node]', () async {
    await run('dart test  --platform node --compiler dart2js');
  }, skip: !nodeIsSupported);
}
