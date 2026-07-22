library;

/// Base class for custom string-backed enum implementations.
abstract class StringEnum {
  /// The string identifier or value of this enum constant.
  final String name;

  /// Creates a [StringEnum] with the given string [name].
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

  /// The string value of this enum constant, identical to [name].
  String get value => name;
}
