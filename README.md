# common_utils.dart

Dart common utilities with no io or browser code for shared tekartik projects

## Usage

In your `pubspec.yaml`:

```yaml
dependencies:
  tekartik_common_utils:
    git:
      url: https://github.com/tekartik/common_utils.dart
      ref: dart3a
    version: '>=0.15.2'
```

Versioning follows [dart project versioning](https://github.com/tekartik/common.dart/blob/main/doc/tekartik_versioning.md) conventions.

## Documentation

* [Pedantic](https://github.com/tekartik/common_utils.dart/blob/master/doc/pedantic.md)

```yaml
# tekartik recommended lints (extension over google lints and pedantic)
include: package:tekartik_common_utils/lints/recommended.yaml
```
## Testing

Test on all platforms

    pub run test -p vm,chrome,node