import 'package:cv/cv.dart';

export 'package:cv/cv.dart';
export 'package:cv/src/model.dart' show ModelListBase, ModelBase;

extension ModelCompatExt on Model {
  ModelEntry? getModelEntry(String key) => getMapEntry(key);
}
