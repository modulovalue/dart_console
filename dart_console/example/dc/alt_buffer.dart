import 'package:dart_console/dc/base.dart';

final console = DCConsole(DCStdioConsoleAdapter());

// Switches between normal and alternative screen buffer.
void main() {
  console.altBuffer();
}
