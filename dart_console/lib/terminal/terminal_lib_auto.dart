import 'dart:io';

import 'terminal_lib.dart';
import 'terminal_lib_auto_unix.dart';
import 'terminal_lib_auto_windows.dart';

SneathTerminal autoSneathTerminal() {
  if (Platform.isWindows) {
    return autoWindowsSneathTerminal();
  } else {
    return autoUnixSneathTerminal();
  }
}
