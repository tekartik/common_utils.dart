import 'dart:async';

import 'package:tekartik_common_utils/operation/operation.dart';
import 'package:test/test.dart';

void main() {
  group('operation', () {
    test('first_action', () async {
      int count = 0;
      var operation = Operation(action: () {
        count++;
      });
      operation.trigger();
      expect(count, 1);
      operation.trigger();
      expect(count, 1);
      await Future.delayed(Duration());
      expect(count, 2);
      await Future.delayed(Duration());
      expect(count, 2);
    });
    test('multiple_triggers', () async {
      int count = 0;
      var operation = Operation(action: () {
        count++;
      });
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future.delayed(Duration());
      expect(count, 2);
      await Future.delayed(Duration());
      expect(count, 2);
    });

    test('delay', () async {
      int count = 0;
      var operation = Operation(
          action: () {
            count++;
          },
          delay: Duration(milliseconds: 100));
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future.delayed(Duration(milliseconds: 50));
      operation.trigger();
      operation.trigger();
      await Future.delayed(Duration(milliseconds: 100));
      expect(count, 2);
    });

    test('concurrency', () async {
      int count = 0;
      var operation = Operation(
        action: () {
          count++;
          return Future.delayed(Duration(milliseconds: 100));
        },
      );
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future.delayed(Duration(milliseconds: 50));
      operation.trigger();
      operation.trigger();
      await Future.delayed(Duration(milliseconds: 100));
      expect(count, 2);
    });
  });
}