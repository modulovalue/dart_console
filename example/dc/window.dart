import 'dart:async';
import 'dart:io';

import 'package:dart_console/ansi/impl/ansi.dart';
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

  DemoWindow(DCConsole console) : super(console, 'Hello');

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
    keyboard.bindKeys(['q', 'Q']).listen((_) {
      close();
      console.resetAll();
      console.eraseDisplay();
      exit(0);
    });
    keyboard.bindKey('x').listen((_) {
      title = title == 'Hello' ? 'Goodbye' : 'Hello';
      draw();
    });
    keyboard.bindKey(AnsiConstants.space).listen((_) {
      showWelcomeMessage = false;
      draw();
    });
    keyboard.bindKey('p').listen((_) {
      if (loaderTimer != null) {
        loaderTimer!.cancel();
        loaderTimer = null;
      }
    });
  }
}
