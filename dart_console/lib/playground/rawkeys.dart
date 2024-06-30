import 'dart:io';

import '../console/impl.dart';
import '../terminal/terminal_lib_auto.dart';

// Diagnostic test for tracking down differences in raw key input from different
// platforms.
void main() {
  console.write_line('Purely for testing purposes.');
  console.write_line();
  console.write_line('This method echos what stdin reads. Useful for testing unusual terminals.');
  console.write_line("Press 'q' to return to the command prompt.");
  console.set_raw_mode(true);
  for (;;) {
    int codeUnit = 0;
    while (codeUnit <= 0) {
      codeUnit = stdin.readByteSync();
    }
    if (codeUnit < 0x20 || codeUnit == 0x7F) {
      print('${codeUnit.toRadixString(16)}\r');
    } else {
      print('${codeUnit.toRadixString(16)} (${String.fromCharCode(codeUnit)})\r');
    }
    if (String.fromCharCode(codeUnit) == 'q') {
      console.set_raw_mode(false);
      exit(0);
    }
  }
}

final console = SneathConsoleImpl(
  terminal: auto_sneath_terminal(),
);
