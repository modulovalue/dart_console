abstract class DrawingCanvas {
  int get width;

  int get height;

  void clear();

  void set(int x, int y);

  void unset(int x, int y);

  void toggle(int x, int y);

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

  DrawingCanvasImpl(this.width, this.height) {
    if (width % 2 != 0) {
      throw Exception('Width must be a multiple of 2!');
    } else if (height % 4 != 0) {
      throw Exception('Height must be a multiple of 4!');
    } else {
      content = List<int>.filled(width * height ~/ 8, 0);
    }
  }

  void _doIt(int x, int y, void Function(int coord, int mask) func) {
    if (x >= 0 && x < width && y >= 0 && y < height) {
      // ignore: parameter_assignments
      final _x = x.floor();
      // ignore: parameter_assignments
      final _y = y.floor();
      final nx = (_x / 2).floor();
      final ny = (_y / 4).floor();
      final coord = (nx + width / 2 * ny).toInt();
      final mask = _map[_y % 4][_x % 2];
      func(coord, mask);
    }
  }

  void _clearContent() {
    for (var i = 0; i < content.length; i++) {
      content[i] = 0;
    }
  }

  @override
  void clear() => _clearContent();

  @override
  void set(int x, int y) => _doIt(x, y, (coord, mask) => content[coord] |= mask);

  @override
  void unset(int x, int y) => _doIt(x, y, (coord, mask) => content[coord] &= mask);

  @override
  void toggle(int x, int y) => _doIt(x, y, (coord, mask) => content[coord] ^= mask);

  @override
  String frame() {
    const delimiter = '\n';
    final result = <String>[];
    for (var i = 0, j = 0; i < content.length; i++, j++) {
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
}
