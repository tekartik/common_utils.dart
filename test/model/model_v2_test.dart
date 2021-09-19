import 'package:tekartik_common_utils/model/model_v2.dart';
import 'package:test/test.dart';

void main() => defineTests();

class MyModel extends ModelBase {
  MyModel([Map? map]) : super(map);
}

class MyModelList extends ModelListBase {
  MyModelList([Iterable? list]) : super(list);
}

void defineTests() {
  group('model', () {
    test('entry', () {
      //expect(ModelEntry('test', null), ModelEntry('test', null));
      //expect(ModelEntry('test', null), isNot(ModelEntry('other_test', null)));
      //expect(ModelEntry('test', null), isNot(ModelEntry('test', 'a')));
    });

    test('value', () {
      var model = NewModel();
      model.setValue('test', 'text');
      expect(model.getValue<String>('test'), 'text');
      expect(model.getModelEntry('test')!.value, 'text');
      model.setValue('test', null);
      expect(model.getValue<String>('test'), isNull);
      expect(model.containsKey('test'), isFalse);
      model.setValue('test', null, presentIfNull: true);
      expect(model.getValue<String>('test'), isNull);
      expect(model.containsKey('test'), isTrue);
    });

    test('model', () {
      var model = <K, V>{};
      expect(model.getModelEntry('test'), isNull);
      model['test'] = null;
      expect(model.getModelEntry('test')!.value, isNull);
      model['test'] = 'a';
      expect(model.getModelEntry('test')!.value, 'a');
      model['test'] = null;
      expect(model.getModelEntry('test')!.value, isNull);
      model.remove('test');
      expect(model.getModelEntry('test'), isNull);

      model = asModel({'test': 'a'});
      expect(model.getModelEntry('test')!.value, 'a');
      model = asModel({'test': null});
      expect(model.getModelEntry('test')!.value, null);
    });

    group('model_list', () {
      test('simple', () {
        var list = <Model>[];
        var modelList1 = <Model>[];
        var modelList2 = asModelList([]);
        var baseModelList = MyModelList();

        var lists = <List>[list, modelList1, modelList2, baseModelList];
        // expect(model.getEntry('test'), ModelEntry('test', null));
        void _test(Map value) {
          for (var list in lists) {
            list.add(asModel(value));
            expect(list.last, value);
          }
        }

        //_test(null);
        _test({});

        list = <Model>[];
        list.add(asModel({'a': 1}));
      });

      test('cast', () {
        var list = asModelList([<Object?, Object?>{}]);
        expect(list[0], const TypeMatcher<Model>());
      });
    });

    test('model_base', () {
      var map = {};
      var model1 = <K, V>{};
      var baseModel = MyModel();
      var model2 = asModel({});

      var maps = [map, model1, baseModel, model2];

      void _test(dynamic value) {
        for (var map in maps) {
          map['test'] = value;
          expect(map['test'], value);
          if (map is Model) {
            expect(map.getModelEntry('test')!.value, value);
          }
        }
      }

      //_test(null);
      _test('a');
      _test([]);
      _test({});
      for (var map in maps) {
        map.remove('test');
        expect(map['test'], isNull);
        if (map is Model) {
          expect(map.getModelEntry('test'), isNull);
        }
      }
    });

    test('asModel', () {
      //expect(asModel(null), null);
      expect(asModel({}), {});
      expect(asModel({'test': 1}), {'test': 1});
      expect(asModel({}), const TypeMatcher<Model>());
    });
  });
}
