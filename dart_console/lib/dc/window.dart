import 'dart:async';
import 'dart:io';

import '../keyboard/keyboard.dart';
import 'base.dart';

abstract class DCWindow {
  String title;
  Timer? _updateTimer;
  final DCConsole console;
  final TerminalKeyboard keyboard;

  DCWindow(
    final this.console,
    final this.title,
  ) : keyboard = make_terminal_keyboard(
          byte_stream: console.raw_console.byte_stream(),
          move_cursor_back_by_one: () => console.move_cursor_back(1),
        ) {
    DCConsole.on_resize.listen((final dynamic _) => draw());
    keyboard.disable_echo();
    initialize();
  }

  void initialize();

  void draw() {
    console.erase_display(2);
    final width = console.columns;
    console.move_cursor(row: 1, column: 1);
    console.set_background_color(7, bright: true);
    _repeat_function(
      func: (final dynamic i) => console.raw_console.write(' '),
      times: width,
    );
    console.set_text_color(0);
    console.move_cursor(
      row: 1,
      column: (console.columns / 2).round() - (title.length / 2).round(),
    );
    console.raw_console.write(title);
    _repeat_function(
      func: (final dynamic i) => console.raw_console.write('\n'),
      times: console.rows - 1,
    );
    console.move_cursor(row: 2, column: 1);
    console.center_cursor(row: true);
    console.reset_background_color();
  }

  void display() {
    draw();
  }

  Timer? startUpdateLoop([
    Duration? wait,
  ]) {
    wait ??= const Duration(seconds: 2);
    return _updateTimer = Timer.periodic(
      wait,
      (final timer) => draw(),
    );
  }

  void close() {
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }
    console.erase_display();
    console.move_cursor(row: 1, column: 1);
    stdin.echoMode = true;
  }

  void write_centered(
    final String text,
  ) {
    final column = ((console.columns / 2) - (text.length / 2)).round();
    final row = (console.rows / 2).round();
    console.move_cursor(row: row, column: column);
    console.raw_console.write(text);
  }
}

void _repeat_function({
  required final Function func,
  required final int times,
}) {
  for (int i = 1; i <= times; i++) {
    // ignore: avoid_dynamic_calls
    func(i);
  }
}
