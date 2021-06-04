import '../interface/byte_color.dart';
import '../interface/color.dart';
import 'ansi.dart';
import 'graphics_rendition_commands.dart';

/// Base functions.
/// http://www.climagic.org/mirrors/VT100_Escape_Codes.html
class AnsiStandardLib {
  static const cursorUpName = AnsiConstants.charArrowUp;
  static const cursorDownName = AnsiConstants.charArrowDown;
  static const cursorForwardName = AnsiConstants.charArrowRight;
  static const cursorBackName = AnsiConstants.charArrowLeft;
  static const cursorNextLineName = "E";
  static const cursorPreviousLineName = "F";
  static const cursorHorizontalAbsoluteName1 = "G";
  static const cursorHorizontalAbsoluteName2 = "f";
  static const cursorPositionName = "H";
  static const eraseInDisplayName = "J";
  static const eraseInLineName = "K";
  static const scrollUpName = "S";
  static const scrollDownName = "T";
  static const saveCursorPosName = "s";
  static const restoreCursorPosName = "u";
  static const selectGraphicsRenditionName = "m";
  static const showCursorName = "?25h";
  static const hideCursorName = "?25l";

  const AnsiStandardLib();

  /// Set graphics rendition mode.
  String selectGraphicsRendition(GraphicsRenditionNode nodes) => //
      AnsiLibBase.buildN(nodes.commands, selectGraphicsRenditionName);

  /// Shows the cursor.
  String showCursor(int n) => AnsiLibBase.build0(showCursorName);

  /// Hides the cursor
  String hideCursor(int n) => AnsiLibBase.build0(hideCursorName);

  /// Move cursor up by n.
  String cursorUp(int n) => AnsiLibBase.build1(n, cursorUpName);

  /// Move cursor down by n.
  String cursorDown(int n) => AnsiLibBase.build1(n, cursorDownName);

  /// Move cursor forward by n.
  String cursorForward(int n) => AnsiLibBase.build1(n, cursorForwardName);

  /// Move cursor back by n.
  String cursorBack(int n) => AnsiLibBase.build1(n, cursorBackName);

  /// Move cursor to the beginning of the line n lines down.
  String cursorNextLine(int n) => AnsiLibBase.build1(n, cursorNextLineName);

  /// Move cursor to the beginning of the line n lines up.
  String cursorPreviousLine(int n) => AnsiLibBase.build1(n, cursorPreviousLineName);

  /// Move cursor to the column n within the current row.
  String cursorHorizontalAbsolute1(int n) => AnsiLibBase.build1(n, cursorHorizontalAbsoluteName1);

  /// Move cursor to the column n within the current row.
  String cursorHorizontalAbsolute2(int n) => AnsiLibBase.build1(n, cursorHorizontalAbsoluteName2);

  /// Move cursor to row n, column m, counting from the top left corner.
  String cursorPosition(int row, int column) => AnsiLibBase.build2(row, column, cursorPositionName);

  /// Clear part of the screen. 0, 1, 2, and 3 have various specific functions.
  // TODO Clear Screen: \u001b[{n}J clears the screen
  // TODO n=0 clears from cursor until end of screen,
  // TODO n=1 clears from cursor to beginning of screen
  // TODO n=2 clears entire screen
  String eraseInDisplay() => AnsiLibBase.build0(eraseInDisplayName);

  /// Clear part of the line. 0, 1, and 2 have various specific functions
  // TODO Clear Line: \u001b[{n}K clears the current line
  // TODO n=0 clears from cursor to end of line
  // TODO n=1 clears from cursor to start of line
  // TODO n=2 clears entire line
  String eraseInLine() => AnsiLibBase.build0(eraseInLineName);

  /// Scroll window up by n lines.
  String scrollUp(int n) => AnsiLibBase.build1(n, scrollUpName);

  /// Scroll window down by n lines.
  String scrollDown(int n) => AnsiLibBase.build1(n, scrollDownName);

  /// Save current cursor position for use with u.
  String saveCursorPosition() => AnsiLibBase.build0(saveCursorPosName);

  /// Set cursor back to position last saved by s.
  String restoreCursorPosition() => AnsiLibBase.build0(restoreCursorPosName);
}

/// Meaningful functions that are derived from the base functions.
class AnsiStandardLibDerived {
  const AnsiStandardLibDerived();

  String ansiSetExtendedForegroundColor(AnsiExtendedColorPalette color) => //
      const AnsiStandardLib().selectGraphicsRendition(
        GraphicsRenditionNodeExtendedTextColorImpl(color),
      );

  String ansiSetExtendedBackgroundColor(AnsiExtendedColorPalette color) => //
      const AnsiStandardLib().selectGraphicsRendition(
        GraphicsRenditionNodeExtendedBackgroundColorImpl(color),
      );

  String ansiSetTextColor(AnsiForegroundColor color) => //
      const AnsiStandardLib().selectGraphicsRendition(
        GraphicsRenditionNodeColorImpl(
          color.foregroundColorCode,
        ),
      );

  String ansiSetBackgroundColor(AnsiBackgroundColor color) => //
      const AnsiStandardLib().selectGraphicsRendition(
        GraphicsRenditionNodeColorImpl(
          color.backgroundColorCode,
        ),
      );

  /// Moves the cursor to the start of the line. Same as '\r'.
  String carriageReturn() => //
      const AnsiStandardLib().cursorHorizontalAbsolute1(1);

  String ansiSetTextStyles({
    bool bold = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
  }) =>
      const AnsiStandardLib().selectGraphicsRendition(
        CompositeGraphicsRenditionNode(
          [
            if (bold) const GraphicsRenditionNodeHighlightImpl(),
            if (underscore) const GraphicsRenditionNodeUnderlineImpl(),
            if (blink) const GraphicsRenditionNodeBlinkImpl(),
            if (inverted) const GraphicsRenditionNodeInvertedImpl(),
          ],
        ),
      );
}

abstract class AnsiLibBase {
  /// Build an ansi function with no arguments.
  static String build0(String name) => //
      AnsiConstants.controlSequenceIdentifier + name;

  /// Build an ansi function with one fixed argument.
  static String build1(int arg, String name) => //
      AnsiConstants.controlSequenceIdentifier + arg.toString() + name;

  /// Build an ansi function with two fixed arguments.
  static String build2(int arg0, int arg1, String name) => //
      AnsiConstants.controlSequenceIdentifier + arg0.toString() + AnsiConstants.commandArgumentSeparator + arg1.toString() + name;

  /// Build an ansi function with a variable amount of arguments.
  static String buildN(Iterable<int> args, String name) => //
      AnsiConstants.controlSequenceIdentifier + args.join(AnsiConstants.commandArgumentSeparator) + name;
}
