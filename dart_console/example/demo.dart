import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_console/ansi/ansi.dart';
import 'package:dart_console/console/alignment.dart';
import 'package:dart_console/console/impl/console.dart';
import 'package:dart_console/console/impl/coordinate.dart';
import 'package:dart_console/console/impl/key.dart';
import 'package:dart_console/console/interface/console.dart';
import 'package:dart_console/console/interface/control_character.dart';
import 'package:dart_console/console/interface/coordinate.dart';
import 'package:dart_console/terminal/terminal_lib_auto.dart';

void main(
  final List<String> arguments,
) {
  final allDemos = Demo.allDemos();
  final console = SneathConsoleImpl(
    terminal: autoSneathTerminal(),
  );
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

  static void whimsicalLoadingScreen(
    final SneathConsole console,
  ) {
    console.setBackgroundColor(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorBlueImpl()));
    console.setForegroundColor(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.clearScreen();
    final row = (console.dimensions.height / 2).round() - 1;
    final progressBarWidth = max(console.dimensions.width - 10, 10);
    console.cursorPosition.update(SneathCoordinateImpl(row: row - 2, col: 0));
    console.writeLine('L O A D I N G', ConsoleTextAlignments.center);
    console.cursorPosition.update(SneathCoordinateImpl(row: row + 2, col: 0));
    console.writeLine('Please wait while we make you some avocado toast...', ConsoleTextAlignments.center);
    console.hideCursor();
    for (var i = 0; i <= 50; i++) {
      console.cursorPosition.update(SneathCoordinateImpl(row: row, col: 4));
      final progress = (i / 50 * progressBarWidth).ceil();
      final bar = '[${'#' * progress}${' ' * (progressBarWidth - progress)}]';
      console.write(bar);
      sleep(const Duration(milliseconds: 40));
    }
    console.showCursor();
    console.cursorPosition.update(SneathCoordinateImpl(row: console.dimensions.height - 3, col: 0));
  }

  static void colorSetAndAlignmentDemonstration(
    final SneathConsole console,
  ) {
    console.setBackgroundColor(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorBlueImpl()));
    console.setForegroundColor(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.writeLine('Simple Demo', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.writeLine();
    console
        .writeLine('This console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.');
    console.writeLine();
    console.writeLine('This text is left aligned.', ConsoleTextAlignments.left);
    console.writeLine('This text is center aligned.', ConsoleTextAlignments.center);
    console.writeLine('This text is right aligned.', ConsoleTextAlignments.right);
    for (final color in const [
      DarkAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorRedImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorGreenImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorBlueImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorMagentaImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorCyanImpl()),
      DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorRedImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorGreenImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorBlueImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorMagentaImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorCyanImpl()),
      BrightAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()),
    ]) {
      console.setForegroundColor(color);
      console.writeLine(color.name);
    }
    console.resetColorAttributes();
  }

  static void extendedForegroundColorsDemonstration(
    final SneathConsole console,
  ) {
    console.setBackgroundColor(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorRedImpl()));
    console.setForegroundColor(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
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

  static void extendedBackgroundColorsDemonstration(
    final SneathConsole console,
  ) {
    console.setBackgroundColor(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorGreenImpl()));
    console.setForegroundColor(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.writeLine('ANSI Extended 256-Color Background Test', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.writeLine();
    for (int i = 0; i < 0xf; i++) {
      for (int j = 0; j < 0xf; j++) {
        final color = i * 0xf + j;
        console.setBackgroundExtendedColor(AnsiExtendedColorPaletteRawImpl(color, "Unknown"));
        console.write(color.toString().padLeft(4));
      }
      console.writeLine();
    }
    console.resetColorAttributes();
  }

  static void twinklingStartsDemo(
    final SneathConsole console,
  ) {
    final stars = Queue<SneathCoordinate>();
    final rng = Random();
    const numStars = 750;
    const maxStarsOnScreen = 250;
    void addStar() {
      final star = SneathCoordinateImpl(
        row: rng.nextInt(console.dimensions.height - 1) + 1,
        col: rng.nextInt(console.dimensions.width),
      );
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

    console.setBackgroundColor(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorYellowImpl()));
    console.setForegroundColor(const BrightAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()));
    console.writeLine('Stars', ConsoleTextAlignments.center);
    console.resetColorAttributes();
    console.hideCursor();
    console.setForegroundColor(const BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()));
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
    console.cursorPosition.update(SneathCoordinateImpl(row: console.dimensions.height - 3, col: 0));
    console.showCursor();
  }
}
