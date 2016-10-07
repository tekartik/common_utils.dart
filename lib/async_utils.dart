import 'dart:async';

// create a future delayed for [ms] milliseconds
Future sleep(int ms) {
  return new Future.delayed(new Duration(milliseconds: ms));
}

Future waitAll(List<Future> futures) {
  return Future.wait(futures);
}
