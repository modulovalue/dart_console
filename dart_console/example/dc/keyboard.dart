import 'package:dart_console3/keyboard/keyboard.dart';

// Traps up and down arrow and echos to console.
void main() {
  final keyboard = make_stdin_terminal_keyboard();
  keyboard.bind_key('up').listen(
    (final _) {
      print('Up.');
    },
  );
  keyboard.bind_key('down').listen(
    (final _) {
      print('Down.');
    },
  );
}
