import 'package:tekartik_common_utils/string_enum.dart';
import 'package:test/test.dart';

class TwoChoicesEnum extends StringEnum {
  const TwoChoicesEnum(super.name);
  static final TwoChoicesEnum choice1 = const TwoChoicesEnum('choice1');
  static final TwoChoicesEnum choice2 = const TwoChoicesEnum('choice2');
}

void main() => defineTests();

void defineTests() {
  test('string enum', () {
    expect(TwoChoicesEnum.choice1.value, 'choice1');
    expect(TwoChoicesEnum.choice2.value, 'choice2');
  });
}
