import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/console/impl/key.dart';
import 'package:dart_console/console/interface/console.dart';
import 'package:dart_console/console/interface/control_characters.dart';
import 'package:dart_console/console/interface/coordinate.dart';
import 'package:dart_console/console/interface/text_alignments.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

abstract class Demo {
  static List<void Function(SneathConsole console)> allDemos() => [
    whimsicalLoadingScreen,
    colorSetAndAlignmentDemonstration,
    extendedForegroundColorsDemonstration,
    extendedBackgroundColorsDemonstration,
    twinklingStartsDemo,
  ];

  static void whimsicalLoadingScreen(SneathConsole console) {
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
  }

  static void colorSetAndAlignmentDemonstration(SneathConsole console) {
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
  }

  static void extendedForegroundColorsDemonstration(SneathConsole console) {
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
  }

  static void extendedBackgroundColorsDemonstration(SneathConsole console) {
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
  }

  static void twinklingStartsDemo(SneathConsole console) {
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
  }
}

void main(List<String> arguments) {
  final allDemos = Demo.allDemos();
  final console = SneathConsoleImpl(autodetectSneathTerminal());
  for (int i = 0; i < allDemos.length; i++) {
    console.clearScreen();
    allDemos[i](console);
    console.writeLine();
    final demoIsLast = i == allDemos.length - 1;
    if (demoIsLast) {
      console.writeLine('Press any key to end the demo sequence...');
    } else {
      console.writeLine('Press any key to continue, or Ctrl+C to quit...');
    }
    final key = console.readKey();
    console.resetColorAttributes();
    if (key == const KeyControlImpl(ControlCharacter.ctrlC)) {
      exit(1);
    }
  }
}
