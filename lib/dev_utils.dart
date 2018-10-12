/// Development helpers to generate warning in code
library tekartik_dev_utils;

void _devPrint(Object object) {
  if (_devPrintEnabled) {
    print(object);
  }
}

bool _devPrintEnabled = true;

@deprecated
set devPrintEnabled(bool enabled) => _devPrintEnabled = enabled;

@deprecated
void devPrint(Object object) {
  if (_devPrintEnabled) {
    print(object);
  }
}

@deprecated
int devWarning;

_devError([Object object = null]) {
  // one day remove the print however sometimes the error thrown is hidden
  try {
    throw UnsupportedError("$object");
  } catch (e, st) {
    if (_devPrintEnabled) {
      print("# ERROR $object");
      print(st);
    }
    throw e;
  }
}

@deprecated
devError([Object object = null]) => _devError(object);

// exported for testing
void debugDevPrint(Object object) => _devPrint(object);
void debugDevError(Object object) => _devError(object);
set debugDevPrintEnabled(bool enabled) => _devPrintEnabled = enabled;

// Simple class to add a debug flag
// off by default
// turning it on raises a warning so that you don't checkin code like that
class DevFlag {
  final String explanation;
  DevFlag([this.explanation]);
  bool get on => _on ?? false;
  bool _on;

  @deprecated
  set on(bool on) {
    _on = on;
    if (_devPrintEnabled) {
      print('Turning $this');
    }
  }

  @override
  toString() => "DevFlag($explanation) ${on ? "on" : "off"}";
}
