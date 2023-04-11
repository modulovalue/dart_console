import 'package:dart_console/ansi_writer/ansi_writer.dart';
import 'package:dart_console/console/impl.dart';
import 'package:dart_console/console/interface.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

void main() {
  final console = SneathConsoleImpl(
    terminal: auto_sneath_terminal(),
  );
  console.set_background_color(
    const DarkAnsiBackgroundColorAdapter(
      NamedAnsiColorBlueImpl(),
    ),
  );
  console.set_foreground_color(
    const DarkAnsiForegroundColorAdapter(
      NamedAnsiColorWhiteImpl(),
    ),
  );
  console.write_line(
    'Simple Demo',
    ConsoleTextAlignments.center,
  );
  console.reset_color_attributes();
  console.write_line();
  console.write_line(
    'This console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
  );
  console.write_line();
  console.write_line(
    'This text is left aligned.',
    ConsoleTextAlignments.left,
  );
  console.write_line(
    'This text is center aligned.',
    ConsoleTextAlignments.center,
  );
  console.write_line(
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
    console.set_foreground_color(color);
    console.write_line(color.name);
  }
  console.reset_color_attributes();
}
