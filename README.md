# common_utils.dart

Dart common utilities with no io or browser code for shared tekartik projects


## Usage

In your `pubspec.yaml`:

```yaml
dependencies:
  tekartik_common_utils:
    git:
      url: git://github/tekartik/common_utils.dart
      ref: dart2
    version: '>=0.9.2+1'
```

## Testing

Test on all platforms

    pub run test -p vm,chrome,node