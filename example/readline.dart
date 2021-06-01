import 'dart:io';

import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

// Inspired by
// http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// as a test of the Console class capabilities
//
// Demonstrates a simple command-line interface that does not require line
// editing services from the shell.
void main() {
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  const prompt = '>>> ';
  console.write('The ');
  console.setForegroundColor(NamedAnsiColor.brightYellow);
  console.write('Console.readLine()');
  console.resetColorAttributes();
  console.writeLine(' method provides a basic readline implementation.');
  console.write('Unlike the built-in ');
  console.setForegroundColor(NamedAnsiColor.brightYellow);
  console.write('stdin.readLineSync()');
  console.resetColorAttributes();
  console.writeLine(' method, you can use arrow keys as well as home/end.');
  console.writeLine();
  console.writeLine('As a demo, this command-line reader "shouts" all text '
      'back in upper case.');
  console.writeLine('Enter a blank line or press Ctrl+C to exit.');
  for (;;) {
    console.write(prompt);
    final response = console.readLine(cancelOnBreak: true);
    if (response == null || response.isEmpty) {
      exit(0);
    } else {
      console.writeLine('YOU SAID: ${response.toUpperCase()}');
      console.writeLine();
    }
  }
}
