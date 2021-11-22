import 'package:dev_test/test.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/ini_file_utils.dart';

void main() {
  group('iniFile', () {
    test('parseIniLines', () async {
      var lines = LineSplitter.split('''
avd.ini.encoding=UTF-8
path=/home/alex/.android/avd/Nexus_7_API_22.avd
path.rel=avd/Nexus_7_API_22.avd
target=android-22
''');
      expect(parseIniLines(lines), {
        'avd.ini.encoding': 'UTF-8',
        'path': '/home/alex/.android/avd/Nexus_7_API_22.avd',
        'path.rel': 'avd/Nexus_7_API_22.avd',
        'target': 'android-22'
      });
    });
  });
}
