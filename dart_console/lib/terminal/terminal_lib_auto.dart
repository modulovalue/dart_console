import 'dart:io';

import 'terminal_lib.dart';
import 'terminal_lib_unix.dart';
import 'terminal_lib_windows.dart';

SneathTerminal auto_sneath_terminal() {
  if (Platform.isWindows) {
    return auto_windows_sneath_terminal();
  } else {
    return auto_unix_sneath_terminal();
  }
}
