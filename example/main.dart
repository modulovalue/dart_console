import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/interface/text_alignments.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

void main() {
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  console.setBackgroundColor(NamedAnsiColor.blue);
  console.setForegroundColor(NamedAnsiColor.white);
  console.writeLine('Simple Demo', TextAlignment.center);
  console.resetColorAttributes();
  console.writeLine();
  console.writeLine('This console window has ${console.windowWidth} cols and ${console.windowHeight} rows.');
  console.writeLine();
  console.writeLine('This text is left aligned.', TextAlignment.left);
  console.writeLine('This text is center aligned.', TextAlignment.center);
  console.writeLine('This text is right aligned.', TextAlignment.right);
  for (final color in NamedAnsiColor.values) {
    console.setForegroundColor(color);
    console.writeLine(color.toString().split('.').last);
  }
  console.resetColorAttributes();
}
