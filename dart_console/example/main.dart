import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

void main() {
  final console = SneathConsoleImpl(
    terminal: autoSneathTerminal(),
  );
  console.setBackgroundColor(
    const DarkAnsiBackgroundColorAdapter(
      NamedAnsiColorBlueImpl(),
    ),
  );
  console.setForegroundColor(
    const DarkAnsiForegroundColorAdapter(
      NamedAnsiColorWhiteImpl(),
    ),
  );
  console.writeLine(
    'Simple Demo',
    ConsoleTextAlignments.center,
  );
  console.resetColorAttributes();
  console.writeLine();
  console.writeLine(
    'This console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
  );
  console.writeLine();
  console.writeLine(
    'This text is left aligned.',
    ConsoleTextAlignments.left,
  );
  console.writeLine(
    'This text is center aligned.',
    ConsoleTextAlignments.center,
  );
  console.writeLine(
    'This text is right aligned.',
    ConsoleTextAlignments.right,
  );
  for (final color in const [
    DarkAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorRedImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorGreenImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorBlueImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorMagentaImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorCyanImpl()),
    DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorRedImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorGreenImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorBlueImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorMagentaImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorCyanImpl()),
    BrightAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()),
  ]) {
    console.setForegroundColor(color);
    console.writeLine(color.name);
  }
  console.resetColorAttributes();
}
