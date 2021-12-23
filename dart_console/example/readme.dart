import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

void main() {
  final console = SneathConsoleImpl(
    terminal: autoSneathTerminal(),
  );
  console.clearScreen();
  console.resetCursorPosition();
  console.writeLine(
    'Console size is ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
    ConsoleTextAlignments.center,
  );
  console.writeLine();
}
