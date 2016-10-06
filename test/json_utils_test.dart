import 'package:test/test.dart';
import 'package:tekartik_common_utils/json_utils.dart';

void main() => defineTests();

void defineTests() {
  test('parseJsonObject', () {
    expect(parseJsonObject(null), equals(null));
    expect(parseJsonObject("456"), equals(null));
    Map obj = {"key": "value"};
    expect(parseJsonObject('{"key":"value"}'), equals(obj));
    obj = {
      "key": ["value"]
    };
    expect(parseJsonObject('{"key":["value"]}'), equals(obj));
    expect(parseJsonObject('[{"key":"value"}]'), equals(null));
    expect(parseJsonObject('[{"key":"value"}]', {}), equals({}));
  });

  test('parseJsonList', () {
    expect(parseJsonList(null), equals(null));
    expect(parseJsonList("456"), equals(null));
    List list = [
      {"key": "value"}
    ];
    expect(parseJsonList('[{"key":"value"}]'), equals(list));
    expect(parseJsonList('{"key":"value"}'), isNull);
    expect(parseJsonList('{"key":"value"}', []), equals([]));
  });
}
