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
}

abstract class AnsiLib {
  static String ansiCursorPosition(int row, int col) => '\x1b[$row;${col}H';

  static String ansiSetColor(int color) => '\x1b[${color}m';

  static String ansiSetExtendedForegroundColor(int color) => '\x1b[38;5;${color}m';

  static String ansiSetExtendedBackgroundColor(int color) => '\x1b[48;5;${color}m';

  /// TODO not having any style seems to reset colors.
  static String ansiSetTextStyles({
    bool bold = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
  }) =>
      '\x1b[${[
        if (bold) 1,
        if (underscore) 4,
        if (blink) 5,
        if (inverted) 7,
      ].join(";")}m';
}
