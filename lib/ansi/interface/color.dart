import 'basic_ansi_color.dart';
import 'color_name.dart';

abstract class AnsiBackgroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 background color code.
  int get backgroundColorCode;
}

abstract class AnsiForegroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 foreground color code.
  int get foregroundColorCode;
}

abstract class AnsiColor implements AnsiBackgroundColor, AnsiForegroundColor, AnsiBasicPalette {}

abstract class NamedAnsiColor implements AnsiColor, AnsiColorName {}

abstract class DarkNamedAnsiColor implements NamedAnsiColor {}

abstract class BrightNamedAnsiColor implements NamedAnsiColor {}
