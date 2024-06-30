import 'dart:io';

import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

void main() {
  console.write_line('This sample demonstrates keyboard input. Press any key including control keys');
  console.write_line('such as arrow keys, page up/down, home, end etc. to see it echoed to the');
  console.write_line('screen. Press Ctrl+Q to end the sample.');
  Key key = console.read_key();
  for (;;) {
    key.match(
      printable: print,
      control: (final key) {
        if (key.control_char == ControlCharacters.ctrlQ) {
          console.clear_screen();
          console.reset_cursor_position();
          console.set_raw_mode(false);
          exit(0);
        } else {
          print(key);
        }
      },
    );
    key = console.read_key();
  }
}

final SneathConsoleImpl console = SneathConsoleImpl(
  terminal: auto_sneath_terminal(),
);
