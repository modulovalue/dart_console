import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_ansi/ansi.dart';
import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/console/impl/key.dart';
import 'package:dart_console/console/interface/console.dart';
import 'package:dart_console/console/interface/control_character.dart';
import 'package:dart_console/console/interface/coordinate.dart';
import 'package:dart_console/terminal/impl/auto/terminal_lib.dart';

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
    if (key == const KeyControlImpl(ControlCharacters.ctrlC)) {
      exit(1);
    }
  }
}

abstract class Demo {
  static List<void Function(SneathConsole console)> allDemos() => [
        whimsicalLoadingScreen,
        colorSetAndAlignmentDemonstration,
        extendedForegroundColorsDemonstration,
        extendedBackgroundColorsDemonstration,
        twinklingStartsDemo,
      ];

  static void whimsicalLoadingScreen(SneathConsole console) {
    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.blue));
    console.setForegroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.white));
    console.clearScreen();
    final row = (console.dimensions.height / 2).round() - 1;
    final progressBarWidth = max(console.dimensions.width - 10, 10);
    console.cursorPosition.update(SneathCoordinateImpl(row - 2, 0));
    console.writeLine('L O A D I N G', ConsoleTextAlignments.center);
    console.cursorPosition.update(SneathCoordinateImpl(row + 2, 0));
    console.writeLine('Please wait while we make you some avocado toast...', ConsoleTextAlignments.center);
    console.hideCursor();
    for (var i = 0; i <= 50; i++) {
      console.cursorPosition.update(SneathCoordinateImpl(row, 4));
      final progress = (i / 50 * progressBarWidth).ceil();
      final bar = '[${'#' * progress}${' ' * (progressBarWidth - progress)}]';
      console.write(bar);
      sleep(const Duration(milliseconds: 40));
    }
    console.showCursor();
    console.cursorPosition.update(SneathCoordinateImpl(console.dimensions.height - 3, 0));
  }

  static void colorSetAndAlignmentDemonstration(SneathConsole console) {
    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.blue));
    console.setForegroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.white));
    console.writeLine('Simple Demo', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.writeLine();
    console.writeLine('This console window has ${console.dimensions.width} cols and '
        '${console.dimensions.height} rows.');
    console.writeLine();
    console.writeLine('This text is left aligned.', ConsoleTextAlignments.left);
    console.writeLine('This text is center aligned.', ConsoleTextAlignments.center);
    console.writeLine('This text is right aligned.', ConsoleTextAlignments.right);
    for (final color in NamedAnsiColorsMore.allDarkAndBright) {
      console.setForegroundColor(color);
      console.writeLine(color.name);
    }
    console.resetColorAttributes();
  }

  static void extendedForegroundColorsDemonstration(SneathConsole console) {
    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.red));
    console.setForegroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.white));
    console.writeLine('ANSI Extended 256-Color Foreground Test', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.writeLine();
    for (var i = 0; i < 16; i++) {
      for (var j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.setForegroundExtendedColor(AnsiExtendedColorPaletteRawImpl(color, "Unknown"));
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }
    console.resetColorAttributes();
  }

  static void extendedBackgroundColorsDemonstration(SneathConsole console) {
    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.green));
    console.setForegroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.white));
    console.writeLine('ANSI Extended 256-Color Background Test', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.writeLine();
    for (var i = 0; i < nibbleSize; i++) {
      for (var j = 0; j < nibbleSize; j++) {
        final color = i * nibbleSize + j;
        console.setBackgroundExtendedColor(AnsiExtendedColorPaletteRawImpl(color, "Unknown"));
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }
    console.resetColorAttributes();
  }

  static void twinklingStartsDemo(SneathConsole console) {
    final stars = Queue<SneathCoordinate>();
    final rng = Random();
    const numStars = 750;
    const maxStarsOnScreen = 250;
    void addStar() {
      final star = SneathCoordinateImpl(rng.nextInt(console.dimensions.height - 1) + 1, rng.nextInt(console.dimensions.width));
      console.cursorPosition.update(star);
      console.write('*');
      stars.addLast(star);
    }

    void removeStar() {
      final star = stars.first;
      console.cursorPosition.update(star);
      console.write(' ');
      stars.removeFirst();
    }

    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.yellow));
    console.setForegroundColor(const BrightAnsiColorAdapter(NamedAnsiColors.black));
    console.writeLine('Stars', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.hideCursor();
    console.setForegroundColor(const BrightAnsiColorAdapter(NamedAnsiColors.yellow));
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
    console.cursorPosition.update(SneathCoordinateImpl(console.dimensions.height - 3, 0));
    console.showCursor();
  }
}
