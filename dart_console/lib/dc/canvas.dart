import 'base.dart';

abstract class DCCanvas {
  int get width;

  int get height;

  void setPixel(
    final int x,
    final int y,
    final DCPixelSpec spec,
  );
}

class DCConsoleCanvas extends DCCanvas {
  @override
  int get width => console.columns;

  @override
  int get height => console.rows;

  late List<List<DCPixelSpec>> pixels;

  final DCConsole console;

  DCConsoleCanvas(
    final this.console, {
    final DCPixelSpec defaultSpec = DCPixelSpec.EMPTY,
  }) {
    pixels = List.generate(
      width,
      (final i) => List.filled(height, defaultSpec),
    );
  }

  @override
  void setPixel(
    final int x,
    final int y,
    final DCPixelSpec spec,
  ) {
    pixels[x][y] = spec;
  }

  void flush() {
    console.moveCursor(
      column: 0,
      row: 0,
    );
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = pixels[x][y];
        console.rawConsole.write('\x1b[48;5;${pixel.color}m ');
        console.moveCursor(column: x, row: y);
      }
    }
  }
}

class DCPixelSpec {
  static const DCPixelSpec EMPTY = DCPixelSpec(0);

  final int color;

  const DCPixelSpec(
    final this.color,
  );
}
