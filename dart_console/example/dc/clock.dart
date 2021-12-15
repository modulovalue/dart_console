import 'dart:async';
import 'dart:math' as math;

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/drawing_canvas.dart';
import 'package:dart_console/util/bresenham.dart';

// Example of using DrawingCanvas to display a clock.
void main() {
  Timer.periodic(
    const Duration(milliseconds: 1000 ~/ 24),
    (final t) => draw(),
  );
}

final DrawingCanvasImpl canvas = DrawingCanvasImpl(160, 160);

final DCConsole console = DCConsole(DCStdioConsoleAdapter());

void draw() {
  canvas.clear();
  final time = DateTime.now();
  bresenham(
    80,
    80,
    sin(time.hour / 24, 30),
    160 - cos(time.hour / 24, 30),
    canvas.set,
  );
  bresenham(
    80,
    80,
    sin(time.minute / 60, 50),
    160 - cos(time.minute / 60, 50),
    canvas.set,
  );
  bresenham(
    80,
    80,
    sin(time.second / 60 + (time.millisecondsSinceEpoch % 1000 / 60000), 75),
    160 - cos(time.second / 60 + (time.millisecondsSinceEpoch % 1000) / 60000, 75),
    canvas.set,
  );
  console.rawConsole.write(
    canvas.frame(),
  );
}

num sin(
  final num i,
  final num l,
) =>
    (math.sin(i * 2 * math.pi) * l + 80).floor();

num cos(
  final num i,
  final num l,
) =>
    (math.cos(i * 2 * math.pi) * l + 80).floor();
