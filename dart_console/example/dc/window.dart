import 'dart:async';
import 'dart:io';

import 'package:dart_console3/dc/base.dart';
import 'package:dart_console3/dc/progress.dart';
import 'package:dart_console3/dc/window.dart';

/// Example of a full-screen window, as needed for a text editor.
void main() {
  final console = DCConsole(
    raw_console: DCStdioConsoleAdapter(),
  );
  final window = DemoWindow(
    console: console,
  );
  window.display();
}

class DemoWindow extends DCWindow {
  bool show_welcome_message = true;
  Timer? loader_timer;

  DemoWindow({
    required final DCConsole console,
  }) : super(
          console,
          'Hello',
        );

  @override
  void draw() {
    super.draw();
    if (loader_timer != null) {
      loader_timer!.cancel();
    }
    if (show_welcome_message) {
      write_centered('Welcome!');
    } else {
      console.center_cursor();
      console.move_to_column(1);
      final loader = DCWideLoadingBar(
        console: console,
      );
      loader_timer = loader.loop();
    }
  }

  @override
  void initialize() {
    keyboard.bind_keys(['q', 'Q']).listen(
      (final _) {
        close();
        console.reset_all();
        console.erase_display();
        exit(0);
      },
    );
    keyboard.bind_key('x').listen(
      (final _) {
        if (title == 'Hello') {
          title = 'Goodbye';
        } else {
          title = 'Hello';
        }
        draw();
      },
    );
    keyboard.bind_key(" ").listen(
      (final _) {
        show_welcome_message = false;
        draw();
      },
    );
    keyboard.bind_key('p').listen(
      (final _) {
        if (loader_timer != null) {
          loader_timer!.cancel();
          loader_timer = null;
        }
      },
    );
  }
}
