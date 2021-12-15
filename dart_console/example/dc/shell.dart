import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/prompt.dart';

//  A simple REPL that echoes input text back to the console.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final shell = DCShellPrompt(console);
  shell.loop().listen(
    (final line) {
      if (['stop', 'quit', 'exit'].contains(line.toLowerCase().trim())) {
        shell.stop();
        return;
      }
      print(line);
    },
  );
}
