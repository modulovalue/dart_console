import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/prompt.dart';

// Shows input fields for regular and secret text entry.
Future<void> main() async {
  final console = DCConsole(DCStdioConsoleAdapter());
  final username = await readInput(console, 'Username: ');
  final password = await readInput(console, 'Password: ', secret: true);
  print('$username -> $password');
}
