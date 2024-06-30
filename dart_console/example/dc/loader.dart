import 'dart:async';

import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/progress.dart';

// Demonstrates an indeterminate progress bar.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final loader = DCWideLoadingBar(
    console: console,
  );
  final timer = loader.loop();
  Future<dynamic>.delayed(
    const Duration(
      seconds: 5,
    ),
  ).then(
    (final dynamic _) {
      timer.cancel();
    },
  );
}
