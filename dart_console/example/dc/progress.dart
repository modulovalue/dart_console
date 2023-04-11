import 'dart:async';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';

// Demonstrates a determinate progress bar (e.g. download)
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final progress = DCProgressBar(console: console,);
  int i = 0;
  Timer.periodic(
    const Duration(milliseconds: 300),
    (final timer) {
      i++;
      progress.update(i);
      if (i == 100) {
        timer.cancel();
      }
    },
  );
}
