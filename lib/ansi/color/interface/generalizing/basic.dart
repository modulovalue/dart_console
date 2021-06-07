import '../color_types/basic.dart';

abstract class AnsiBackgroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 background color code.
  int get backgroundColorCode;
}

abstract class AnsiForegroundColor implements AnsiBasicPalette {
  /// An ANSI/VT100 foreground color code.
  int get foregroundColorCode;
}

abstract class AnsiForegroundBackgroundColor implements AnsiBackgroundColor, AnsiForegroundColor, AnsiBasicPalette {}
