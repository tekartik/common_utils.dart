import 'package:tekartik_common_utils/duration_utils.dart';
import 'package:test/test.dart';

void main() {
  test('duration', () {
    expect(0.seconds, Duration.zero);
    expect(1.seconds.inMilliseconds, 1000);
    expect(1.5.seconds.inMilliseconds, 1500);
    expect(1.weeks, 1.days * 7);
    expect(1.days, 1.hours * 24);
    expect(1.hours, 1.minutes * 60);
    expect(1.minutes, 1.seconds * 60);
    expect(1.seconds, 1.milliseconds * 1000);
    expect(1.milliseconds, 1.microseconds * 1000);
  });
}
