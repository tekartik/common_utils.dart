import 'package:tekartik_common_utils/src/tags_impl.dart'
    show TagsConditionSingle, TagsConditionMulti;
import 'package:tekartik_common_utils/tags.dart';
import 'package:test/test.dart' hide Tags;

Tags _t(String text) => Tags.fromText(text);
TagsCondition _c(String expression) => TagsCondition(expression);

Future<void> main() async {
  group('tags', () {
    test('simple', () {
      var tags = _t('test');
      expect(_c('test').check(tags), isTrue);
      expect(_c('test1').check(tags), isFalse);
    });
    test('and', () {
      var tags = _t('test1,test2');
      expect(_c('test1 && test2').check(tags), isTrue);
      expect(_c('test1 && test3').check(tags), isFalse);
      expect(_c('test2 && test3').check(tags), isFalse);
    });
    test('or', () {
      var tags = _t('test1,test2');
      expect(_c('test1 || test2').check(tags), isTrue);
      expect(_c('test1 || test3').check(tags), isTrue);
      expect(_c('test2 || test3').check(tags), isTrue);
      expect(_c('test3 || test4').check(tags), isFalse);
    });
    test('parenthesis', () {
      var tags = _t('test1');
      expect(_c('test3 || (test1 || test2)').check(tags), isTrue);
      expect(_c('test3 || (test1 && test2)').check(tags), isFalse);
      tags = _t('test1, test2');
      expect(_c('test3 || (test1 || test2)').check(tags), isTrue);
      expect(_c('test1 && (test2 || test3)').check(tags), isTrue);
    });
    test('conditions', () {
      expect(_c('test1'), isA<TagsConditionSingle>());
      expect(_c('!test1'), isA<TagsConditionSingle>());
      expect(_c('(test1)'), isA<TagsConditionSingle>());
      expect(_c('!(test1)'), isA<TagsConditionSingle>());

      expect(_c('test1 || test2'), isA<TagsConditionMulti>());
      expect(_c('test1 && test2'), isA<TagsConditionMulti>());
      expect(_c('(test1 && test2)'), isA<TagsConditionMulti>());
      expect(_c('!(test1 && test2)'), isA<TagsConditionSingle>());

      void roundTrip(String expression) {
        expect(_c(expression).toText(), expression);
      }

      for (var expression in [
        'test1',
        '!test1',
        'test1 || test2',
        'test1 && test2',
        'test1 && (test2 || test3)',
        '(test2 || test3) && test1',
      ]) {
        roundTrip(expression);
      }
    });

    test('quick', () {
      var tags = _t('test1, test2');
      var condition = _c('test1 && (test2 || test3)');
      // ignore: avoid_print
      print(tags);
      // ignore: avoid_print
      print(condition);
      // ignore: avoid_print
      print(condition.check(tags));
    }, skip: true);
  });
}
