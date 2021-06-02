import 'dart:io';

import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/interface/control_character.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

final console = SneathConsoleImpl(autodetectSneathTerminal());

void main() {
  console.writeLine('This sample demonstrates keyboard input. Press any key including control keys');
  console.writeLine('such as arrow keys, page up/down, home, end etc. to see it echoed to the');
  console.writeLine('screen. Press Ctrl+Q to end the sample.');
  var key = console.readKey();
  for (;;) {
    key.match(
      printable: print,
      control: (key) {
        if (key.controlChar == ControlCharacter.ctrlQ) {
          console.clearScreen();
          console.resetCursorPosition();
          console.rawMode = false;
          exit(0);
        } else {
          print(key);
        }
      },
    );
    key = console.readKey();
  }
}
