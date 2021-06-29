import 'dart:async';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/drawing_canvas.dart';

// Simple demonstration of DrawingCanvas for drawing a vertical bar.
void main() {
  final canvas = DrawingCanvasImpl(100, 100);
  final console = DCConsole(DCStdioConsoleAdapter());
  console.eraseDisplay(1);
  var l = 1;
  Timer.periodic(
    const Duration(seconds: 2),
    (_) {
      l += 2;
      for (var i = 0; i < l; i++) {
        canvas.set(1, i + 1);
      }
      console.moveCursor(row: 1, column: 1);
      print(canvas.frame());
    },
  );
}
