import 'package:test/test.dart';

abstract class TestInteface {
  bool test();
}

mixin True implements TestInteface {
  @override
  bool test() {
    return true;
  }
}

mixin False implements TestInteface {
  @override
  bool test() {
    return false;
  }
}

class A with True, False {}

class B with False, True {}

void main() {
  test('mixin order', () {
    var a = A();
    var b = B();
    expect(a.test(), isFalse);
    expect(b.test(), isTrue);
  });
}
