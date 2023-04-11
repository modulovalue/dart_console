import 'dart:async';

import 'base.dart';

/// A fancy progress bar
class DCProgressBar {
  final int complete;
  final DCConsole console;

  int current = 0;

  /// Creates a Progress Bar.
  ///
  /// [complete] is the number that is considered 100%.
  DCProgressBar({
    required final this.console,
    final this.complete = 100,
  });

  /// Updates the Progress Bar with a progress of [progress].
  void update(
    final int progress,
  ) {
    if (progress != current) {
      current = progress;
      final ratio = progress / complete;
      final percent = (ratio * 100).toInt();
      final digits = percent.toString().length;
      final w = console.columns - digits - 4;
      final count = (ratio * w).toInt();
      final before = '$percent% [';
      const after = ']';
      final out = StringBuffer(before);
      for (int x = 1; x < count; x++) {
        out.write('=');
      }
      out.write('>');
      for (int x = count; x < w; x++) {
        out.write(' ');
      }
      out.write(after);
      if (out.length - 1 == console.columns) {
        final it = out.toString();
        out.clear();
        out.write(it.substring(0, it.length - 2) + ']');
      }
      console.overwrite_line(out.toString());
    }
  }
}

/// A loading bar
class DCLoadingBar {
  Timer? _timer;
  bool started = true;
  String position = '<';
  late String lastPosition;

  final DCConsole console;

  /// Creates a loading bar.
  DCLoadingBar(
    final this.console,
  );

  /// Starts the Loading Bar
  void start() {
    console.hide_cursor();
    _timer = Timer.periodic(
      const Duration(milliseconds: 75),
      (final timer) {
        nextPosition();
        update();
      },
    );
  }

  /// Stops the Loading Bar with the specified (and optional) [message].
  void stop([
    final String? message,
  ]) {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (message != null) {
      position = message;
      update();
    }
    console.show_cursor();
    print('');
  }

  /// Updates the Loading Bar
  void update() {
    if (started) {
      console.raw_console.write(position);
      started = false;
    } else {
      console.move_cursor_back(lastPosition.length);
      console.raw_console.write(position);
    }
  }

  void nextPosition() {
    lastPosition = position;
    switch (position) {
      case '|':
        position = '/';
        break;
      case '/':
        position = '-';
        break;
      case '-':
        position = '\\';
        break;
      case '\\':
        position = '|';
        break;
      default:
        position = '|';
        break;
    }
  }
}

/// A wide loading bar. Kind of like a Progress Bar.
class DCWideLoadingBar {
  int position = 0;

  final DCConsole console;

  /// Creates a wide loading bar.
  DCWideLoadingBar({
    required final this.console,
  });

  /// Loops the loading bar.
  Timer loop() {
    final width = console.columns - 2;
    bool go_forward = true;
    bool is_done = true;
    return Timer.periodic(
      const Duration(milliseconds: 50),
      (final timer) async {
        if (is_done) {
          is_done = false;
          for (int i = 1; i <= width; i++) {
            position = i;
            await Future<void>.delayed(const Duration(milliseconds: 5));
            if (go_forward) {
              forward();
            } else {
              backward();
            }
          }
          go_forward = !go_forward;
          is_done = true;
        }
      },
    );
  }

  /// Moves the Bar Forward
  void forward() {
    final out = StringBuffer('[');
    final width = console.columns - 2;
    final after = width - position;
    final before = width - after - 1;
    for (int i = 1; i <= before; i++) {
      out.write(' ');
    }
    out.write('=');
    for (int i = 1; i <= after; i++) {
      out.write(' ');
    }
    out.write(']');
    console.overwrite_line(out.toString());
  }

  /// Moves the Bar Backward
  void backward() {
    final out = StringBuffer('[');
    final width = console.columns - 2;
    final before = width - position;
    final after = width - before - 1;
    for (int i = 1; i <= before; i++) {
      out.write(' ');
    }
    out.write('=');
    for (int i = 1; i <= after; i++) {
      out.write(' ');
    }
    out.write(']');
    console.overwrite_line(out.toString());
  }
}
