import 'dart:io';

import '../../interface/terminal_lib.dart';
import '../unix/auto_unix.dart';
import '../win/terminal_lib.dart';

SneathTerminal autoSneathTerminal() {
  if (Platform.isWindows) {
    return SneathTerminalWindowsImpl();
  } else {
    return autoUnixTerminalLib();
  }
}
