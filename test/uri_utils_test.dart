import 'package:tekartik_common_utils/uri_utils.dart';
import 'package:test/test.dart';

void main() {
  group('uri_utils', () {
    test('locationSearchGetArguments', () {
      var uri = Uri.parse('http://localhost:8080?test=1');
      expect(locationSearchGetArguments(uri.query), {'test': '1'});
      expect(locationSearchGetArguments(null), isEmpty);
    });
    test('locationSearchGetArguments', () {
      var uri = Uri.parse('http://localhost:8080/path?test=1#fragment');
      expect(
        uri.removeParametersAndFragment().toString(),
        'http://localhost:8080/path',
      );
    });
  });
}
