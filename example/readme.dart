import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/interface/text_alignments.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

int main() {
  final console = SneathConsoleImpl(autoDetectSneathTerminalLib());
  console.clearScreen();
  console.resetCursorPosition();
  console.writeLine(
    'Console size is ${console.windowWidth} cols and ${console.windowHeight} rows.',
    TextAlignment.center,
  );
  console.writeLine();
  return 0;
}
