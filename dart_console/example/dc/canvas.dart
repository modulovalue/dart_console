import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/canvas.dart';

// Shows use of ConsoleCanvas for character-based positioning.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final canvas = DCConsoleCanvas(
    console,
    defaultSpec: const DCPixelSpec(0),
  );
  for (int i = 0; i < 15; i++) {
    canvas.set_pixel(i, i, const DCPixelSpec(170));
  } for (int i = 0; i < 40; i++) {
    canvas.set_pixel(i, 7, const DCPixelSpec(1));
  }
  canvas.flush();
}
