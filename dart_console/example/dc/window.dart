import 'dart:async';
import 'dart:io';

import 'package:dart_ansi/ansi.dart';
import 'package:dart_console/dc/base.dart';
import 'package:dart_console/dc/progress.dart';
import 'package:dart_console/dc/window.dart';

// Example of a full-screen window, as needed for a text editor.
void main() {
  final console = DCConsole(DCStdioConsoleAdapter());
  final window = DemoWindow(console);
  window.display();
}

class DemoWindow extends DCWindow {
  bool showWelcomeMessage = true;
  Timer? loaderTimer;

  DemoWindow(
    final DCConsole console,
  ) : super(
          console,
          'Hello',
        );

  @override
  void draw() {
    super.draw();
    if (loaderTimer != null) {
      loaderTimer!.cancel();
    }
    if (showWelcomeMessage) {
      writeCentered('Welcome!');
    } else {
      console.centerCursor();
      console.moveToColumn(1);
      final loader = DCWideLoadingBar(console);
      loaderTimer = loader.loop();
    }
  }

  @override
  void initialize() {
    keyboard.bindKeys(['q', 'Q']).listen(
      (final _) {
        close();
        console.resetAll();
        console.eraseDisplay();
        exit(0);
      },
    );
    keyboard.bindKey('x').listen(
      (final _) {
        if (title == 'Hello') {
          title = 'Goodbye';
        } else {
          title = 'Hello';
        }
        draw();
      },
    );
    keyboard.bindKey(ansiSpace).listen(
      (final _) {
        showWelcomeMessage = false;
        draw();
      },
    );
    keyboard.bindKey('p').listen(
      (final _) {
        if (loaderTimer != null) {
          loaderTimer!.cancel();
          loaderTimer = null;
        }
      },
    );
  }
}
