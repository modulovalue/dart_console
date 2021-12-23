import 'dart:ffi';

import 'terminal_lib_unix_impl.dart';

SneathTerminalUnixImpl autoUnixMacosSneathTerminal() => makeSneathTerminalUnix(
      stdlib: DynamicLibrary.open('/usr/lib/libSystem.dylib'),
      IOCTL_TIOCGWINSZ: 0x40087468,
    );
