import 'dart:html';

import 'package:tekartik_common_utils/env_utils.dart';

void main() {
  querySelector('body')
      .append(HeadingElement.h1()..text = isRelease ? 'RELEASE' : 'DEBUG');
}
