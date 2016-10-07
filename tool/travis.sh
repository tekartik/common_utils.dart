#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/common_utils_import.dart \
  lib/dev_utils.dart \
  lib/hash_code_utils.dart \
  lib/log_utils.dart \
  lib/json_utils.dart \
  lib/version_utils.dart \
  lib/synchronized.dart \
  lib/async_utils.dart \

pub run test -p vm,firefox,chrome