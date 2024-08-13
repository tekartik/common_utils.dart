import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:web/web.dart';

void main() {
  document.body!.append(HTMLPreElement.pre()..text = jsonPretty(debugEnvMap)!);
}
