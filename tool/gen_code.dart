import 'dart:io';

import 'package:dev_build/shell.dart';
import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  /*
  /// Common stream join items extension
extension StreamJoinItemList3Ext<T1 extends Object?, T2 extends Object?> on (
  StreamJoinItem<T1>,
  StreamJoinItem<T2>
) {
  /// item1
  StreamJoinItem<T1> get item1 => $1;

  /// item2
  StreamJoinItem<T2> get item2 => $2;

  /// grouped values
  (T1?, T2?) get values {
    return (item1.value, item2.value);
  }
}
   */
  var sb = StringBuffer();
  void add(String line) {
    sb.writeln(line);
  }

  add("import 'dart:async';");
  add("import 'package:tekartik_common_utils/stream/stream_join.dart';");

  String itemId(int index) => '${index + 1}';
  for (var i = 2; i <= 4; i++) {
    Iterable<String> forEach(String Function(int index) f) {
      return List.generate(i, (index) => f(index));
    }

    var classId = '$i';
    var typeDef = forEach(
      (index) => 'T${itemId(index)} extends Object?',
    ).join(', ');

    /// Stream<T1> stream1, Stream<T2> stream2, Stream<T3> stream3
    var streamArgs = forEach((index) {
      var id = itemId(index);
      return 'Stream<T$id> stream$id';
    }).join(',');

    /// stream1, stream2, stream3
    var streamParams = forEach((index) {
      var id = itemId(index);
      return 'stream$id';
    }).join(', ');
    //print(typeDef);

    add('/// Common stream join items extension');
    add('extension StreamJoinItemList${classId}Ext<$typeDef> on (');
    add(forEach((index) => 'StreamJoinItem<T${itemId(index)}>').join(', '));
    add(') {');
    //  /// item1
    //  StreamJoinItem<T1> get item1 => $1;
    add(
      forEach((index) {
        var id = itemId(index);
        return '''
      /// item$id
      StreamJoinItem<T$id> get item$id => \$$id;
      ''';
      }).join('\n'),
    );

    // /// grouped values
    // (T1?, T2?) get values {
    //   return (item1.value, item2.value);
    // }
    add('''
    /// Grouped values
    (${forEach((index) => 'T${itemId(index)}?').join(', ')}) get values {
      return (${forEach((index) => 'item${itemId(index)}.value').join(', ')});
    }
    ''');

    add('}');

    // /// Join 3 streams
    // Stream<(StreamJoinItem<T1>, StreamJoinItem<T2>, StreamJoinItem<T3>)>
    //     streamJoin3OrError<T1 extends Object?, T2 extends Object?,
    //             T3 extends Object?>(
    //         Stream<T1> stream1, Stream<T2> stream2, Stream<T3> stream3) {
    //   return streamJoinAllOrError<Object?>([stream1, stream2, stream3]).map(
    //       (event) =>
    //           (event[0].cast<T1>(), event[1].cast<T2>(), event[2].cast<T3>()));
    // }
    add('/// Join $classId streams or error');
    add('''
    Stream<(${forEach((index) => 'StreamJoinItem<T${itemId(index)}>').join(', ')})>
        streamJoin${classId}OrError<$typeDef>(
          $streamArgs) {
          return streamJoinAllOrError<Object?>([$streamParams])
              .map((event) => (${forEach((index) => 'event[$index].cast<T${itemId(index)}>()').join(', ')}));
              }
        ''');
  }

  try {
    var genContent = sb.toString();
    var genFile = join('lib', 'stream', 'stream_join_gen.dart');
    await File(genFile).writeAsString(genContent);
    await run('dart format ${shellArgument(genFile)}');
    stdout.writeln(File(genFile).readAsStringSync());
  } catch (e) {
    stdout.writeln(sb.toString());
  }
}
