import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/text_alignment.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

void main() {
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  console.clearScreen();
  console.resetCursorPosition();
  console.writeLine(
    'Console size is ${console.windowWidth} cols and ${console.windowHeight} rows.',
    ConsoleTextAlignments.center,
  );
  console.writeLine();
}
