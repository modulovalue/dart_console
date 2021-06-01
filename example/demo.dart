import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/console/interface/control_characters.dart';
import 'package:dart_console/console/interface/coordinate.dart';
import 'package:dart_console/console/interface/key.dart';
import 'package:dart_console/console/interface/text_alignments.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

final console = SneathConsoleImpl(autoDetectSneathTerminalLib());

List<void Function()> demoScreens = [
  // SCREEN 1: Whimsical loading screen :)
  (() {
    console.setBackgroundColor(NamedAnsiColor.blue);
    console.setForegroundColor(NamedAnsiColor.white);
    console.clearScreen();
    final row = (console.windowHeight / 2).round() - 1;
    final progressBarWidth = max(console.windowWidth - 10, 10);
    console.cursorPosition = CoordinateImpl(row - 2, 0);
    console.writeLine('L O A D I N G', TextAlignment.center);
    console.cursorPosition = CoordinateImpl(row + 2, 0);
    console.writeLine('Please wait while we make you some avocado toast...', TextAlignment.center);
    console.hideCursor();
    for (var i = 0; i <= 50; i++) {
      console.cursorPosition = CoordinateImpl(row, 4);
      final progress = (i / 50 * progressBarWidth).ceil();
      final bar = '[${'#' * progress}${' ' * (progressBarWidth - progress)}]';
      console.write(bar);
      sleep(const Duration(milliseconds: 40));
    }
    console.showCursor();
    console.cursorPosition = CoordinateImpl(console.windowHeight - 3, 0);
  }),
  // SCREEN 2: General demonstration of basic color set and alignment.
  (() {
    console.setBackgroundColor(NamedAnsiColor.blue);
    console.setForegroundColor(NamedAnsiColor.white);
    console.writeLine('Simple Demo', TextAlignment.center);
    console.resetColorAttributes();
    console.writeLine();
    console.writeLine('This console window has ${console.windowWidth} cols and '
        '${console.windowHeight} rows.');
    console.writeLine();
    console.writeLine('This text is left aligned.', TextAlignment.left);
    console.writeLine('This text is center aligned.', TextAlignment.center);
    console.writeLine('This text is right aligned.', TextAlignment.right);
    for (final color in NamedAnsiColor.values) {
      console.setForegroundColor(color);
      console.writeLine(color.toString().split('.').last);
    }
    console.resetColorAttributes();
  }),
  // SCREEN 3: Show extended foreground colors
  (() {
    console.setBackgroundColor(NamedAnsiColor.red);
    console.setForegroundColor(NamedAnsiColor.white);
    console.writeLine('ANSI Extended 256-Color Foreground Test', TextAlignment.center);
    console.resetColorAttributes();
    console.writeLine();
    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.setForegroundExtendedColor(color);
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }
    console.resetColorAttributes();
  }),
  // SCREEN 4: Show extended background colors
  (() {
    console.setBackgroundColor(NamedAnsiColor.green);
    console.setForegroundColor(NamedAnsiColor.white);
    console.writeLine('ANSI Extended 256-Color Background Test', TextAlignment.center);
    console.resetColorAttributes();
    console.writeLine();
    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.setBackgroundExtendedColor(color);
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }
    console.resetColorAttributes();
  }),

  // SCREEN 5: Twinkling stars
  (() {
    final stars = Queue<Coordinate>();
    final rng = Random();
    const numStars = 750;
    const maxStarsOnScreen = 250;
    void addStar() {
      final star = CoordinateImpl(rng.nextInt(console.windowHeight - 1) + 1, rng.nextInt(console.windowWidth));
      console.cursorPosition = star;
      console.write('*');
      stars.addLast(star);
    }

    void removeStar() {
      final star = stars.first;
      console.cursorPosition = star;
      console.write(' ');
      stars.removeFirst();
    }

    console.setBackgroundColor(NamedAnsiColor.yellow);
    console.setForegroundColor(NamedAnsiColor.brightBlack);
    console.writeLine('Stars', TextAlignment.center);
    console.resetColorAttributes();
    console.hideCursor();
    console.setForegroundColor(NamedAnsiColor.brightYellow);
    for (var i = 0; i < numStars; i++) {
      if (i < numStars - maxStarsOnScreen) {
        addStar();
      }
      if (i >= maxStarsOnScreen) {
        removeStar();
      }
      sleep(const Duration(milliseconds: 1));
    }
    console.resetColorAttributes();
    console.cursorPosition = CoordinateImpl(console.windowHeight - 3, 0);
    console.showCursor();
  }),
];

//
// main
//
int main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    final selectedDemo = int.tryParse(arguments.first);
    if (selectedDemo != null && selectedDemo > 0 && selectedDemo <= demoScreens.length) {
      demoScreens = [demoScreens[selectedDemo - 1]];
    }
  }
  for (final demo in demoScreens) {
    console.clearScreen();
    demo();
    console.writeLine();
    if (demoScreens.indexOf(demo) != demoScreens.length - 1) {
      console.writeLine('Press any key to continue, or Ctrl+C to quit...');
    } else {
      console.writeLine('Press any key to end the demo sequence...');
    }
    final key = console.readKey();
    console.resetColorAttributes();
    if (key is ControlKey && key.controlChar == ControlCharacter.ctrlC) {
      return 1;
    }
  }
  return 0;
}
