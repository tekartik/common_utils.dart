import 'package:tekartik_common_utils/string_utils.dart' as stru;
import 'package:tekartik_common_utils/string_utils.dart';
import 'package:test/test.dart';

void main() {
  test('parseInt', () {
    expect(stru.parseInt('456', 1), equals(456));
    expect(stru.parseInt('sd456', 1), equals(1));
    expect(stru.parseInt('sd456', null), null);
    expect(stru.parseInt('0x10', 1), equals(16));
    expect(stru.parseInt(null, 1), equals(1));
    expect(stru.parseInt('', 1), equals(1));
  });

  test('parseBool', () {
    // up to 2017-08
    // expect(stru.parseBool('456'), false);
    expect(stru.parseBool('456'), isTrue);
    expect(stru.parseBool('true'), true);
    expect(stru.parseBool('1'), true);
    expect(stru.parseBool(null, true), true);
    expect(stru.parseBool(null, false), false);
    // up to 2017-08
    // expect(stru.parseBool(null), false);
    expect(stru.parseBool(null), isNull);
    expect(stru.parseBool('', true), true);
  });

  test('is(Note)Empty', () {
    expect(stringIsEmpty('456'), isFalse);
    expect(stringIsEmpty(null), isTrue);
    expect(stringIsEmpty(''), isTrue);
    expect(stringIsEmpty(' '), isFalse);
    expect(stringIsNotEmpty('456'), isTrue);
    expect(stringIsNotEmpty(null), isFalse);
    expect(stringIsNotEmpty(''), isFalse);
    expect(stringIsNotEmpty(' '), isTrue);
  });

  test('stringTruncate', () {
    expect(stringTruncate(null, 0), isNull);
    expect(stringTruncate(null, 1), isNull);
    expect(stringTruncate('test', 1), 't');
    expect(stringTruncate('test', 5), 'test');
  });

  test('stringSubString', () {
    expect(stringSubString(null, 0), isNull);
    expect(stringSubString(null, 1), isNull);

    expect(stringSubString('', 0), '');
    expect(stringSubString('', -1), '');
    expect(stringSubString('', 1), '');
    expect(stringSubString('1', 1), '');
    expect(stringSubString('1', 2), '');
    expect(stringSubString('1', 0), '1');
    expect(stringSubString('1', -1), '1');
    expect(stringSubString('12', -1), '12');
    expect(stringSubString('12', 0), '12');
    expect(stringSubString('12', 1), '2');
    expect(stringSubString('12', 2), '');
    expect(stringSubString('12', 3), '');
    expect(stringSubString('12', 1, 3), '2');
    expect(stringSubString('12', 1, 2), '2');
    expect(stringSubString('12', 1, 1), '');
    expect(stringSubString('12', 1, -1), '');
  });

  test('prefill', () {
    expect(stru.stringPrefilled('456', 6, ' '), '   456');
    expect(stru.stringPrefilled('456', 5, '000'), '000456');
  });

  test('nonNull', () {
    expect(stringNonNull('456', null), '456');
    expect(stringNonNull(null, null), '');
    expect(stringNonNull(null, '456'), '456');
    expect(stringNonNull(null), '');
  });

  test('nonEmpty', () {
    expect(stringNonEmpty('456', null), '456');
    expect(stringNonEmpty('', null), isNull);
    expect(stringNonEmpty(null, '456'), '456');
    expect(stringNonEmpty(''), isNull);
    expect(stringNonEmpty(null), isNull);
    expect(stringNonEmpty('123'), '123');
  });

  test('extension', () {
    expect(''.nonEmpty(), isNull);
    expect('456'.nonEmpty(), '456');
    expect('123'.truncate(2), '12');
    expect('123'.truncate(4), '123');
  });
  test('stringsCompareWithLastInt', () {
    expect(
        ['d', 'a3', 'a2', 'a3', 'b2', 'b1 ', 'd', 'c']
          ..sort((v1, v2) => stringsCompareWithLastInt(v1, v2)),
        ['a2', 'a3', 'a3', 'b1 ', 'b2', 'c', 'd', 'd']);
  });
  test('getLastInt', () {
    expect(''.getLastInt(), isNull);
    expect('1'.getLastInt(), 1);
    expect('1 '.getLastInt(), 1);
    expect('2 \r'.getLastInt(), 2);
    expect('none\r'.getLastInt(), isNull);
  });

  test('obfuscate', () async {
    expect(''.obfuscate(), '');
    expect('1'.obfuscate(), '*');
    expect('1'.obfuscate(), '*');
    expect('123456789'.obfuscate(), '12*****89');
    expect('1234567890'.obfuscate(), '12******90');
    expect('12345678901'.obfuscate(), '12*******01');
    expect('123456789012'.obfuscate(), '123******012');
    expect('12345678901234567890'.obfuscate(), '1234************7890');
    expect('12345678901234567890'.obfuscate(lastAndFirstKeepCountMax: 5),
        '12345**********67890');
  });
  test('splitFirst', () {
    expect(''.splitFirst(' '), ['']);
    expect('a'.splitFirst(' '), ['a']);
    expect('a b'.splitFirst(' '), ['a', 'b']);
    expect('a b c'.splitFirst(' '), ['a', 'b c']);
  });
}
