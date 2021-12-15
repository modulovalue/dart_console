import 'dart:io';

import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

// Diagnostic test for tracking down differences in raw key input from different
// platforms.
void main() {
  console.writeLine('Purely for testing purposes.');
  console.writeLine();
  console.writeLine('This method echos what stdin reads. Useful for testing unusual terminals.');
  console.writeLine("Press 'q' to return to the command prompt.");
  console.rawMode = true;
  for (;;) {
    var codeUnit = 0;
    while (codeUnit <= 0) {
      codeUnit = stdin.readByteSync();
    }
    if (codeUnit < 0x20 || codeUnit == 0x7F) {
      print('${codeUnit.toRadixString(16)}\r');
    } else {
      print('${codeUnit.toRadixString(16)} (${String.fromCharCode(codeUnit)})\r');
    }
    if (String.fromCharCode(codeUnit) == 'q') {
      console.rawMode = false;
      exit(0);
    }
  }
}

final console = SneathConsoleImpl(autoSneathTerminal());
