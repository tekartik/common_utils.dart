import 'package:tekartik_common_utils/int_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  test('int.parse', () {
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
}
