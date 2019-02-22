import 'package:pedantic/pedantic.dart';
import 'package:tekartik_common_utils/completer/completer.dart';
import 'package:test/test.dart';

class TestException implements Exception {}

void main() {
  group('completer', () {
    Future _testValue([bool sync]) async {
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
      return _testValue();
    });
    test('sync_value', () {
      return _testValue(true);
    });
    test('async_value', () {
      return _testValue(false);
    });

    Future _testComplete([bool sync]) async {
      var completer = CancellableCompleter(sync: sync);

      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      bool completed = false;
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

      try {
        completer.complete();
        fail('should fail');
      } on StateError catch (_) {}
    }

    test('complete', () {
      return _testComplete();
    });
    test('sync_complete', () {
      return _testComplete(true);
    });
    test('async_complete', () {
      return _testComplete(false);
    });

    Future _testCompleteError([bool sync]) async {
      var completer = CancellableCompleter(sync: sync);

      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      bool completed = false;
      unawaited(completer.future.catchError((_) {
        completed = true;
      }));
      completer.completeError(TestException());
      // Main difference between sync and async here
      expect(completed, sync == true);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isTrue);
      expect(completer.value, isNull);
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
      return _testCompleteError();
    });
    test('sync_complete_error', () {
      return _testCompleteError(true);
    });
    test('async_complete_error', () {
      return _testCompleteError(false);
    });

    Future _testCancel([bool sync]) async {
      var completer = CancellableCompleter(sync: sync);
      final value = completer.value;
      expect(identical(value, completer.future), isTrue);
      expect(completer.isCancelled, isFalse);
      expect(completer.isCompleted, isFalse);
      bool cancelled = false;
      unawaited(completer.future.catchError((_) {
        cancelled = true;
      }));
      completer.cancel();
      // Main difference between sync and async here
      expect(cancelled, sync == true);
      expect(completer.isCancelled, isTrue);
      expect(completer.isCompleted, isTrue);

      expect(completer.value, isNull);
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
      return _testCancel();
    });
    test('sync_cancel', () {
      return _testCancel(true);
    });
    test('async_cancel', () {
      return _testCancel(false);
    });
  });
}
