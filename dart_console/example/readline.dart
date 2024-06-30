import 'dart:io';

import 'package:dart_console3/ansi_writer/ansi_writer.dart';
import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

// Inspired by
// http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#writing-a-command-line
// as a test of the Console class capabilities
//
// Demonstrates a simple command-line interface that does not require line
// editing services from the shell.
void main() {
  final console = SneathConsoleImpl(
    terminal: auto_sneath_terminal(),
  );
  const prompt = '>>> ';
  console.write('The ');
  console.set_foreground_color(const BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()));
  console.write('Console.readLine()');
  console.reset_color_attributes();
  console.write_line(' method provides a basic readline implementation.');
  console.write('Unlike the built-in ');
  console.set_foreground_color(const BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()));
  console.write('stdin.readLineSync()');
  console.reset_color_attributes();
  console.write_line(' method, you can use arrow keys as well as home/end.');
  console.write_line();
  console.write_line('As a demo, this command-line reader "shouts" all text back in upper case.');
  console.write_line('Enter a blank line or press Ctrl+C to exit.');
  for (;;) {
    console.write(prompt);
    final response = console.read_line(cancel_on_break: true);
    if (response == null || response.isEmpty) {
      exit(0);
    } else {
      console.write_line('YOU SAID: ${response.toUpperCase()}');
      console.write_line();
    }
  }
}
