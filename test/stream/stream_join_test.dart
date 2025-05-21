library;

import 'package:tekartik_common_utils/stream/stream_join.dart';
import 'package:test/test.dart';

void main() {
  Stream<Object?> emptyStream() => Stream.fromIterable(<Object?>[]);
  Stream<int?> oneIntStream([int? value = 1]) =>
      Stream.fromIterable(<int?>[value]);
  Stream<int?> oneError([Object error = 'error']) {
    Future<int?> throwError() async {
      throw error;
    }

    return Stream.fromFuture(throwError());
  }

  Stream<String> oneStringStream([String value = '2']) =>
      Stream.fromIterable(<String>[value]);
  Stream<String?> anotherOptionalStringStream([String? value = '3']) =>
      Stream.fromIterable(<String?>[value]);
  group('stream_utils', () {
    test('streamJoin2', () async {
      (int?, String) value;
      value = await streamJoin2(oneIntStream(), oneStringStream()).first;
      expect(value, equals((1, '2')));
    });
    test('streamJoin2AndError', () async {
      (StreamJoinItem<int?>, StreamJoinItem<int?>) value;
      value = await streamJoin2OrError(oneIntStream(), oneError('error')).first;
      expect(
        value,
        equals((
          StreamJoinItem(value: 1),
          StreamJoinItem<int?>(error: 'error'),
        )),
      );
      expect(value.values, equals((1, null)));
    });
    test('streamJoin3', () async {
      (int?, String, String?) value;
      value =
          await streamJoin3(
            oneIntStream(),
            oneStringStream(),
            anotherOptionalStringStream(null),
          ).first;
      expect(value, equals((1, '2', null)));
    });
    test('streamJoin3OrError', () async {
      (int?, String?, String?) value;
      value =
          (await streamJoin3OrError(
                oneIntStream(),
                oneStringStream(),
                anotherOptionalStringStream(null),
              ).first)
              .values;
      expect(value, equals((1, '2', null)));
    });
    test('streamJoin4', () async {
      (int?, String, String?, int?) value;
      value =
          await streamJoin4(
            oneIntStream(),
            oneStringStream(),
            anotherOptionalStringStream(null),
            oneIntStream(10),
          ).first;
      expect(value, equals((1, '2', null, 10)));
    });

    test('streamJoin4OrError', () async {
      (int?, String?, String?, int?) value;
      value =
          (await streamJoin4OrError(
                oneIntStream(),
                oneStringStream(),
                anotherOptionalStringStream(null),
                oneIntStream(10),
              ).first)
              .values;
      expect(value, equals((1, '2', null, 10)));
    });
    test('streamJoinAll', () {
      expect(emptyStream(), emitsInOrder([emitsDone]));
      expect(streamJoinAll([emptyStream()]), emitsInOrder([emitsDone]));

      expect(
        streamJoinAll([emptyStream(), emptyStream()]),
        emitsInOrder([emitsDone]),
      );
      expect(oneIntStream(), emitsInOrder([1, emitsDone]));
      expect(oneIntStream(2), emitsInOrder([2, emitsDone]));
      expect(
        streamJoinAll([oneIntStream(), oneIntStream(2)]),
        emitsInOrder([
          [1, 2],
          emitsDone,
        ]),
      );
      expect(
        streamJoinAll([emptyStream(), oneIntStream()]),
        emitsInOrder([emitsDone]),
      );
      expect(
        streamJoinAll([
          oneIntStream(),
          Stream.fromIterable([2, 3]),
        ]),
        emitsInOrder([
          [1, 2],
          [1, 3],
          emitsDone,
        ]),
      );
      expect(
        streamJoinAll([
          Stream.fromIterable([1, 2, 3]),
          Stream.fromIterable([4, 5]),
        ]),
        emitsInOrder([
          [1, 4],
          [2, 4],
          [2, 5],
          [3, 5],
          emitsDone,
        ]),
      );
      expect(
        streamJoinAll([
          Stream.fromIterable([1]),
          Stream.fromIterable([2, 3]),
          Stream.fromIterable([4, 5, 6]),
        ]),
        emitsInOrder([
          [1, 2, 4],
          [1, 3, 4],
          [1, 3, 5],
          [1, 3, 6],
          emitsDone,
        ]),
      );
    });
    test('streamJoinNull', () async {
      var value =
          await streamJoin2(oneIntStream(null), oneStringStream()).first;
      expect(value, equals((null, '2')));
      var items =
          await streamJoin2OrError(oneIntStream(null), oneStringStream()).first;
      expect(
        items,
        equals((StreamJoinItem<int?>(), StreamJoinItem(value: '2'))),
      );
      var items3 =
          await streamJoin3OrError(
            oneIntStream(null),
            oneStringStream('test'),
            oneError(),
          ).first;
      expect(
        items3.toString(),
        '(Item(<null>), Item(test), Item(error: error))',
      );
      var items4 =
          await streamJoin4OrError(
            oneIntStream(null),
            oneStringStream('test'),
            oneIntStream(5),
            oneError(),
          ).first;
      expect(
        items4.toString(),
        '(Item(<null>), Item(test), Item(5), Item(error: error))',
      );
    });
  });
}
