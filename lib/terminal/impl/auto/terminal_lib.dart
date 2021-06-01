import 'dart:io';

import '../../interface/terminal_lib.dart';
import '../unix/terminal_lib.dart';
import '../win/terminal_lib.dart';

SneathTerminalLib autoDetectSneathTerminalLib() {
  if (Platform.isWindows) {
    return SneathTerminalLibWindowsImpl();
  } else {
    // This assumes that all other platforms that dart
    // can run on are unix based and have the libs needed by
    // the unix implementation, which is not always true.
    return SneathTerminalLibUnixImpl();
  }
}
