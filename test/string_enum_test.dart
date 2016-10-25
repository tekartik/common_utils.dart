import 'package:tekartik_common_utils/string_enum.dart';
import 'package:dev_test/test.dart';

class TwoChoicesEnum extends StringEnum {
  const TwoChoicesEnum(String name) : super(name);
  static final TwoChoicesEnum CHOICE1 = const TwoChoicesEnum("choice1");
  static final TwoChoicesEnum CHOICE2 = const TwoChoicesEnum("choice2");
}

void main() => defineTests();

void defineTests() {
  test('string enum', () {
    expect(TwoChoicesEnum.CHOICE1.value, "choice1");
    expect(TwoChoicesEnum.CHOICE2.value, "choice2");
  });
}
