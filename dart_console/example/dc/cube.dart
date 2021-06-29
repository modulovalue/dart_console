import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/drawing_canvas.dart';
import 'package:dart_console/util/bresenham.dart';
import 'package:vector_math/vector_math.dart';

final console = DCConsole(DCStdioConsoleAdapter());

// Draws a 3D cube with DrawingCanvas. |
void main() {
  const points = [
    [-1.0, -1.0, -1.0],
    [-1.0, -1.0, 1.0],
    [1.0, -1.0, 1.0],
    [1.0, -1.0, -1.0],
    [-1.0, 1.0, -1.0],
    [-1.0, 1.0, 1.0],
    [1.0, 1.0, 1.0],
    [1.0, 1.0, -1.0],
  ];
  const quads = [
    [0, 1, 2, 3],
    [0, 4, 5, 1],
    [1, 5, 6, 2],
    [2, 6, 7, 3],
    [3, 7, 4, 0],
    [4, 7, 6, 5],
  ];
  final cube = quads
      .map(
        (quad) => quad
            .map(
              (v) => Vector3.array(
                points[v],
              ),
            )
            .toList(),
      )
      .toList();
  final projection = makePerspectiveMatrix(pi / 3.0, 1.0, 1.0, 50.0);
  final canvas = DrawingCanvasImpl(160, 160);
  void draw() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final modelView = makeViewMatrix(
      Vector3(0.0, 0.1, 4.0),
      Vector3(0.0, 0.0, 0.0),
      Vector3(0.0, 1.0, 0.0),
    );
    modelView.rotateY(pi * 2 * now / 10000);
    modelView.rotateZ(pi * 2 * now / 11000);
    modelView.rotateX(pi * 2 * now / 9000);
    modelView.scale(Vector3(sin(now / 1000 * pi) / 2 + 1, 1.0, 1.0));
    canvas.clear();
    final transformed = cube.map((quad) {
      return quad.map((v) {
        Matrix4 m;
        var out = Vector3.zero();
        m = projection * modelView as Matrix4;
        out = m.transform3(v);
        return {
          'x': (out[0] * 40 + 80).floor(),
          'y': (out[1] * 40 + 80).floor(),
        };
      });
    });
    transformed.forEach((quadIterable) {
      var i = 0;
      final quad = quadIterable.toList();
      quad.forEach((v) {
        final n = quad[((i.isNegative ? i.abs() : -i) + 1) % 4];
        bresenham(v['x']!, v['y']!, n['x']!, n['y']!, canvas.set);
        i++;
      });
    });
    stdout.write(canvas.frame());
  }

  Timer.periodic(
    const Duration(milliseconds: 1000 ~/ 24),
    (_) => draw(),
  );
}
