import 'dart:ffi';

import 'terminal_lib_unix_impl.dart';

SneathTerminalUnixImpl autoUnixGenericSneathTerminal() => makeSneathTerminalUnix(
      stdlib: DynamicLibrary.open('libc.so.6'),
      IOCTL_TIOCGWINSZ: 0x5413,
    );
