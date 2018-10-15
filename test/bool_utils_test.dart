import 'package:tekartik_common_utils/string_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  test('parseBool', () {
    expect(parseBool('null'), isNull);
    expect(parseBool(true), isTrue);
    expect(parseBool(true.toString()), isTrue);
    expect(parseBool("TRUE"), isTrue);
    expect(parseBool("FALSE"), isFalse);
    expect(parseBool(false.toString()), isFalse);
    expect(parseBool(null), null);
    expect(parseBool(''), null);
    expect(parseBool('a'), null);
    expect(parseBool('3.14'), isTrue);
    expect(parseBool('-7'), isTrue);
    expect(parseBool('0'), isFalse);
    expect(parseBool('0.0'), isFalse);
    expect(parseBool(0), isFalse);
    expect(parseBool(0.0), isFalse);
    expect(parseBool('', true), true);
    expect(parseBool('a', false), false);
    expect(parseBool(null, true), true);
    expect(parseBool(null, false), isFalse);
  });
}
