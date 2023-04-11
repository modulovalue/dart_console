import 'dart:io';

import 'package:dart_console/dc/drawing_canvas.dart';

// Simple example of DrawingCanvas for a filled box.
void main() {
  void draw() {
    final canvas = DrawingCanvasImpl(
      width: 120,
      height: 120,
    );
    for (int x = 1; x < canvas.width; x++) {
      for (int y = 1; y < canvas.height; y++) {
        canvas.set(x, y);
      }
    }
    print(canvas.frame());
  }

  for (;;) {
    draw();
    sleep(const Duration(milliseconds: 16));
  }
}
