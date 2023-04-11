abstract class DrawingCanvas {
  int get width;

  int get height;

  void clear();

  void set(
    final int x,
    final int y,
  );

  void unset(
    final int x,
    final int y,
  );

  void toggle(
    final int x,
    final int y,
  );

  String frame();
}

class DrawingCanvasImpl implements DrawingCanvas {
  static final List<List<int>> _map = [
    [0x1, 0x8],
    [0x2, 0x10],
    [0x4, 0x20],
    [0x40, 0x80],
  ];
  @override
  final int width;
  @override
  final int height;
  late List<int> content;

  DrawingCanvasImpl({
    required final this.width,
    required final this.height,
  }) {
    if (width % 2 != 0) {
      throw Exception('Width must be a multiple of 2!');
    } else if (height % 4 != 0) {
      throw Exception('Height must be a multiple of 4!');
    } else {
      content = List<int>.filled(
        width * height ~/ 8,
        0,
      );
    }
  }

  void _do_it(
    final int x,
    final int y,
    final void Function(int coord, int mask) func,
  ) {
    if (x >= 0 && x < width && y >= 0 && y < height) {
      // ignore: parameter_assignments
      final _x = x;
      // ignore: parameter_assignments
      final _y = y;
      final nx = (_x / 2).floor();
      final ny = (_y / 4).floor();
      final coord = (nx + width / 2 * ny).toInt();
      final mask = _map[_y % 4][_x % 2];
      func(coord, mask);
    }
  }

  void _clear_content() {
    for (int i = 0; i < content.length; i++) {
      content[i] = 0;
    }
  }

  @override
  void clear() {
    _clear_content();
  }

  @override
  void set(
    final int x,
    final int y,
  ) {
    _do_it(
      x,
      y,
      (final coord, final mask) => content[coord] |= mask,
    );
  }

  @override
  void unset(
    final int x,
    final int y,
  ) {
    _do_it(
      x,
      y,
      (final coord, final mask) => content[coord] &= mask,
    );
  }

  @override
  void toggle(final int x, final int y) {
    _do_it(
      x,
      y,
      (final coord, final mask) => content[coord] ^= mask,
    );
  }

  @override
  String frame() {
    const delimiter = '\n';
    final result = <String>[];
    for (int i = 0, j = 0; i < content.length; i++, j++) {
      if (j == width / 2) {
        result.add(delimiter);
        j = 0;
      }
      if (content[i] == 0) {
        result.add(' ');
      } else {
        result.add(String.fromCharCode(0x2800 + content[i]));
      }
    }
    result.add(delimiter);
    return result.join();
  }

  void line({
    required final num x0,
    required final num y0,
    required final num x1,
    required final num y1,
  }) {
    _bresenham(
      x0: x0,
      y0: y0,
      x1: x1,
      y1: y1,
      pass_point: set,
    );
  }
}

/// https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
void _bresenham({
  required final num x0,
  required final num y0,
  required final num x1,
  required final num y1,
  required final void Function(int, int) pass_point,
}) {
  final dx = x1 - x0;
  final dy = y1 - y0;
  final adx = dx.abs();
  final ady = dy.abs();
  int eps = 0;
  final sx = () {
    if (dx > 0) {
      return 1;
    } else {
      return -1;
    }
  }();
  final sy = () {
    if (dy > 0) {
      return 1;
    } else {
      return -1;
    }
  }();
  if (adx > ady) {
    for (num x = x0, y = y0;
        () {
      if (sx < 0) {
        return x >= x1;
      } else {
        return x <= x1;
      }
    }();
        x += sx) {
      pass_point(x.round(), y.round());
      eps += ady.toInt();
      if ((eps << 1) >= adx) {
        y += sy;
        eps -= adx.toInt();
      }
    }
  } else {
    for (num x = x0, y = y0;
        () {
      if (sy < 0) {
        return y >= y1;
      } else {
        return y <= y1;
      }
    }();
        y += sy) {
      pass_point(x.round(), y.round());
      eps += adx.toInt();
      if ((eps << 1) >= ady) {
        x += sx;
        eps -= ady.toInt();
      }
    }
  }
}
