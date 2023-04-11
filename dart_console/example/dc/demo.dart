import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';

// Shows basic console formatting options.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  print('Progress Bar');
  final bar = DCProgressBar(
    console: console,
    complete: 5,
  );
  bar.update(3);
}
