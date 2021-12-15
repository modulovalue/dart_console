/// https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
void bresenham(
  final num x0,
  final num y0,
  final num x1,
  final num y1,
  final void Function(int, int) passPoint,
) {
  final dx = x1 - x0;
  final dy = y1 - y0;
  final adx = dx.abs();
  final ady = dy.abs();
  var eps = 0;
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
    for (var x = x0, y = y0;
        () {
      if (sx < 0) {
        return x >= x1;
      } else {
        return x <= x1;
      }
    }();
        x += sx) {
      passPoint(x.round(), y.round());
      eps += ady.toInt();
      if ((eps << 1) >= adx) {
        y += sy;
        eps -= adx.toInt();
      }
    }
  } else {
    for (var x = x0, y = y0;
        () {
      if (sy < 0) {
        return y >= y1;
      } else {
        return y <= y1;
      }
    }();
        y += sy) {
      passPoint(x.round(), y.round());
      eps += adx.toInt();
      if ((eps << 1) >= ady) {
        x += sx;
        eps -= ady.toInt();
      }
    }
  }
}
