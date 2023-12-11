import 'package:tekartik_common_utils/cast_utils.dart';
import 'package:test/test.dart';

void main() {
  int nonNullableInt;
  int? nullableInt;

  group('cast_utils', () {
    test('castAsNullable', () {
      expect(castAsNullable<int>(null), isNull);
      expect(castAsNullable<int>(1), 1);
      expect(castAsNullable<int?>(null), isNull);

      void nullableFunction(int? value) {}
      void nonNullFunction(int value) {}
      nonNullableInt = 1;
      nullableInt = 2;
      nullableFunction(nullableInt);
      nullableFunction(nonNullableInt);
      nonNullFunction(nullableInt!);
      // ! required here
      nonNullFunction(castAsNullable(nonNullableInt)!);
      nonNullFunction(castAsNullable(nullableInt)!);
      nonNullFunction(nonNullableInt);
    });
    test('castAsOrNull', () {
      expect(castAsOrNull<int>(1), 1);
      expect(castAsOrNull<int>('1'), isNull);
      expect(castAsOrNull<int>(null), isNull);
      expect(castAsOrNull<int?>(null), isNull);
    });
  });
}
