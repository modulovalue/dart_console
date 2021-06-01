/// Contains ANSI escape sequences used by dart_console.
///
/// For more information on commonly-accepted ANSI mode control sequences, read
/// https://vt100.net/docs/vt100-ug/chapter3.html.
abstract class AnsiConstants {
  static const ansiDeviceStatusReportCursorPosition = '\x1b[6n';
  static const ansiEraseInDisplayAll = '\x1b[2J';
  static const ansiEraseInLineAll = '\x1b[2K';
  static const ansiEraseCursorToEnd = '\x1b[K';
  static const ansiHideCursor = '\x1b[?25l';
  static const ansiShowCursor = '\x1b[?25h';
  static const ansiCursorLeft = '\x1b[D';
  static const ansiCursorRight = '\x1b[C';
  static const ansiCursorUp = '\x1b[A';
  static const ansiCursorDown = '\x1b[B';
  static const ansiResetCursorPosition = '\x1b[H';
  static const ansiMoveCursorToScreenEdge = '\x1b[999C\x1b[999B';
  static const ansiResetColor = '\x1b[m';

  /// A list of ANSI/VT100 color codes for foreground colors.
  static const ansiForegroundColors = {
    NamedAnsiColor.black: 30,
    NamedAnsiColor.red: 31,
    NamedAnsiColor.green: 32,
    NamedAnsiColor.yellow: 33,
    NamedAnsiColor.blue: 34,
    NamedAnsiColor.magenta: 35,
    NamedAnsiColor.cyan: 36,
    NamedAnsiColor.white: 37,
    NamedAnsiColor.brightBlack: 90,
    NamedAnsiColor.brightRed: 91,
    NamedAnsiColor.brightGreen: 92,
    NamedAnsiColor.brightYellow: 93,
    NamedAnsiColor.brightBlue: 94,
    NamedAnsiColor.brightMagenta: 95,
    NamedAnsiColor.brightCyan: 96,
    NamedAnsiColor.brightWhite: 97
  };

  /// A list of ANSI/VT100 color codes for background colors.
  static const ansiBackgroundColors = {
    NamedAnsiColor.black: 40,
    NamedAnsiColor.red: 41,
    NamedAnsiColor.green: 42,
    NamedAnsiColor.yellow: 43,
    NamedAnsiColor.blue: 44,
    NamedAnsiColor.magenta: 45,
    NamedAnsiColor.cyan: 46,
    NamedAnsiColor.white: 47,
    NamedAnsiColor.brightBlack: 100,
    NamedAnsiColor.brightRed: 101,
    NamedAnsiColor.brightGreen: 102,
    NamedAnsiColor.brightYellow: 103,
    NamedAnsiColor.brightBlue: 104,
    NamedAnsiColor.brightMagenta: 105,
    NamedAnsiColor.brightCyan: 106,
    NamedAnsiColor.brightWhite: 107
  };
}

abstract class AnsiLib {
  static String ansiCursorPosition(int row, int col) => '\x1b[$row;${col}H';

  static String ansiSetColor(int color) => '\x1b[${color}m';

  static String ansiSetExtendedForegroundColor(int color) => '\x1b[38;5;${color}m';

  static String ansiSetExtendedBackgroundColor(int color) => '\x1b[48;5;${color}m';

  static String ansiSetTextStyles({bool bold = false, bool underscore = false, bool blink = false, bool inverted = false}) {
    final styles = <int>[];
    if (bold) styles.add(1);
    if (underscore) styles.add(4);
    if (blink) styles.add(5);
    if (inverted) styles.add(7);
    return '\x1b[${styles.join(";")}m';
  }
}

/// TODO this should be an adt and contain the constants defined above.
/// TODO Make console depend only on the interface of that adt.
enum NamedAnsiColor {
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  brightBlack,
  brightRed,
  brightGreen,
  brightYellow,
  brightBlue,
  brightMagenta,
  brightCyan,
  brightWhite
}
