import 'base.dart';

abstract class DCCanvas {
  int get width;

  int get height;

  void set_pixel(
    final int x,
    final int y,
    final DCPixelSpec spec,
  );
}

class DCConsoleCanvas extends DCCanvas {
  @override
  int get width {
    return console.columns;
  }

  @override
  int get height {
    return console.rows;
  }

  late List<List<DCPixelSpec>> pixels;

  final DCConsole console;

  DCConsoleCanvas(
    this.console, {
    final DCPixelSpec defaultSpec = DCPixelSpec.EMPTY,
  }) {
    pixels = List.generate(
      width,
      (final i) => List.filled(height, defaultSpec),
    );
  }

  @override
  void set_pixel(
    final int x,
    final int y,
    final DCPixelSpec spec,
  ) {
    pixels[x][y] = spec;
  }

  void flush() {
    console.move_cursor(
      column: 0,
      row: 0,
    );
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = pixels[x][y];
        console.raw_console.write('\x1b[48;5;${pixel.color}m ');
        console.move_cursor(column: x, row: y);
      }
    }
  }
}

class DCPixelSpec {
  static const DCPixelSpec EMPTY = DCPixelSpec(0);

  final int color;

  const DCPixelSpec(
    this.color,
  );
}
