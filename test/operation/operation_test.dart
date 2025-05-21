import 'dart:async';

import 'package:tekartik_common_utils/operation/operation.dart';
import 'package:test/test.dart';

void main() {
  group('operation', () {
    test('first_action', () async {
      var count = 0;
      var operation = Operation(
        action: () {
          count++;
          return null;
        },
      );
      operation.trigger();
      expect(count, 1);
      operation.trigger();
      expect(count, 1);
      await Future<void>.delayed(const Duration());
      expect(count, 2);
      await Future<void>.delayed(const Duration());
      expect(count, 2);
    });
    test('multiple_triggers', () async {
      var count = 0;
      var operation = Operation(
        action: () {
          count++;
          return null;
        },
      );
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future<void>.delayed(const Duration());
      expect(count, 2);
      await Future<void>.delayed(const Duration());
      expect(count, 2);
    });

    test('delay', () async {
      var count = 0;
      var operation = Operation(
        action: () {
          count++;
          return null;
        },
        delay: const Duration(milliseconds: 100),
      );
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      operation.trigger();
      operation.trigger();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(count, 2);
    });

    test('concurrency', () async {
      var count = 0;
      var operation = Operation(
        action: () {
          count++;
          return Future<void>.delayed(const Duration(milliseconds: 100));
        },
      );
      operation.trigger();
      operation.trigger();
      expect(count, 1);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      operation.trigger();
      operation.trigger();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(count, 2);
    });
  });
}
