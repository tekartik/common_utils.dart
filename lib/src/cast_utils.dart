/// Future compat to always return nullable.
T? castAsNullable<T extends Object?>(T? value) => value;

/// Safe cast
T? castAsOrNull<T extends Object?>(Object? object) =>
    object is T ? object : null;

/// Helper extension.
extension TekartikObjectAsOrNullExtension on Object {
  /// Safe cast
  T? asOrNull<T>() => castAsOrNull(this);
}
