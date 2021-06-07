import 'dart:async';
import 'dart:io';

import '../keyboard/impl/keyboard.dart';
import 'base.dart';

abstract class DCWindow {
  String title;
  Timer? _updateTimer;
  final DCConsole console;
  final TerminalKeyboardImpl keyboard;

  DCWindow(this.console, this.title)
      : keyboard = TerminalKeyboardImpl(
          byteStream: console.rawConsole.byteStream(),
          moveCursorBackByOne: () => console.moveCursorBack(1),
        ) {
    _init();
    initialize();
  }

  void initialize();

  void _init() {
    stdin.echoMode = false;
    DCConsole.onResize.listen((dynamic _) => draw());
    keyboard.echoUnhandledKeys = false;
  }

  void draw() {
    console.eraseDisplay(2);
    final width = console.columns;
    console.moveCursor(row: 1, column: 1);
    console.setBackgroundColor(7, bright: true);
    _repeatFunction((dynamic i) => console.rawConsole.write(' '), width);
    console.setTextColor(0);
    console.moveCursor(
      row: 1,
      column: (console.columns / 2).round() - (title.length / 2).round(),
    );
    console.rawConsole.write(title);
    _repeatFunction((dynamic i) => console.rawConsole.write('\n'), console.rows - 1);
    console.moveCursor(row: 2, column: 1);
    console.centerCursor(row: true);
    console.resetBackgroundColor();
  }

  void display() {
    draw();
  }

  Timer? startUpdateLoop([Duration? wait]) {
    wait ??= const Duration(seconds: 2);
    return _updateTimer = Timer.periodic(wait, (timer) => draw());
  }

  void close() {
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }
    console.eraseDisplay();
    console.moveCursor(row: 1, column: 1);
    stdin.echoMode = true;
  }

  void writeCentered(String text) {
    final column = ((console.columns / 2) - (text.length / 2)).round();
    final row = (console.rows / 2).round();
    console.moveCursor(row: row, column: column);
    console.rawConsole.write(text);
  }
}

void _repeatFunction(Function func, int times) {
  for (var i = 1; i <= times; i++) {
    // ignore: avoid_dynamic_calls
    func(i);
  }
}
