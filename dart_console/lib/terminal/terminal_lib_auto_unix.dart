import 'dart:io';

import 'terminal_lib_auto_unix_generic.dart';
import 'terminal_lib_auto_unix_macos.dart';
import 'terminal_lib_unix_impl.dart';

SneathTerminalUnixImpl autoUnixSneathTerminal() {
  // This assumes that all other platforms that dart
  // can run on are unix based and have the libs needed
  // by the unix implementation, which may not always
  // be the case.
  if (Platform.isMacOS) {
    return autoUnixMacosSneathTerminal();
  } else {
    return autoUnixGenericSneathTerminal();
  }
}
