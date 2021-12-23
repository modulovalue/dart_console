import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

void main() {
  final termlib = autoSneathTerminal();
  print(
    'Per TermLib, this console window has ${termlib.getWindowWidth()} cols and ${termlib.getWindowHeight()} rows.',
  );
  final console = SneathConsoleImpl(
    terminal: autoSneathTerminal(),
  );
  print(
    'Per dart_console, this console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
  );
}
