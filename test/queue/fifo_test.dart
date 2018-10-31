import 'package:tekartik_common_utils/queue/fifo.dart';
import 'package:test/test.dart';

void main() {
  test('fifo', () {
    var fifo = Fifo<bool>();
    expect(fifo, isEmpty);
    expect(fifo.pop(), isNull);
    fifo.push(true);
    expect(fifo, isNotEmpty);
    expect(fifo.pop(), true);
    expect(fifo, isEmpty);
    expect(fifo.pop(), isNull);

    fifo.push(true);
    fifo.push(false);
    expect(fifo.pop(), true);
    expect(fifo.pop(), false);
    expect(fifo.pop(), isNull);
  });
}
