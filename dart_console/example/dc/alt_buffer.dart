import 'package:dart_console/dc/base.dart';

// Switches between normal and alternative screen buffer.
void main() {
  console.alt_buffer();
}

final console = DCConsole(
  raw_console: DCStdioConsoleAdapter(),
);
