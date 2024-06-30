import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_console3/dc/drawing_canvas.dart';
import 'package:vector_math/vector_math.dart';

/// Draws a 3D cube with DrawingCanvas.
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
  final cube = quads.map(
    (final quad) {
      return quad
          .map(
            (final v) => Vector3.array(
              points[v],
            ),
          )
          .toList();
    },
  ).toList();
  final projection = makePerspectiveMatrix(pi / 3.0, 1.0, 1.0, 50.0);
  final canvas = DrawingCanvasImpl(
    height: 160,
    width: 160,
  );
  Timer.periodic(
    const Duration(
      milliseconds: 1000 ~/ 24,
    ),
    (final _) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final model_view = makeViewMatrix(
        Vector3(0.0, 0.1, 4.0),
        Vector3(0.0, 0.0, 0.0),
        Vector3(0.0, 1.0, 0.0),
      );
      model_view.rotateY(pi * 2 * now / 10000);
      model_view.rotateZ(pi * 2 * now / 11000);
      model_view.rotateX(pi * 2 * now / 9000);
      model_view.scale(Vector3(sin(now / 1000 * pi) / 2 + 1, 1.0, 1.0));
      canvas.clear();
      final transformed = cube.map(
        (final quad) {
          return quad.map(
            (final v) {
              Matrix4 m;
              Vector3 out = Vector3.zero();
              m = projection * model_view as Matrix4;
              out = m.transform3(v);
              return {
                'x': (out[0] * 40 + 80).floor(),
                'y': (out[1] * 40 + 80).floor(),
              };
            },
          );
        },
      );
      transformed.forEach((final quadIterable) {
        int i = 0;
        final quad = quadIterable.toList();
        quad.forEach((final v) {
          final n = quad[((() {
                    if (i.isNegative) {
                      return i.abs();
                    } else {
                      return -i;
                    }
                  }()) +
                  1) %
              4];
          canvas.line(
            x0: v['x']!,
            y0: v['y']!,
            x1: n['x']!,
            y1: n['y']!,
          );
          i++;
        });
      });
      stdout.write(canvas.frame());
    },
  );
}
