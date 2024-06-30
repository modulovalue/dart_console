import 'dart:async';
import 'dart:math' as math;

import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/drawing_canvas.dart';

// Example of using DrawingCanvas to display a clock.
void main() {
  final canvas = DrawingCanvasImpl(
    width: 180,
    height: 80,
  );
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  Timer.periodic(
    const Duration(
      milliseconds: 1000 ~/ 24,
    ),
    (final t) => _draw(
      canvas: canvas,
      console: console,
    ),
  );
}

void _draw({
  required final DrawingCanvasImpl canvas,
  required final DCConsole console,
}) {
  num _sin({
    required final num i,
    required final num l,
  }) {
    return (math.sin(i * 2 * math.pi) * l + 80).floor();
  }

  num _cos({
    required final num i,
    required final num l,
  }) {
    return (math.cos(i * 2 * math.pi) * l + 80).floor();
  }

  canvas.clear();
  // bresenham(
  //   x0: 0,
  //   y0: 0,
  //   x1: canvas.width,
  //   y1: canvas.height,
  //   pass_point: canvas.set,
  // );
  final time = DateTime.now();
  const center_x = 40;
  const center_y = 40;
  const y = 160;
  final hour = time.hour / 24;
  final min = time.minute / 60;
  final sec = time.second / 60;
  final sec_increment = time.millisecondsSinceEpoch % 1000 / 60000;
  final change = sec + sec_increment;
  canvas.line(
    x0: center_x,
    y0: center_y,
    x1: _sin(i: hour, l: 30),
    y1: y - _cos(i: hour, l: 30),
  );
  canvas.line(
    x0: center_x,
    y0: center_y,
    x1: _sin(i: min, l: 50),
    y1: y - _cos(i: min, l: 50),
  );
  canvas.line(
    x0: center_x,
    y0: center_y,
    x1: _sin(i: change, l: 75),
    y1: y - _cos(i: change, l: 75),
  );
  console.raw_console.write(
    canvas.frame(),
  );
}
