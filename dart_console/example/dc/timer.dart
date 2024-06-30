import 'dart:async';

import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/timer.dart';

// Example of a timer.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final timer = DCTimeDisplay(
    console: console,
  );
  console.raw_console.write('Waiting 10 Seconds ');
  timer.start();
  Future<dynamic>.delayed(
    const Duration(
      seconds: 10,
    ),
  ).then(
    (final dynamic _) {
      timer.stop();
      print('');
    },
  );
}
