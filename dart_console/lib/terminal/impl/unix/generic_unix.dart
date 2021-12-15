import 'dart:ffi';

import 'terminal_lib.dart';

SneathTerminalUnixImpl unixSneathTerminal() => makeSneathTerminalUnix(
      DynamicLibrary.open('libc.so.6'),
      0x5413,
    );
