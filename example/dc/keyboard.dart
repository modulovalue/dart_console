// import 'dart:convert';
// import 'dart:io';

import 'package:dart_console/keyboard/impl/keyboard.dart';

// Traps up and down arrow and echos to console.
void main() {
  final keyboard = TerminalKeyboardImpl.stdin();
  keyboard.bindKey('up').listen((_) {
    print('Up.');
  });
  keyboard.bindKey('down').listen((_) {
    print('Down.');
  });
}
