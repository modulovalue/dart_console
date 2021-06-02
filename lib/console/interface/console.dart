import '../../ansi/interface/color.dart';
import 'control_character.dart';
import 'coordinate.dart';
import 'key.dart';
import 'text_alignment.dart';

/// A representation of the current console window.
///
/// Use the [SneathConsole] to get information about the current window and to read
/// and write to it.
///
/// A comprehensive set of demos of using the Console class can be found in the
/// `examples/` subdirectory.
/// TODO detect mouse and hover events.
/// TODO See https://stackoverflow.com/questions/51909557/mouse-events-in-terminal-emulator
/// TODO See https://stackoverflow.com/questions/59864485/capturing-mouse-in-virtual-terminal-with-ansi-escape
abstract class SneathConsole {
  /// Enables or disables raw mode.
  ///
  /// There are a series of flags applied to a UNIX-like terminal that together
  /// constitute 'raw mode'. These flags turn off echoing of character input,
  /// processing of input signals like Ctrl+C, and output processing, as well as
  /// buffering of input until a full line is entered.
  ///
  /// Raw mode is useful for console applications like text editors, which
  /// perform their own input and output processing, as well as for reading a
  /// single key from the input.
  ///
  /// In general, you should not need to enable or disable raw mode explicitly;
  /// you should call the [readKey] command, which takes care of handling raw
  /// mode for you.
  ///
  /// If you use raw mode, you should disable it before your program returns, to
  /// avoid the console being left in a state unsuitable for interactive input.
  ///
  /// When raw mode is enabled, the newline command (`\n`) does not also perform
  /// a carriage return (`\r`). You can use the [newLine] property or the
  /// [writeLine] function instead of explicitly using `\n` to ensure the
  /// correct results.
  ///
  set rawMode(bool value);

  /// Returns whether the terminal is in raw mode.
  ///
  /// There are a series of flags applied to a UNIX-like terminal that together
  /// constitute 'raw mode'. These flags turn off echoing of character input,
  /// processing of input signals like Ctrl+C, and output processing, as well as
  /// buffering of input until a full line is entered.
  bool get rawMode;

  /// Clears the entire screen
  void clearScreen();

  /// Erases all the characters in the current line.
  void eraseLine();

  /// Erases the current line from the cursor to the end of the line.
  void eraseCursorToEnd();

  /// Returns the width of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window width, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid width from either method, the method
  /// throws an [Exception].
  int get windowWidth;

  /// Returns the height of the current console window in characters.
  ///
  /// This command attempts to use the ioctl() system call to retrieve the
  /// window height, and if that fails uses ANSI escape codes to identify its
  /// location by walking off the edge of the screen and seeing what the
  /// terminal clipped the cursor to.
  ///
  /// If unable to retrieve a valid height from either method, the method
  /// throws an [Exception].
  int get windowHeight;

  /// Hides the cursor.
  ///
  /// If you hide the cursor, you should take care to return the cursor to
  /// a visible status at the end of the program, even if it throws an
  /// exception, by calling the [showCursor] method.
  void hideCursor();

  /// Shows the cursor.
  void showCursor();

  /// Moves the cursor one position to the left.
  void cursorLeft();

  /// Moves the cursor one position to the right.
  void cursorRight();

  /// Moves the cursor one position up.
  void cursorUp();

  /// Moves the cursor one position down.
  void cursorDown();

  /// Moves the cursor to the top left corner of the screen.
  void resetCursorPosition();

  /// Returns the current cursor position as a coordinate.
  ///
  /// Warning: Linux and macOS terminals report their cursor position by
  /// posting an escape sequence to stdin in response to a request. However,
  /// if there is lots of other keyboard input at the same time, some
  /// terminals may interleave that input in the response. There is no
  /// easy way around this; the recommendation is therefore to use this call
  /// before reading keyboard input, to get an original offset, and then
  /// track the local cursor independently based on keyboard input.
  Coordinate? get cursorPosition;

  /// Sets the cursor to a specific coordinate.
  ///
  /// Coordinates are measured from the top left of the screen, and are
  /// zero-based.
  set cursorPosition(Coordinate? cursor);

  /// Sets the console foreground color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [NamedAnsiColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void setForegroundColor(NamedAnsiColor foreground);

  /// Sets the console background color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [NamedAnsiColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void setBackgroundColor(NamedAnsiColor background);

  /// Sets the foreground to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void setForegroundExtendedColor(int colorValue);

  /// Sets the background to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void setBackgroundExtendedColor(int colorValue);

  /// Sets the text style.
  ///
  /// Note that not all styles may be supported by all terminals.
  void setTextStyle({
    bool bold,
    bool underscore,
    bool blink,
    bool inverted,
  });

  /// Resets all color attributes and text styles to the default terminal
  /// setting.
  void resetColorAttributes();

  /// Writes the text to the console.
  void write(String text);

  /// Returns the current newline string.
  String get newLine;

  /// Writes an error message to the console, with newline automatically
  /// appended.
  void writeErrorLine(String text);

  /// Writes a line to the console, optionally with alignment provided by the
  /// [ConsoleTextAlignment] enumeration.
  ///
  /// If no parameters are supplied, the command simply writes a new line
  /// to the console. By default, text is left aligned.
  ///
  /// Text alignment operates based off the current window width, and pads
  /// the remaining characters with a space character.
  void writeLine([
    String? text,
    ConsoleTextAlignment alignment,
  ]);

  void writeLineCentered(String? text);

  void writeLines(
    Iterable<String> lines,
    ConsoleTextAlignment alignment,
  );

  void writeLinesCentered(Iterable<String> lines);

  /// Reads a single key from the input, including a variety of control
  /// characters.
  ///
  /// Keys are represented by the [Key] class. Keys may be printable (if so,
  /// `Key.isControl` is `false`, and the `Key.char` property may be used to
  /// identify the key pressed. Non-printable keys have `Key.isControl` set
  /// to `true`, and if so the `Key.char` property is empty and instead the
  /// `Key.controlChar` property will be set to a value from the
  /// [ControlCharacter] enumeration that describes which key was pressed.
  ///
  /// Owing to the limitations of terminal key handling, certain keys may
  /// be represented by multiple control key sequences. An example showing
  /// basic key handling can be found in the `example/command_line.dart`
  /// file in the package source code.
  Key readKey();

  /// Reads a line of input, handling basic keyboard navigation commands.
  ///
  /// The Dart [stdin.readLineSync()] function reads a line from the input,
  /// however it does not handle cursor navigation (e.g. arrow keys, home and
  /// end keys), and has side-effects that may be unhelpful for certain console
  /// applications. For example, Ctrl+C is processed as the break character,
  /// which causes the application to immediately exit.
  ///
  /// The implementation does not currently allow for multi-line input. It
  /// is best suited for short text fields that are not longer than the width
  /// of the current screen.
  ///
  /// By default, readLine ignores break characters (e.g. Ctrl+C) and the Esc
  /// key, but if enabled, the function will exit and return a null string if
  /// those keys are pressed.
  ///
  /// A callback function may be supplied, as a peek-ahead for what is being
  /// entered. This is intended for scenarios like auto-complete, where the
  /// text field is coupled with some other content.
  String? readLine({
    bool cancelOnBreak,
    bool cancelOnEscape,
    bool cancelOnEOF,
    void Function(String text, Key lastPressed)? callback,
  });
}
