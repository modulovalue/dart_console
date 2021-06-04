import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/keyboard.dart';

// Traps up and down arrow and echos to console.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final keyboard = DCKeyboard(console);
  keyboard.init();
  keyboard.bindKey('up').listen((_) {
    print('Up.');
  });
  keyboard.bindKey('down').listen((_) {
    print('Down.');
  });
}
