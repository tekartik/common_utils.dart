import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/src/tags_impl.dart'
    show TagsConditionSingle, TagsConditionMulti, TagsConditionSealed;
import 'package:tekartik_common_utils/tags.dart';
import 'package:test/test.dart' hide Tags;

Tags _t(String? text) => Tags.fromText(text);

TagsCondition _c(String expression) => TagsCondition(expression);

Future<void> main() async {
  group('tags', () {
    test('tags', () {
      expect(_t(null).toText(), '');
      expect(_t(null).toTextOrNull(), isNull);
      expect(_t(null).toList(), <String>[]);
      expect(_t(null).toListOrNull(), isNull);
      expect(_t('test').toText(), 'test');
      expect(_t(' test ').toText(), 'test');
      var tags = _t('test1, test2');
      expect(tags.toText(), 'test1,test2');
      expect(tags.toTextOrNull(), 'test1,test2');
      expect(tags.toList(), ['test1', 'test2']);
      expect(tags.toListOrNull(), ['test1', 'test2']);
      expect(Tags.fromList(null).toText(), '');
      expect(Tags.fromList(['test1']).toText(), 'test1');
      expect(Tags.fromList(['test1', 'test2']).toText(), 'test1,test2');
    });
    test('has/add/remove', () {
      var tags = Tags();
      expect(tags.has('test1'), isFalse);
      expect(tags.add('test1'), isTrue);
      expect(tags.has('test1'), isTrue);
      expect(tags.add('test1'), isFalse);
      expect(tags.has('test1'), isTrue);
      expect(tags.remove('test1'), isTrue);
      expect(tags.has('test1'), isFalse);
      expect(tags.remove('test1'), isFalse);
      expect(tags.has('test1'), isFalse);

      expect(tags.add('test1'), isTrue);
      expect(tags.add('test2'), isTrue);
      expect(tags.has('test1'), isTrue);
      expect(tags.has('test2'), isTrue);
      expect(tags.toList(), ['test1', 'test2']);
      expect(tags.add('test1'), isFalse);
      expect(tags.add('test2'), isFalse);
    });
    test('sort', () {
      expect(_t('test2, test1').toText(), 'test2,test1');
      expect((_t('test2, test1')..sort()).toText(), 'test1,test2');
    });
    test('condition none', () {
      expect(_c('').toText(), '');
      expect(_c('  ').toText(), '');
      expect(_c('').check(_t('any')), isTrue);
    });
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
    test('complex', () {
      var condition = _c(
        '(test1 || (test2 && test3) ||  (test4 && test5 && test6)) && (test7 || (test8 && test9))',
      );
      expect(condition.check(_t('test1, test7')), isTrue);
      expect(condition.check(_t('test1, test5')), isFalse);
      expect(condition.check(_t('test1, test6')), isFalse);
      expect(condition.check(_t('test5, test6')), isFalse);
      expect(condition.check(_t('test2, test3, test5, test7')), isTrue);
      expect(condition.check(_t('test4, test5, test6, test8, test9')), isTrue);
      expect(condition.check(_t('test4, test5, test6, test8')), isFalse);
      expect(condition.check(_t('test5, test6, test8, test9')), isFalse);
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
      expect(_c('(test1)'), isA<TagsConditionSealed>());
      expect(_c('!(test1)'), isA<TagsConditionSingle>());

      expect(_c('test1 || test2'), isA<TagsConditionMulti>());
      expect(_c('test1 && test2'), isA<TagsConditionMulti>());
      expect(_c('(test1 && test2)'), isA<TagsConditionSealed>());
      expect(_c('!(test1 && test2)'), isA<TagsConditionSingle>());

      expect(_c('(  test1)').toText(), 'test1');
      expect(_c('!(  test1)').toText(), '!test1');
      expect(
        _c('!(  test1  &&  test2  && test3)  || test4 ').toText(),
        '!((test1 && test2 && test3) || test4)',
      );

      /// precedence
      expect(() => _c('test1 && test2 || test3'), throwsArgumentError);
      expect(() => _c('test1 || test2 && test3'), throwsArgumentError);

      void roundTrip(String expression) {
        expect(_c(expression).toText(), expression);
      }

      for (var expression in [
        'test1',
        '!test1',
        'test1 || test2',
        'test1 && test2',
        'test1 && test2 && test3',
        'test1 || test2 || test3',
        'test1 && (test2 || test3)',
        '(test2 || test3) && test1',
        'test1 || (test2 && test3)',
        '(test2 && test3) || test1',
        '(test1 || test2 || test3) && test4 && (test5 || test6 || test7)',
        '(test1 && test2 && test3) || test4 || (test5 && test6 && test7)',
      ]) {
        roundTrip(expression);
      }
    });

    test(
      'quick',
      () {
        var tags = _t('test1, test2');
        var condition = _c('test1 || (test2 && test3)');
        // ignore: avoid_print
        print(tags);
        // ignore: avoid_print
        print(condition);
        // ignore: avoid_print
        print(condition.check(tags));
      },
      skip: //
          true,
      //        devWarning(false)
    );
  });
}
