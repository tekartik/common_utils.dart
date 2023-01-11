import 'dart:async';

import 'package:tekartik_common_utils/completer/completer.dart'; // ignore: deprecated_member_use, deprecated_member_use_from_same_package
import 'package:test/test.dart';

class TestException implements Exception {}

void main() {
  group('completer', () {
    test('mini cancel', () async {
      var completer = CancellableCompleter<void>(sync: true);
      // This is needed to prevent a crash in unit test
      unawaited(completer.future.catchError((_) => null));
      completer.cancel();
      try {
        await completer.future;
      } on CancelException catch (_) {}
    });
    Future testValue([bool? sync]) async {
      var completer = CancellableCompleter(value: 1, sync: sync);
      final value = completer.value;
      expect(identical(value, completer.future), isFalse);
      expect(completer.value, 1);
      expect(await completer.future, 1);
      expect(await completer.value, 1);
      expect(completer.isCancelled, isFalse);
      completer.cancel();
      expect(completer.isCancelled, isTrue);

      // Ok to cancel again
      completer.cancel();
      expect(completer.isCancelled, isTrue);

      try {
        completer.complete();
        fail('should fail');
      } on StateError catch (_) {}
    }

    test('value', () {
      return testValue();
    });
    test('sync_value', () {
      return testValue(true);
    });
    test('async_value', () {
      return testValue(false);
    });

    Future testComplete([bool? sync]) async {
      var completer = CancellableCompleter<int>(sync: sync);

      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      var completed = false;
      unawaited(completer.future.then((_) {
        completed = true;
      }));
      completer.complete(1);
      // Main difference between sync and async here
      expect(completed, sync == true);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isTrue);
      expect(completer.value, 1);
      expect(await completer.future, 1);
      // Ok to cancel
      completer.cancel();
      expect(completer.isCancelled, isTrue);
      expect(completer.error, isNull);

      try {
        completer.complete();
        fail('should fail');
      } on StateError catch (_) {}
    }

    test('complete', () {
      return testComplete();
    });
    test('sync_complete', () {
      return testComplete(true);
    });
    test('async_complete', () {
      return testComplete(false);
    });

    Future testCompleteError([bool? sync]) async {
      var completer = CancellableCompleter<Object?>(sync: sync);

      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      expect(completer.error, isNull);
      var completed = false;
      unawaited(completer.future.catchError((_) {
        completed = true;
        return null;
      }));
      completer.completeError(TestException());
      // Main difference between sync and async here
      expect(completed, sync == true);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isTrue);
      expect(completer.value, const TypeMatcher<Future>());
      expect(completer.error, const TypeMatcher<TestException>());
      try {
        expect(await completer.future, isNull);
        fail('should fail');
      } on TestException catch (_) {}
      // Ok to cancel
      completer.cancel();
      expect(completer.isCancelled, isTrue);

      try {
        completer.complete();
        fail('should fail');
      } on StateError catch (_) {}
    }

    test('complete_error', () {
      return testCompleteError();
    });
    test('sync_complete_error', () {
      return testCompleteError(true);
    });
    test('async_complete_error', () {
      return testCompleteError(false);
    });

    Future testCancel([bool? sync]) async {
      var completer = CancellableCompleter<Object?>(sync: sync);
      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      var cancelled = false;
      unawaited(completer.future.catchError((_) {
        cancelled = true;
        return null;
      }));
      completer.cancel();
      // Main difference between sync and async here
      expect(cancelled, sync == true);
      expect(completer.isCancelled, isTrue);
      expect(completer.isCompleted, isTrue);
      expect(completer.error, const TypeMatcher<CancelException>());

      try {
        expect(await completer.future, isNull);
        fail('should fail');
      } on CancelException catch (_) {}

      // Ok to cancel
      completer.cancel();
      expect(completer.isCancelled, isTrue);

      try {
        completer.complete();
        fail('should fail');
      } on StateError catch (_) {}
    }

    test('cancel', () {
      return testCancel();
    });
    test('sync_cancel', () {
      return testCancel(true);
    });
    test('async_cancel', () {
      return testCancel(false);
    });
  });
}
