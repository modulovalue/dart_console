import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:dart_console3/ansi_writer/ansi_writer.dart';
import 'package:dart_console3/console/impl.dart';
import 'package:dart_console3/console/interface.dart';
import 'package:dart_console3/terminal/terminal_lib_auto.dart';

void main(
  final List<String> arguments,
) {
  final all_demos = Demo.allDemos();
  final console = SneathConsoleImpl(
    terminal: auto_sneath_terminal(),
  );
  for (int i = 0; i < all_demos.length; i++) {
    console.clear_screen();
    all_demos[i](console);
    console.write_line();
    final demo_is_last = i == all_demos.length - 1;
    if (demo_is_last) {
      console.write_line('Press any key to end the demo sequence...');
    } else {
      console.write_line('Press any key to continue, or Ctrl+C to quit...');
    }
    final key = console.read_key();
    console.reset_color_attributes();
    if (key == const KeyControlImpl(ControlCharacters.ctrlC)) {
      exit(1);
    }
  }
}

abstract class Demo {
  static List<void Function(SneathConsole console)> allDemos() {
    return [
        whimsical_loading_screen,
        color_set_and_alignment_demonstration,
        extended_foreground_colors_demonstration,
        extended_background_colors_demonstration,
        twinkling_starts_demo,
      ];
  }

  static void whimsical_loading_screen(
    final SneathConsole console,
  ) {
    console.set_background_color(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorBlueImpl()));
    console.set_foreground_color(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.clear_screen();
    final row = (console.dimensions.height / 2).round() - 1;
    final progress_bar_width = max(console.dimensions.width - 10, 10);
    console.cursor_position.update(SneathCoordinateImpl(row: row - 2, col: 0));
    console.write_line('L O A D I N G', ConsoleTextAlignments.center);
    console.cursor_position.update(SneathCoordinateImpl(row: row + 2, col: 0));
    console.write_line('Please wait while we make you some avocado toast...', ConsoleTextAlignments.center);
    console.hide_cursor();
    for (int i = 0; i <= 50; i++) {
      console.cursor_position.update(SneathCoordinateImpl(row: row, col: 4));
      final progress = (i / 50 * progress_bar_width).ceil();
      final bar = '[${'#' * progress}${' ' * (progress_bar_width - progress)}]';
      console.write(bar);
      sleep(const Duration(milliseconds: 40));
    }
    console.show_cursor();
    console.cursor_position.update(SneathCoordinateImpl(row: console.dimensions.height - 3, col: 0));
  }

  static void color_set_and_alignment_demonstration(
    final SneathConsole console,
  ) {
    console.set_background_color(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorBlueImpl()));
    console.set_foreground_color(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.write_line('Simple Demo', ConsoleTextAlignments.center);
    console.reset_color_attributes();
    console.write_line();
    console.write_line(
        'This console window has ${console.dimensions.width} cols and ${console.dimensions.height} rows.',);
    console.write_line();
    console.write_line('This text is left aligned.', ConsoleTextAlignments.left);
    console.write_line('This text is center aligned.', ConsoleTextAlignments.center);
    console.write_line('This text is right aligned.', ConsoleTextAlignments.right);
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
      console.set_foreground_color(color);
      console.write_line(color.name);
    }
    console.reset_color_attributes();
  }

  static void extended_foreground_colors_demonstration(
    final SneathConsole console,
  ) {
    console.set_background_color(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorRedImpl()));
    console.set_foreground_color(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.write_line('ANSI Extended 256-Color Foreground Test', ConsoleTextAlignments.center);
    console.reset_color_attributes();
    console.write_line();
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        final color = i * 16 + j;
        console.set_foreground_extended_color(AnsiExtendedColorPaletteRawImpl(color, "Unknown"));
        console.write(color.toString().padLeft(4));
      }
      console.write_line();
    }
    console.reset_color_attributes();
  }

  static void extended_background_colors_demonstration(
    final SneathConsole console,
  ) {
    console.set_background_color(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorGreenImpl()));
    console.set_foreground_color(const DarkAnsiForegroundColorAdapter(NamedAnsiColorWhiteImpl()));
    console.write_line('ANSI Extended 256-Color Background Test', ConsoleTextAlignments.center);
    console.reset_color_attributes();
    console.write_line();
    for (int i = 0; i < 0xf; i++) {
      for (int j = 0; j < 0xf; j++) {
        final color = i * 0xf + j;
        console.set_background_extended_color(AnsiExtendedColorPaletteRawImpl(color, "Unknown"));
        console.write(color.toString().padLeft(4));
      }
      console.write_line();
    }
    console.reset_color_attributes();
  }

  static void twinkling_starts_demo(
    final SneathConsole console,
  ) {
    final stars = Queue<SneathCoordinate>();
    final rng = Random();
    const num_stars = 750;
    const max_stars_on_screen = 250;
    void add_star() {
      final star = SneathCoordinateImpl(
        row: rng.nextInt(console.dimensions.height - 1) + 1,
        col: rng.nextInt(console.dimensions.width),
      );
      console.cursor_position.update(star);
      console.write('*');
      stars.addLast(star);
    }

    void remove_star() {
      final star = stars.first;
      console.cursor_position.update(star);
      console.write(' ');
      stars.removeFirst();
    }

    console.set_background_color(const DarkAnsiBackgroundColorAdapter(NamedAnsiColorYellowImpl()));
    console.set_foreground_color(const BrightAnsiForegroundColorAdapter(NamedAnsiColorBlackImpl()));
    console.write_line('Stars', ConsoleTextAlignments.center);
    console.reset_color_attributes();
    console.hide_cursor();
    console.set_foreground_color(const BrightAnsiForegroundColorAdapter(NamedAnsiColorYellowImpl()));
    for (int i = 0; i < num_stars; i++) {
      if (i < num_stars - max_stars_on_screen) {
        add_star();
      }
      if (i >= max_stars_on_screen) {
        remove_star();
      }
      sleep(const Duration(milliseconds: 1));
    }
    console.reset_color_attributes();
    console.cursor_position.update(SneathCoordinateImpl(row: console.dimensions.height - 3, col: 0));
    console.show_cursor();
  }
}
