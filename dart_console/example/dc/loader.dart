import 'dart:async';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';

// Demonstrates an indeterminate progress bar.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final loader = DCWideLoadingBar(console);
  final timer = loader.loop();
  Future<dynamic>.delayed(const Duration(seconds: 5)).then(
    (final dynamic _) {
      timer.cancel();
    },
  );
}
