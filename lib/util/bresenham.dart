/// https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
void bresenham(
  num x0,
  num y0,
  num x1,
  num y1,
  void Function(int, int) passPoint,
) {
  final dx = x1 - x0;
  final dy = y1 - y0;
  final adx = dx.abs();
  final ady = dy.abs();
  var eps = 0;
  final sx = dx > 0 ? 1 : -1;
  final sy = dy > 0 ? 1 : -1;
  if (adx > ady) {
    for (var x = x0, y = y0; sx < 0 ? x >= x1 : x <= x1; x += sx) {
      passPoint(x.round(), y.round());
      eps += ady.toInt();
      if ((eps << 1) >= adx) {
        y += sy;
        eps -= adx.toInt();
      }
    }
  } else {
    for (var x = x0, y = y0; sy < 0 ? y >= y1 : y <= y1; y += sy) {
      passPoint(x.round(), y.round());
      eps += adx.toInt();
      if ((eps << 1) >= ady) {
        x += sx;
        eps -= ady.toInt();
      }
    }
  }
}
