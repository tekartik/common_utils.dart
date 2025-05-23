import 'package:tekartik_common_utils/lazy_list.dart';
import 'package:tekartik_common_utils/src/lazy_list.dart' show LazyListPrvExt;
import 'package:test/test.dart';

void main() {
  group('lazy_list', () {
    test('lazy model list', () {
      var list = LazyList<int, String>(
        srcList: <int>[1],
        converter: (item) => item.toString(),
      );
      list.add('2');
      expect(list.lazyList, [null, '2']);
      expect(list, ['1', '2']);
      expect(list.lazyList, ['1', '2']);
    });
  });
}
