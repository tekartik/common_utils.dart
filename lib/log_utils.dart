/// Compat
library;

export 'package:logging/logging.dart';

export 'src/log_utils.dart'
    show
        parseLogLevel,
        logLevels,
        compatLogger,
        // ignore: deprecated_member_use_from_same_package
        debugQuickLogging,
        setupQuickLogging,
        formatTimestampMs,
        format0To1AsPercent;
