import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

void main() {
  final console = SneathConsoleImpl(
    terminal: auto_sneath_terminal(),
  );
  console.clear_screen();
  console.reset_cursor_position();
  console.write_line(
    'Console size is ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
    ConsoleTextAlignments.center,
  );
  console.write_line();
}
