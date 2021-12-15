import 'package:dart_console/keyboard/keyboard.dart';

// Traps up and down arrow and echos to console.
void main() {
  final keyboard = makeStdinTerminalKeyboard();
  keyboard.bindKey('up').listen(
    (final _) {
      print('Up.');
    },
  );
  keyboard.bindKey('down').listen(
    (final _) {
      print('Down.');
    },
  );
}
