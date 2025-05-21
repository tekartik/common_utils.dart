// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dev_build/menu/menu_io.dart';
import 'package:tekartik_common_utils/async_utils.dart';
import 'package:tekartik_common_utils/future_utils.dart';
import 'package:tekartik_common_utils/lazy_runner/lazy_runner.dart';

Future<void> main(List<String> args) async {
  mainMenuConsole(args, () {
    item('toogle debug', () {
      debugLazyRunner = !debugLazyRunner;
      print('debugLazyRunner: $debugLazyRunner');
    });
    item('Periodic', () async {
      print('every 1s for 5s');
      var runner = LazyRunner.periodic(
        duration: const Duration(milliseconds: 1000),
        action: (count) async {
          print('my action $count');
        },
      );
      await sleep(5000);
      runner.dispose();
    });
    item('Triggered', () async {
      var runner = LazyRunner(
        action: (count) async {
          print('my action $count');
        },
      );

      print('Delay 1s during 5s triggerd twice after 1.2s, 3.5s, 3.7s');
      () async {
        await sleep(1200);
        runner.trigger();
        await sleep(2300);
        runner.trigger();
        await sleep(200);
        runner.trigger();
      }().unawait();
      await sleep(5000);
      runner.dispose();

      print('running');
    });
    item('Triggered and periodic', () async {
      var sw = Stopwatch()..start();
      var runner = LazyRunner.periodic(
        duration: const Duration(milliseconds: 1000),
        action: (count) async {
          print('my action $count - ${sw.elapsedMilliseconds} ms');
        },
      );

      print('Delay 1s during 5s triggerd twice after 1.2s, 3.5s, 3.7s');
      () async {
        await sleep(1200);
        runner.trigger();
        await sleep(2300);
        runner.trigger();
        await sleep(200);
        runner.trigger();
      }().unawait();
      await sleep(5000);
      runner.dispose();

      print('running');
    });
    item('Triggered multiple times', () async {
      var runner = LazyRunner(
        action: (count) async {
          print('my action starts $count');
          await sleep(400);
          print('my action ends $count');
        },
      );

      print(
        'Delay 1s during 5s triggerd twice after 0.5s, 1.5s trigger 6 times every 200ms',
      );
      () async {
        await sleep(500);
        runner.trigger();
        await sleep(1000);
        runner.trigger();
        await sleep(200);
        runner.trigger();
        await sleep(200);
        runner.trigger();
        await sleep(200);
        runner.trigger();
        await sleep(200);
        runner.trigger();
        await sleep(200);
        runner.trigger();
        await sleep(200);
        runner.trigger();
      }().unawait();
      await sleep(5000);
      runner.dispose();

      print('running');
    });
  });
}
