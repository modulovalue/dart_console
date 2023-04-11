import '../ansi_writer/ansi_writer.dart';

/// A representation of the current console window.
///
/// Use the [SneathConsole] to get information about the current window and to read
/// and write to it.
///
/// A comprehensive set of demos of using the Console class can be found in the
/// `examples/` subdirectory.
// TODO detect mouse and hover events.
// TODO See https://stackoverflow.com/questions/51909557/mouse-events-in-terminal-emulator
// TODO See https://stackoverflow.com/questions/59864485/capturing-mouse-in-virtual-terminal-with-ansi-escape
// TODO input, output and info needs to be separated.
// TODO consider having a dsl that is interpreted later rather than interpreting the commands online.
abstract class SneathConsole {
  // TODO have dsl
  // region dsl
  /// Clears the entire screen
  void clear_screen();

  /// Erases all the characters in the current line.
  void erase_line();

  /// Erases the current line from the cursor to the end of the line.
  void erase_cursor_to_end();

  /// Hides the cursor.
  ///
  /// If you hide the cursor, you should take care to return the cursor to
  /// a visible status at the end of the program, even if it throws an
  /// exception, by calling the [show_cursor] method.
  void hide_cursor();

  /// Shows the cursor.
  void show_cursor();

  /// Moves the cursor one position to the left.
  void cursor_left();

  /// Moves the cursor one position to the right.
  void cursor_right();

  /// Moves the cursor one position up.
  void cursor_up();

  /// Moves the cursor one position down.
  void cursor_down();

  /// Moves the cursor to the top left corner of the screen.
  void reset_cursor_position();

  /// Sets the console foreground color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [AnsiForegroundColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void set_foreground_color(
    final AnsiForegroundColor foreground,
  );

  /// Sets the console background color to a named ANSI color.
  ///
  /// There are 16 named ANSI colors, as defined in the [AnsiBackgroundColor]
  /// enumeration. Depending on the console theme and background color,
  /// some colors may not offer a legible contrast against the background.
  void set_background_color(
    final AnsiBackgroundColor background,
  );

  /// Sets the foreground to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void set_foreground_extended_color(
    final AnsiExtendedColorPalette color,
  );

  /// Sets the background to one of 256 extended ANSI colors.
  ///
  /// See https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for
  /// the full set of colors. You may also run `examples/demo.dart` for this
  /// package, which provides a sample of each color in this list.
  void set_background_extended_color(
    final AnsiExtendedColorPalette color,
  );

  /// Sets the text style.
  ///
  /// Note that not all styles may be supported by all terminals.
  void set_text_style({
    final bool bold,
    final bool underscore,
    final bool blink,
    final bool inverted,
  });

  /// Resets all color attributes and text styles to the default terminal
  /// setting.
  void reset_color_attributes();

  /// Writes the text to the console.
  void write(
    final String text,
  );

  /// Writes an error message to the console, with newline automatically
  /// appended.
  void write_error_line(
    final String text,
  );

  /// Writes a line to the console, optionally with alignment provided by the
  /// [ConsoleTextAlignment] enumeration.
  ///
  /// If no parameters are supplied, the command simply writes a new line
  /// to the console. By default, text is left aligned.
  ///
  /// Text alignment operates based off the current window width, and pads
  /// the remaining characters with a space character.
  void write_line([
    final String? text,
    final ConsoleTextAlignment alignment,
  ]);

  void write_line_centered(
    final String? text,
  );

  void write_lines(
    final Iterable<String> lines,
    final ConsoleTextAlignment alignment,
  );

  void write_lines_centered(
    final Iterable<String> lines,
  );
  // endregion

  /// Returns whether the terminal is in raw mode.
  ///
  /// There are a series of flags applied to a UNIX-like terminal that together
  /// constitute 'raw mode'. These flags turn off echoing of character input,
  /// processing of input signals like Ctrl+C, and output processing, as well as
  /// buffering of input until a full line is entered.
  bool get raw_mode;

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
  /// you should call the [read_key] command, which takes care of handling raw
  /// mode for you.
  ///
  /// If you use raw mode, you should disable it before your program returns, to
  /// avoid the console being left in a state unsuitable for interactive input.
  ///
  /// When raw mode is enabled, the newline command (`\n`) does not also perform
  /// a carriage return (`\r`). You can use the [new_line] property or the
  /// [write_line] function instead of explicitly using `\n` to ensure the
  /// correct results.
  void set_raw_mode(
    final bool value,
  );

  /// Contains information about the width and height of the window.
  SneathConsoleDimensions get dimensions;

  /// Provides ways to retrieve and update the cursor position.
  SneathCursorPositionDelegate get cursor_position;

  /// Returns the current newline string.
  String get new_line;

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
  Key read_key();

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
  String? read_line({
    final bool cancel_on_break,
    final bool cancel_on_escape,
    final bool cancel_on_eof,
    final void Function(String text, Key lastPressed)? callback,
  });
}

abstract class SneathCursorPositionDelegate {
  /// Returns the current cursor position as a coordinate.
  ///
  /// Warning: Linux and macOS terminals report their cursor position by
  /// posting an escape sequence to stdin in response to a request. However,
  /// if there is lots of other keyboard input at the same time, some
  /// terminals may interleave that input in the response. There is no
  /// easy way around this; the recommendation is therefore to use this call
  /// before reading keyboard input, to get an original offset, and then
  /// track the local cursor independently based on keyboard input.
  SneathCoordinate? get();

  /// Sets the cursor to a specific coordinate.
  ///
  /// Coordinates are measured from the top left of the screen, and are
  /// zero-based.
  void update(
    final SneathCoordinate? cursor,
  );
}

/// A screen position, measured in rows and columns from the top-left origin
/// of the screen. Coordinates are zero-based, and converted as necessary
/// for the underlying system representation (e.g. one-based for VT-style
/// displays).
abstract class SneathCoordinate {
  /// Represents the vertical position i.e. the position on the Y axis.
  int get row;

  /// Represents the horizontal position i.e. the position on the X axis.
  int get col;
}

abstract class SneathConsoleDimensions {
  /// Returns the width of the current console window in characters.
  int get width;

  /// Returns the height of the current console window in characters.
  int get height;
}

/// A representation of a key character.
abstract class Key {
  Z match<Z>({
    required final Z Function(KeyPrintable) printable,
    required final Z Function(KeyControl) control,
  });
}

/// A representation of a printable key character.
abstract class KeyPrintable implements Key {
  String get char;
}

/// A representation of a control key character.
abstract class KeyControl implements Key {
  ControlCharacter get control_char;
}

// region control characters
// TODO sum type.
// TODO Unknown is not a control character and should be removed. These cases should be handled outside?
// TODO Or perhaps add a supertype where one child is unknown and the other represent all valid control characters.
/// Non-printable characters that can be entered from the keyboard.
abstract class ControlCharacters {
  static const ControlCharacterUnknownImpl unknown = ControlCharacterUnknownImpl._();
  static const ControlCharacterCtrlAImpl ctrlA = ControlCharacterCtrlAImpl._();
  static const ControlCharacterCtrlBImpl ctrlB = ControlCharacterCtrlBImpl._();
  static const ControlCharacterCtrlCImpl ctrlC = ControlCharacterCtrlCImpl._(); // Break
  static const ControlCharacterCtrlDImpl ctrlD = ControlCharacterCtrlDImpl._(); // End of File
  static const ControlCharacterCtrlEImpl ctrlE = ControlCharacterCtrlEImpl._();
  static const ControlCharacterCtrlFImpl ctrlF = ControlCharacterCtrlFImpl._();
  static const ControlCharacterCtrlGImpl ctrlG = ControlCharacterCtrlGImpl._(); // Bell
  static const ControlCharacterCtrlHImpl ctrlH = ControlCharacterCtrlHImpl._(); // Backspace
  static const ControlCharacterTabImpl tab = ControlCharacterTabImpl._();
  static const ControlCharacterCtrlJImpl ctrlJ = ControlCharacterCtrlJImpl._();
  static const ControlCharacterCtrlKImpl ctrlK = ControlCharacterCtrlKImpl._();
  static const ControlCharacterCtrlLImpl ctrlL = ControlCharacterCtrlLImpl._();
  static const ControlCharacterEnterImpl enter = ControlCharacterEnterImpl._();
  static const ControlCharacterCtrlNImpl ctrlN = ControlCharacterCtrlNImpl._();
  static const ControlCharacterCtrlOImpl ctrlO = ControlCharacterCtrlOImpl._();
  static const ControlCharacterCtrlPImpl ctrlP = ControlCharacterCtrlPImpl._();
  static const ControlCharacterCtrlQImpl ctrlQ = ControlCharacterCtrlQImpl._();
  static const ControlCharacterCtrlRImpl ctrlR = ControlCharacterCtrlRImpl._();
  static const ControlCharacterCtrlSImpl ctrlS = ControlCharacterCtrlSImpl._();
  static const ControlCharacterCtrlTImpl ctrlT = ControlCharacterCtrlTImpl._();
  static const ControlCharacterCtrlUImpl ctrlU = ControlCharacterCtrlUImpl._();
  static const ControlCharacterCtrlVImpl ctrlV = ControlCharacterCtrlVImpl._();
  static const ControlCharacterCtrlWImpl ctrlW = ControlCharacterCtrlWImpl._();
  static const ControlCharacterCtrlXImpl ctrlX = ControlCharacterCtrlXImpl._();
  static const ControlCharacterCtrlYImpl ctrlY = ControlCharacterCtrlYImpl._();
  static const ControlCharacterCtrlZImpl ctrlZ = ControlCharacterCtrlZImpl._(); // Suspend
  static const ControlCharacterArrowLeftImpl arrowLeft = ControlCharacterArrowLeftImpl._();
  static const ControlCharacterArrowRightImpl arrowRight = ControlCharacterArrowRightImpl._();
  static const ControlCharacterArrowUpImpl arrowUp = ControlCharacterArrowUpImpl._();
  static const ControlCharacterArrowDownImpl arrowDown = ControlCharacterArrowDownImpl._();
  static const ControlCharacterPageUpImpl pageUp = ControlCharacterPageUpImpl._();
  static const ControlCharacterPageDownImpl pageDown = ControlCharacterPageDownImpl._();
  static const ControlCharacterWordLeftImpl wordLeft = ControlCharacterWordLeftImpl._();
  static const ControlCharacterWordRightImpl wordRight = ControlCharacterWordRightImpl._();
  static const ControlCharacterHomeImpl home = ControlCharacterHomeImpl._();
  static const ControlCharacterEndImpl end = ControlCharacterEndImpl._();
  static const ControlCharacterEscapeImpl escape = ControlCharacterEscapeImpl._();
  static const ControlCharacterDeleteImpl delete = ControlCharacterDeleteImpl._();
  static const ControlCharacterBackspaceImpl backspace = ControlCharacterBackspaceImpl._();
  static const ControlCharacterWordBackspaceImpl wordBackspace = ControlCharacterWordBackspaceImpl._();
  static const ControlCharacterF1Impl F1 = ControlCharacterF1Impl._();
  static const ControlCharacterF2Impl F2 = ControlCharacterF2Impl._();
  static const ControlCharacterF3Impl F3 = ControlCharacterF3Impl._();
  static const ControlCharacterF4Impl F4 = ControlCharacterF4Impl._();
}

abstract class ControlCharacter {}

class ControlCharacterCtrlAImpl implements ControlCharacter {
  const ControlCharacterCtrlAImpl._();
}

class ControlCharacterCtrlBImpl implements ControlCharacter {
  const ControlCharacterCtrlBImpl._();
}

class ControlCharacterCtrlCImpl implements ControlCharacter {
  const ControlCharacterCtrlCImpl._();
}

class ControlCharacterCtrlDImpl implements ControlCharacter {
  const ControlCharacterCtrlDImpl._();
}

class ControlCharacterCtrlEImpl implements ControlCharacter {
  const ControlCharacterCtrlEImpl._();
}

class ControlCharacterCtrlFImpl implements ControlCharacter {
  const ControlCharacterCtrlFImpl._();
}

class ControlCharacterCtrlGImpl implements ControlCharacter {
  const ControlCharacterCtrlGImpl._();
}

class ControlCharacterCtrlHImpl implements ControlCharacter {
  const ControlCharacterCtrlHImpl._();
}

class ControlCharacterTabImpl implements ControlCharacter {
  const ControlCharacterTabImpl._();
}

class ControlCharacterCtrlJImpl implements ControlCharacter {
  const ControlCharacterCtrlJImpl._();
}

class ControlCharacterCtrlKImpl implements ControlCharacter {
  const ControlCharacterCtrlKImpl._();
}

class ControlCharacterCtrlLImpl implements ControlCharacter {
  const ControlCharacterCtrlLImpl._();
}

class ControlCharacterEnterImpl implements ControlCharacter {
  const ControlCharacterEnterImpl._();
}

class ControlCharacterCtrlNImpl implements ControlCharacter {
  const ControlCharacterCtrlNImpl._();
}

class ControlCharacterCtrlOImpl implements ControlCharacter {
  const ControlCharacterCtrlOImpl._();
}

class ControlCharacterCtrlPImpl implements ControlCharacter {
  const ControlCharacterCtrlPImpl._();
}

class ControlCharacterCtrlQImpl implements ControlCharacter {
  const ControlCharacterCtrlQImpl._();
}

class ControlCharacterCtrlRImpl implements ControlCharacter {
  const ControlCharacterCtrlRImpl._();
}

class ControlCharacterCtrlSImpl implements ControlCharacter {
  const ControlCharacterCtrlSImpl._();
}

class ControlCharacterCtrlTImpl implements ControlCharacter {
  const ControlCharacterCtrlTImpl._();
}

class ControlCharacterCtrlUImpl implements ControlCharacter {
  const ControlCharacterCtrlUImpl._();
}

class ControlCharacterCtrlVImpl implements ControlCharacter {
  const ControlCharacterCtrlVImpl._();
}

class ControlCharacterCtrlWImpl implements ControlCharacter {
  const ControlCharacterCtrlWImpl._();
}

class ControlCharacterCtrlXImpl implements ControlCharacter {
  const ControlCharacterCtrlXImpl._();
}

class ControlCharacterCtrlYImpl implements ControlCharacter {
  const ControlCharacterCtrlYImpl._();
}

class ControlCharacterCtrlZImpl implements ControlCharacter {
  const ControlCharacterCtrlZImpl._();
}

class ControlCharacterArrowUpImpl implements ControlCharacter {
  const ControlCharacterArrowUpImpl._();
}

class ControlCharacterArrowDownImpl implements ControlCharacter {
  const ControlCharacterArrowDownImpl._();
}

class ControlCharacterArrowRightImpl implements ControlCharacter {
  const ControlCharacterArrowRightImpl._();
}

class ControlCharacterArrowLeftImpl implements ControlCharacter {
  const ControlCharacterArrowLeftImpl._();
}

class ControlCharacterPageUpImpl implements ControlCharacter {
  const ControlCharacterPageUpImpl._();
}

class ControlCharacterPageDownImpl implements ControlCharacter {
  const ControlCharacterPageDownImpl._();
}

class ControlCharacterWordLeftImpl implements ControlCharacter {
  const ControlCharacterWordLeftImpl._();
}

class ControlCharacterWordRightImpl implements ControlCharacter {
  const ControlCharacterWordRightImpl._();
}

class ControlCharacterHomeImpl implements ControlCharacter {
  const ControlCharacterHomeImpl._();
}

class ControlCharacterEndImpl implements ControlCharacter {
  const ControlCharacterEndImpl._();
}

class ControlCharacterEscapeImpl implements ControlCharacter {
  const ControlCharacterEscapeImpl._();
}

class ControlCharacterDeleteImpl implements ControlCharacter {
  const ControlCharacterDeleteImpl._();
}

class ControlCharacterBackspaceImpl implements ControlCharacter {
  const ControlCharacterBackspaceImpl._();
}

class ControlCharacterWordBackspaceImpl implements ControlCharacter {
  const ControlCharacterWordBackspaceImpl._();
}

class ControlCharacterF1Impl implements ControlCharacter {
  const ControlCharacterF1Impl._();
}

class ControlCharacterF2Impl implements ControlCharacter {
  const ControlCharacterF2Impl._();
}

class ControlCharacterF3Impl implements ControlCharacter {
  const ControlCharacterF3Impl._();
}

class ControlCharacterF4Impl implements ControlCharacter {
  const ControlCharacterF4Impl._();
}

class ControlCharacterUnknownImpl implements ControlCharacter {
  const ControlCharacterUnknownImpl._();
}
// endregion

// region alignment
abstract class ConsoleTextAlignments {
  static const ConsoleTextAlignmentLeftImpl left = ConsoleTextAlignmentLeftImpl._();
  static const ConsoleTextAlignmentCenterImpl center = ConsoleTextAlignmentCenterImpl._();
  static const ConsoleTextAlignmentRightImpl right = ConsoleTextAlignmentRightImpl._();
}

/// Text alignments for console line output.
abstract class ConsoleTextAlignment {
  R match<R>({
    required final R Function(ConsoleTextAlignmentLeftImpl) left,
    required final R Function(ConsoleTextAlignmentCenterImpl) center,
    required final R Function(ConsoleTextAlignmentRightImpl) right,
  });
}

class ConsoleTextAlignmentLeftImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentLeftImpl._();

  @override
  R match<R>({
    required final R Function(ConsoleTextAlignmentLeftImpl) left,
    required final R Function(ConsoleTextAlignmentCenterImpl) center,
    required final R Function(ConsoleTextAlignmentRightImpl) right,
  }) =>
      left(this);
}

class ConsoleTextAlignmentCenterImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentCenterImpl._();

  @override
  R match<R>({
    required final R Function(ConsoleTextAlignmentLeftImpl) left,
    required final R Function(ConsoleTextAlignmentCenterImpl) center,
    required final R Function(ConsoleTextAlignmentRightImpl) right,
  }) =>
      center(this);
}

class ConsoleTextAlignmentRightImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentRightImpl._();

  @override
  R match<R>({
    required final R Function(ConsoleTextAlignmentLeftImpl) left,
    required final R Function(ConsoleTextAlignmentCenterImpl) center,
    required final R Function(ConsoleTextAlignmentRightImpl) right,
  }) =>
      right(this);
}
// endregion
