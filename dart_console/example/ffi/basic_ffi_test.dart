import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';
import 'package:dart_console/terminal/impl/unix/terminal_lib.dart';

void main() {
  final termlib = SneathTerminalUnixImpl();
  print('Per TermLib, this console window has ${termlib.getWindowWidth()} cols and '
      '${termlib.getWindowHeight()} rows.');
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  print('Per dart_console, this console window has ${console.dimensions.width} cols and '
      '${console.dimensions.height} rows.');
}
