import '../../console/impl.dart';
import '../../terminal/terminal_lib_auto.dart';

void main() {
  final termlib = auto_sneath_terminal();
  print(
    'Per TermLib, this console window has ${termlib.get_window_width()} cols and ${termlib.get_window_height()} rows.',
  );
  final console = SneathConsoleImpl(
    terminal: auto_sneath_terminal(),
  );
  print(
    'Per dart_console, this console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.',
  );
}
