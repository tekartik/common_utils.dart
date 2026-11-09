## Lints

`pedantic` is gone; the tekartik lints are in
[tekartik_lints](https://github.com/tekartik/common.dart/tree/main/packages/lints). This package keeps an alias:

```yaml
# analysis_options.yaml
include: package:tekartik_common_utils/lints/recommended.yaml
```

`package:tekartik_common_utils/pedantic/analysis_options.yaml` and
`pedantic/analysis_options.strong_mode.yaml` are deprecated aliases of the same file.
