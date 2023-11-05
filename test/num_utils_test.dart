import 'package:tekartik_common_utils/num_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  test('parseNum', () {
    expect(parseNum('null'), isNull);
    num value = 2.3;
    expect(parseNum(value), value);
    expect(parseNum(null), null);
    expect(parseNum(''), null);
    expect(parseNum('a'), null);
    expect(parseNum('3'), 3);
    expect(parseNum('3.14'), 3.14);
    expect(parseNum('', 1), 1);
    expect(parseNum('a', 2), 2);
    expect(parseNum(null, 3), 3);
  });
  test('bounded', () {
    expect(2.boundedMin(1), 2);
    expect(2.boundedMin(3), 3);
    expect(2.boundedMax(1), 1);
    expect(2.boundedMax(3), 2);
    expect(2.bounded(1, 3), 2);
    expect(2.bounded(3, 4), 3);
    expect(2.bounded(0, 1), 1);
    expect(2.bounded(3, 3), 3);
    expect(2.bounded(3, 1), 3);
    expect(2.bounded(1, 1), 1);
    expect(2.0.bounded(1.0, 3.0), 2.0);
  });
}
