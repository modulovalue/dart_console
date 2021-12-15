import 'dart:io';

import 'generic_unix.dart';
import 'macos_unix.dart';
import 'terminal_lib.dart';

SneathTerminalUnixImpl autoUnixTerminalLib() {
  // This assumes that all other platforms that dart
  // can run on are unix based and have the libs needed by
  // the unix implementation, which is not always true.
  if (Platform.isMacOS) {
    return macosTerminal();
  } else {
    return unixSneathTerminal();
  }
}
