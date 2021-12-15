import 'dart:async';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/timer.dart';

// Example of a timer.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final timer = DCTimeDisplay(console);
  console.rawConsole.write('Waiting 10 Seconds ');
  timer.start();
  Future<dynamic>.delayed(const Duration(seconds: 10)).then(
    (final dynamic _) {
      timer.stop();
      print('');
    },
  );
}
