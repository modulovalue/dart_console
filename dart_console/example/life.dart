import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dart_console3/ansi_writer/ansi_writer.dart';
import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

void main(
  final List<String> arguments,
) {
  try {
    console.set_raw_mode(false);
    console.hide_cursor();
    Timer.periodic(
      const Duration(milliseconds: 200),
      (final t) {
        draw();
        update();
        // TODO: need async input
        // input();
        if (done) {
          quit();
        }
      },
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (exception) {
    crash(exception.toString());
    rethrow;
  }
}

final SneathConsoleImpl console = SneathConsoleImpl(
  terminal: auto_sneath_terminal(),
);

final Random random = Random();

final int rows = console.dimensions.height;

final int cols = console.dimensions.width;

final int size = rows * cols;

final List<bool> temp = List<bool>.filled(
  size,
  false,
  growable: false,
);

final List<bool> data = List<bool>.generate(
  size,
  (final i) => random.nextBool(),
  growable: false,
);
final StringBuffer buffer = StringBuffer();

bool done = false;

final List<List<int>> neighbors = [
  [-1, -1],
  [0, -1],
  [1, -1],
  [-1, 0],
  [1, 0],
  [-1, 1],
  [0, 1],
  [1, 1],
];

void draw() {
  console.set_background_color(
    const DarkAnsiBackgroundColorAdapter(NamedAnsiColorBlackImpl()),
  );
  console.set_foreground_color(
    const DarkAnsiForegroundColorAdapter(NamedAnsiColorBlueImpl()),
  );
  console.clear_screen();
  buffer.clear();
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      final index = row * rows + col;
      buffer.write(() {
        if (data[index]) {
          return '#';
        } else {
          return ' ';
        }
      }());
    }
    buffer.write(console.new_line);
  }
  console.write(buffer.toString());
}

int numLiveNeighbors(
  final int row,
  final int col,
) {
  int sum = 0;
  for (int i = 0; i < 8; i++) {
    final x = col + neighbors[i][0];
    if (x < 0 || x >= cols) {
      continue;
    }
    final y = row + neighbors[i][1];
    if (y < 0 || y >= rows) {
      continue;
    }
    sum += () {
      if (data[y * rows + x]) {
        return 1;
      } else {
        return 0;
      }
    }();
  }
  return sum;
}

/*
 * 1. Any live cell with fewer than two live neighbors dies, as if caused
 *    by underpopulation.
 * 2. Any live cell with two or three live neighbors lives on to the next
 *    generation.
 * 3. Any live cell with more than three live neighbors dies, as if by
 *    overpopulation.
 * 4. Any dead cell with exactly three live neighbors becomes a live cell, as
 *    if by reproduction.
 */
void update() {
  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      final n = numLiveNeighbors(row, col);
      final index = row * rows + col;
      final v = data[index];
      temp[index] = (v == true && (n == 2 || n == 3)) || (v == false && n == 3);
    }
  }
  data.setAll(0, temp);
}

void input() {
  final key = console.read_key();
  if (key is KeyControl) {
    if (key.control_char == ControlCharacters.escape) {
      done = true;
    }
  }
}

void resetConsole() {
  console.clear_screen();
  console.reset_cursor_position();
  console.reset_color_attributes();
  console.set_raw_mode(false);
}

void crash(
  final String message,
) {
  resetConsole();
  console.write(message);
  exit(1);
}

void quit() {
  resetConsole();
  exit(0);
}
