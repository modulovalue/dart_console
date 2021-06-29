import 'dart:async';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';

// Demonstrates a determinate progress bar (e.g. download)
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final progress = DCProgressBar(console);
  var i = 0;
  Timer.periodic(const Duration(milliseconds: 300), (timer) {
    i++;
    progress.update(i);
    if (i == 100) {
      timer.cancel();
    }
  });
}
