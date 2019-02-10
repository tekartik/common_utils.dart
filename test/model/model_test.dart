import 'package:tekartik_common_utils/model/model.dart';
import 'package:tekartik_common_utils/model/src/model.dart';
import 'package:tekartik_common_utils/model/src/model_entry.dart';
import 'package:tekartik_common_utils/model/src/model_list.dart';
import 'package:test/test.dart';

void main() => defineTests();

class BaseModel
    with
// to comment/uncomment for progressing implementation
//      MapMixin<String, dynamic>,
// up to here
        ModelMixin {}

class BaseModelEntry with ModelEntryMixin {}

class BaseModelList
    with
// to comment/uncomment for progressing implementation
//      ListMixin<dynamic>,
// up to here
        ModelListMixin {}

void defineTests() {
  group('model', () {
    test('entry', () {
      expect(ModelEntry('test', null), ModelEntry('test', null));
      expect(ModelEntry('test', null), isNot(ModelEntry.nullEntry('test')));
      expect(ModelEntry('test', null), isNot(ModelEntry('other_test', null)));
      expect(ModelEntry('test', null),
          isNot(ModelEntry('test', null, presentIfNull: true)));
      expect(ModelEntry.nullEntry('test'),
          ModelEntry('test', null, presentIfNull: true));
      expect(ModelEntry('test', null), isNot(ModelEntry('test', 'a')));
    });

    test('value', () {
      var model = Model();
      model.setValue('test', 'text');
      expect(model.getValue<String>('test'), 'text');
      model.setValue('test', null);
      expect(model.getValue<String>('test'), isNull);
      expect(model.containsKey('test'), isFalse);
      model.setValue('test', null, presentIfNull: true);
      expect(model.getValue<String>('test'), isNull);
      expect(model.containsKey('test'), isTrue);
    });

    test('model', () {
      var model = Model();
      expect(model.getModelEntry('test'), ModelEntry('test', null));
      model['test'] = null;
      expect(model.getModelEntry('test').value, isNull);
      model['test'] = 'a';
      expect(model.getModelEntry('test').value, 'a');
      model['test'] = null;
      expect(model.getModelEntry('test'),
          ModelEntry('test', null, presentIfNull: true));
      model.remove('test');
      expect(model.getModelEntry('test'), ModelEntry('test', null));

      model = Model({'test': 'a'});
      expect(model.getModelEntry('test').value, 'a');
      model = Model({'test': null});
      expect(model.getModelEntry('test').value, null);
    });

    test('model_list', () {
      var list = ModelList();
      var modelList1 = ModelList();
      var modelList2 = ModelList([]);
      var baseModelList = BaseModelList();

      var lists = <List>[list, modelList1, modelList2, baseModelList];
      // expect(model.getEntry('test'), ModelEntry('test', null));
      void _test(dynamic value) {
        for (var list in lists) {
          list.add(value);
          expect(list.last, value);
        }
      }

      _test(null);
      _test('a');
    });

    test('mixin', () {
      var map = {};
      var model1 = Model();
      var baseModel = BaseModel();
      var model2 = Model({});

      var maps = [map, model1, baseModel, model2];

      void _test(dynamic value) {
        for (var map in maps) {
          map['test'] = value;
          expect(map['test'], value);
          if (map is Model) {
            expect(map.getModelEntry('test'),
                ModelEntry('test', value, presentIfNull: true));
          }
        }
      }

      _test(null);
      _test('a');
      for (var map in maps) {
        map.remove('test');
        expect(map['test'], isNull);
        if (map is Model) {
          expect(map.getModelEntry('test'), ModelEntry('test', null));
        }
      }
    });
  });
}
