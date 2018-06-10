import 'package:test/test.dart';
import 'package:tekartik_common_utils/string_utils.dart' as stru;
import 'package:tekartik_common_utils/string_utils.dart';

main() {
  test('parseInt', () {
    expect(stru.parseInt("456", 1), equals(456));
    expect(stru.parseInt("sd456", 1), equals(1));
    expect(stru.parseInt("sd456", null), null);
    expect(stru.parseInt("0x10", 1), equals(16));
    expect(stru.parseInt(null, 1), equals(1));
    expect(stru.parseInt('', 1), equals(1));
  });

  test('parseBool', () {
    // up to 2017-08
    // expect(stru.parseBool("456"), false);
    expect(stru.parseBool("456"), isTrue);
    expect(stru.parseBool("true"), true);
    expect(stru.parseBool("1"), true);
    expect(stru.parseBool(null, true), true);
    expect(stru.parseBool(null, false), false);
    // up to 2017-08
    // expect(stru.parseBool(null), false);
    expect(stru.parseBool(null), isNull);
    expect(stru.parseBool('', true), true);
  });

  test('isEmpty', () {
    expect(stringIsEmpty("456"), isFalse);
    expect(stringIsEmpty(null), isTrue);
    expect(stringIsEmpty(""), isTrue);
    expect(stringIsEmpty(" "), isFalse);
  });

  test('prefill', () {
    expect(stru.prefilled("456", 6, ' '), '   456');
    expect(stru.prefilled("456", 5, '000'), '000456');
  });

  test('nonNull', () {
    expect(stringNonNull("456", null), '456');
    expect(stringNonNull(null, null), null);
    expect(stringNonNull(null, "456"), "456");
    expect(stringNonNull(null), "");
  });

  test('nonEmpty', () {
    expect(stringNonEmpty("456", null), '456');
    expect(stringNonEmpty("", null), isNull);
    expect(stringNonEmpty(null, "456"), "456");
    expect(stringNonEmpty(""), isNull);
    expect(stringNonEmpty(null), isNull);
    expect(stringNonEmpty("123"), "123");
  });
}
