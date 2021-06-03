import 'package:dart_console/ansi/impl/color.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/text_alignment.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

void main() {
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  console.setBackgroundColor(NamedAnsiColors.blue);
  console.setForegroundColor(NamedAnsiColors.white);
  console.writeLine('Simple Demo', ConsoleTextAlignments.center);
  console.resetColorAttributes();
  console.writeLine();
  console.writeLine('This console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.');
  console.writeLine();
  console.writeLine('This text is left aligned.', ConsoleTextAlignments.left);
  console.writeLine('This text is center aligned.', ConsoleTextAlignments.center);
  console.writeLine('This text is right aligned.', ConsoleTextAlignments.right);
  for (final color in NamedAnsiColors.all) {
    console.setForegroundColor(color);
    console.writeLine(color.name);
  }
  console.resetColorAttributes();
}
