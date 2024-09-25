library;

//import 'package:unittest/vm_config.dart';
import 'package:logging/logging.dart' as log;
import 'package:tekartik_common_utils/log_utils.dart';
import 'package:test/test.dart';

void main() => defineTests();

void defineTests() {
  //useVMConfiguration();

  group('log', () {
    test('parse level', () {
      expect(parseLogLevel('info'), equals(log.Level.INFO));
      expect(parseLogLevel('fine'), equals(log.Level.FINE));
      expect(parseLogLevel('dummy'), equals(log.Level.OFF));
    });

    test('format timestamp', () {
      expect(formatTimestampMs(null), equals('(null)'));
      expect(formatTimestampMs(1), equals('00.001'));
      expect(formatTimestampMs(100), equals('00.100'));
      expect(formatTimestampMs(1234), equals('01.234'));
      expect(formatTimestampMs(12345), equals('12.345'));
      expect(formatTimestampMs(123456), equals('23.456'));
      expect(formatTimestampMs(1.6), equals('00.002'));
      expect(formatTimestampMs(999.9), equals('01.000'));
      expect(formatTimestampMs(123456.4), equals('23.456'));
    });

    test('format percent', () {
      expect(format0To1AsPercent(null), equals('(nul)'));
      expect(format0To1AsPercent(0), equals('00.00'));
      expect(format0To1AsPercent(0.00001), equals('00.00'));
      expect(format0To1AsPercent(0.00005), equals('00.01'));
      expect(format0To1AsPercent(0.0001), equals('00.01'));
      expect(format0To1AsPercent(0.00099), equals('00.10'));
      expect(format0To1AsPercent(0.001), equals('00.10'));
      expect(format0To1AsPercent(0.01), equals('01.00'));
      expect(format0To1AsPercent(0.1), equals('10.00'));
      expect(format0To1AsPercent(0.99), equals('99.00'));
      expect(format0To1AsPercent(0.9999), equals('99.99'));
      expect(format0To1AsPercent(0.99999), equals('100.0'));
    });
  });
}
