import 'package:tekartik_common_utils/env_utils.dart';
import 'dart:html';

main() {
  querySelector('body')
      .append(new HeadingElement.h1()..text = isRelease ? "RELEASE" : "DEBUG");
}