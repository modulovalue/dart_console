import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';

// Shows basic console formatting options.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  print('Progress Bar');
  final bar = DCProgressBar(console, complete: 5);
  bar.update(3);
}
