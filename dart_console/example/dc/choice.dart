import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/prompt.dart';

// Select a multiple choice option.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final chooser = DCChooser<String>(
    console,
    ['A', 'B', 'C', 'D'],
    message: 'Select a Letter: ',
  );
  final letter = chooser.chooseSync();
  print('You chose $letter.');
}
