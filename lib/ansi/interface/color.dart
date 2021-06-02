abstract class NamedAnsiColor {
  /// An ANSI/VT100 background color color.
  int get backgroundColorCode;

  /// An ANSI/VT100 foreground color color.
  int get foregroundColorCode;

  /// The name of this color.
  String get name;
}
