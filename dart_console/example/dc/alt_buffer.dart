import 'package:dart_console/dc/base.dart';

// Switches between normal and alternative screen buffer.
void main() {
  console.altBuffer();
}

final console = DCConsole(DCStdioConsoleAdapter());
