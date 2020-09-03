import 'package:test/test.dart';
import 'package:tekartik_common_utils/int_utils.dart';

void main() => defineTests();

void defineTests() {
  test('int.parse', () {
    expect(() => int.parse(null), throwsA(const TypeMatcher<ArgumentError>()));
    expect(() => int.parse(''), throwsA(const TypeMatcher<FormatException>()));
    expect(() => int.parse('a'), throwsA(const TypeMatcher<FormatException>()));
    expect(int.parse('3'), 3);
    expect(
        () => int.parse('3.14'), throwsA(const TypeMatcher<FormatException>()));
  });

  test('parseInt', () {
    expect(parseInt('null'), isNull);
    expect(parseInt(null), null);
    expect(parseInt(''), null);
    expect(parseInt('a'), null);
    expect(parseInt('3'), 3);
    expect(parseInt('3.14'), isNull);
    expect(parseInt('', 1), 1);
    expect(parseInt('a', 2), 2);
    expect(parseInt(null, 3), 3);
  });

  test('parseStartInt', () {
    expect(parseStartInt('null'), isNull);
    expect(parseStartInt(null), null);
    expect(parseStartInt(''), null);
    expect(parseStartInt('a'), null);
    expect(parseStartInt('a3'), null);
    expect(parseStartInt('3'), 3);
    expect(parseStartInt('3.14'), 3);
    expect(parseStartInt('030a'), 30);
  });

  test('parseFirstInt', () {
    expect(parseFirstInt('null'), isNull);
    expect(parseFirstInt(null), null);
    expect(parseFirstInt(''), null);
    expect(parseFirstInt('a'), null);
    expect(parseFirstInt('a3'), 3);
    expect(parseFirstInt('3'), 3);
    expect(parseFirstInt('3.14'), 3);
    expect(parseFirstInt('030a'), 30);
  });
}
