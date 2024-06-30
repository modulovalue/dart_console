import 'dart:async';

import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/drawing_canvas.dart';

// Simple demonstration of DrawingCanvas for drawing a vertical bar.
void main() {
  final canvas = DrawingCanvasImpl(
    width: 100,
    height: 100,
  );
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  console.erase_display(1);
  int l = 1;
  Timer.periodic(
    const Duration(
      seconds: 2,
    ),
    (final _) {
      l += 2;
      for (int i = 0; i < l; i++) {
        canvas.set(1, i + 1);
      }
      console.move_cursor(
        row: 1,
        column: 1,
      );
      print(
        canvas.frame(),
      );
    },
  );
}
