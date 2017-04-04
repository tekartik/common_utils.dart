import 'package:test/test.dart';
import 'package:tekartik_common_utils/date_time_utils.dart';

void main() {
  group('date_time_utils', () {
    test('formatYYYYdashMMdashDD', () {
      expect(formatYYYYdashMMdashDD(new DateTime(2017)), "2017-01-01");
      expect(formatYYYYdashMMdashDD(new DateTime(1972, 4, 12)), "1972-04-12");
      expect(formatYYYYdashMMdashDD(new DateTime(972, 4, 12, 15, 4)),
          "0972-04-12");
    });
  });
}
