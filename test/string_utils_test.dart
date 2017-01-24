import 'package:test/test.dart';
import 'package:tekartik_common_utils/string_utils.dart' as stru;

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
    expect(stru.parseBool("456"), false);
    expect(stru.parseBool("true"), true);
    expect(stru.parseBool("1"), true);
    expect(stru.parseBool(null, true), true);
    expect(stru.parseBool(null, false), false);
    expect(stru.parseBool(null), false);
    expect(stru.parseBool('', true), true);
  });

  test('isEmpty', () {
    expect(stru.isEmpty("456"), isFalse);
    expect(stru.isEmpty(null), isTrue);
    expect(stru.isEmpty(""), isTrue);
    expect(stru.isEmpty(" "), isFalse);
  });

  test('prefill', () {
    expect(stru.prefilled("456", 6, ' '), '   456');
    expect(stru.prefilled("456", 5, '000'), '000456');
  });

  test('nonNull', () {
    expect(stru.nonNull("456", null), '456');
    expect(stru.nonNull(null, null), null);
    expect(stru.nonNull(null, "456"), "456");
    expect(stru.nonNull(null), "");
  });

  test('nonEmpty', () {
    expect(stru.nonEmpty("456", null), '456');
    expect(stru.nonEmpty("", null), isNull);
    expect(stru.nonEmpty(null, "456"), "456");
    expect(stru.nonEmpty(""), isNull);
    expect(stru.nonEmpty(null), isNull);
    expect(stru.nonEmpty("123"), "123");
  });
}
