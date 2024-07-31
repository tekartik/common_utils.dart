library tekartik_string_enum;

/// Base class for string enum
abstract class StringEnum {
  /// The value
  final String name;

  /// Constructor
  const StringEnum(this.name);

  @override
  String toString() => name;

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(var other) {
    if (other is StringEnum) {
      return name == other.name;
    }
    return super == (other);
  }

  /// The value
  String get value => name;
}
