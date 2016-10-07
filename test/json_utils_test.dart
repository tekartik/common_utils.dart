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
    expect(parseJsonObject('{key:"value"}'), isNull);
    expect(parseJsonObject('{1:"value"}'), isNull);
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

  test('jsonPretty', () {
    expect(jsonPretty(null), isNull);
    expect(jsonPretty(null, "nope"), "nope");
    expect(jsonPretty("hi"), '"hi"');
    expect(jsonPretty(1), '1');
    expect(jsonPretty({}), "{}");
    expect(jsonPretty([]), "[]");
    Map obj = {
      "key": ["value"]
    };
    expect(
        jsonPretty(obj),
        """
{
  "key": [
    "value"
  ]
}""");
  });
}
