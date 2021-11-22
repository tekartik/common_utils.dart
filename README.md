# common_utils.dart

Dart common utilities with no io or browser code for shared tekartik projects


## Usage

In your `pubspec.yaml`:

```yaml
dependencies:
  tekartik_common_utils:
    git:
      url: https://github.com/tekartik/common_utils.dart
      ref: dart2_3
    version: '>=0.11.1'
```

## Documentation

* [Pedantic](https://github.com/tekartik/common_utils.dart/blob/master/doc/pedantic.md)

```yaml
# tekartik recommended lints (extension over google lints and pedantic)
include: package:tekartik_common_utils/lints/recommended.yaml
```
## Testing

Test on all platforms

    pub run test -p vm,chrome,node