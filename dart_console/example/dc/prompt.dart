import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/prompt.dart';

// Shows input fields for regular and secret text entry.
Future<void> main() async {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final username = await read_input(
    console,
    'Username: ',
  );
  final password = await read_input(
    console,
    'Password: ',
    secret: true,
  );
  print('$username -> $password');
}
