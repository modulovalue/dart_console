import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/canvas.dart';

// Shows use of ConsoleCanvas for character-based positioning.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final canvas = DCConsoleCanvas(console, defaultSpec: const DCPixelSpec(0));
  for (var i = 0; i < 15; i++) {
    canvas.setPixel(i, i, const DCPixelSpec(170));
  } for (var i = 0; i < 40; i++) {
    canvas.setPixel(i, 7, const DCPixelSpec(1));
  }
  canvas.flush();
}
