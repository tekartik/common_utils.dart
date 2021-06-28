import 'package:tekartik_common_utils/future_utils.dart';
import 'package:test/test.dart';

void main() {
  group('future', () {
    test('unawait', () async {
      // ! no warning !
      Future.value(null).unawait();
    });
  });
}
