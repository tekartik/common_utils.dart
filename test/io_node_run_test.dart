@TestOn('vm')
library;

import 'package:dev_build/shell.dart';
import 'package:process_run/stdio.dart';
import 'package:test/test.dart';

Future<void> main() async {
  var nodeIsSupported = (await which('node')) != null;
  test('[dart test -p node]', () async {
    var sw = Stopwatch()..start();
    await run('dart test  --platform node --compiler dart2js');
    sw.stop();
    stdout.writeln('dart test -p node - Elapsed: ${sw.elapsed}');
  }, skip: !nodeIsSupported, timeout: const Timeout(Duration(minutes: 10)));
  // 17 seconds on a i9 12900K 64GB RAM
}
