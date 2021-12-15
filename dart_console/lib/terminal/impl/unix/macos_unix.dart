import 'dart:ffi';

import 'terminal_lib.dart';

SneathTerminalUnixImpl macosTerminal() => makeSneathTerminalUnix(
      DynamicLibrary.open('/usr/lib/libSystem.dylib'),
      0x40087468,
    );
