import 'dart:async';
import 'package:func/func.dart';
import 'list_utils.dart';

// create a future delayed for [ms] milliseconds
Future sleep([int ms = 0]) {
  return new Future.delayed(new Duration(milliseconds: ms));
}

Future<List<T>> waitAll<T>(List<Func0<Future<T>>> computations) async {
  if (isEmpty(computations)) {
    return null;
  }
  List<Future> futures = new List.generate(
      computations.length, (int index) => computations[index]());
  return Future.wait(futures);
}
