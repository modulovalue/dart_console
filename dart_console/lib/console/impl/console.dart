import 'dart:io';
import 'dart:math';

import '../../ansi/ansi.dart';
import '../../ansi/parser.dart';
import '../../terminal/terminal_lib.dart';
import '../alignment.dart';
import '../interface/console.dart';
import '../interface/control_character.dart';
import '../interface/cursor_position.dart';
import '../interface/dimensions.dart';
import '../interface/key.dart';
import 'coordinate.dart';
import 'cursor_position.dart';
import 'dimensions/constant.dart';
import 'key.dart';

// TODO have a mixin and separate impls. for scrolling and non scrolling.
class SneathConsoleImpl implements SneathConsole {
  bool _isRawMode = false;
  final SneathTerminal terminal;
  final _ScrollbackBuffer? _scrollbackBuffer;

  SneathConsoleImpl({
    required final this.terminal,
  }) : _scrollbackBuffer = null;

  @override
  late final SneathConsoleDimensions dimensions = SneathConsoleDimensionsCachedImpl(
    terminal,
    cursorPosition,
  );

  @override
  late final SneathCursorPositionDelegate cursorPosition = SneathCursorPositionDelegateImpl(
    terminal,
    (final newRawMode) => rawMode = newRawMode,
  );

  /// Create a named constructor specifically for scrolling consoles
  /// Use `Console.scrolling(recordBlanks: false)` to omit blank lines
  /// from console history
  SneathConsoleImpl.scrolling(
    final this.terminal, {
    final bool recordBlanks = true,
  }) : _scrollbackBuffer = _ScrollbackBufferImpl(
          recordBlanks: recordBlanks,
        );

  @override
  set rawMode(
    final bool value,
  ) {
    _isRawMode = value;
    if (value) {
      terminal.enableRawMode();
    } else {
      terminal.disableRawMode();
    }
  }

  @override
  bool get rawMode => _isRawMode;

  @override
  void clearScreen() => terminal.clearScreen();

  @override
  void eraseLine() => stdout.write(controlSequenceIdentifier + '2K');

  @override
  void eraseCursorToEnd() => stdout.write(controlSequenceIdentifier + 'K');

  @override
  void hideCursor() => stdout.write(controlSequenceIdentifier + "?25l");

  @override
  void showCursor() => stdout.write(controlSequenceIdentifier + "?25h");

  @override
  void cursorLeft() => stdout.write(controlSequenceIdentifier + 'D');

  @override
  void cursorRight() => stdout.write(controlSequenceIdentifier + 'C');

  @override
  void cursorUp() => stdout.write(controlSequenceIdentifier + 'A');

  @override
  void cursorDown() => stdout.write(controlSequenceIdentifier + 'B');

  @override
  void resetCursorPosition() => stdout.write(
        controlSequenceIdentifier + "1;1H",
      );

  @override
  void setForegroundColor(
    final AnsiForegroundColor foreground,
  ) =>
      stdout.write(
        ansiSetTextColor(foreground),
      );

  @override
  void setBackgroundColor(
    final AnsiBackgroundColor background,
  ) =>
      stdout.write(
        ansiSetBackgroundColor(background),
      );

  @override
  void setForegroundExtendedColor(
    final AnsiExtendedColorPalette color,
  ) {
    stdout.write(
      ansiSetExtendedForegroundColor(
        color,
      ),
    );
  }

  @override
  void setBackgroundExtendedColor(
    final AnsiExtendedColorPalette color,
  ) {
    stdout.write(
      ansiSetExtendedBackgroundColor(
        color,
      ),
    );
  }

  @override
  void setTextStyle({
    final bool bold = false,
    final bool underscore = false,
    final bool blink = false,
    final bool inverted = false,
  }) =>
      stdout.write(
        ansiSetTextStyles(
          bold: bold,
          underscore: underscore,
          blink: blink,
          inverted: inverted,
        ),
      );

  @override
  void resetColorAttributes() => stdout.write(
        controlSequenceIdentifier + 'm',
      );

  @override
  void write(
    final String text,
  ) =>
      stdout.write(text);

  @override
  String get newLine {
    if (_isRawMode) {
      return '\r\n';
    } else {
      return '\n';
    }
  }

  @override
  void writeErrorLine(
    final String text,
  ) {
    stderr.write(text);
    // Even if we're in raw mode, we write '\n', since raw mode only applies
    // to stdout
    stderr.write('\n');
  }

  @override
  void writeLine([
    final String? text,
    final ConsoleTextAlignment alignment = ConsoleTextAlignments.left,
  ]) {
    if (text != null) {
      stdout.write(alignment.align(text, dimensions.width));
    }
    stdout.write(newLine);
  }

  @override
  Key readKey() {
    rawMode = true;
    final key = parseKey(
      buffer: const AnsiParserInputBufferStdinImpl(),
      delegate: const KeyDelegateKeyBindingsImpl(),
    );
    rawMode = false;
    return key;
  }

  @override
  String? readLine({
    final bool cancelOnBreak = false,
    final bool cancelOnEscape = false,
    final bool cancelOnEOF = false,
    final void Function(String text, Key lastPressed)? callback,
  }) {
    var buffer = '';
    var index = 0; // cursor position relative to buffer, not screen
    final _currentCursorPosition = cursorPosition.get();
    final screenRow = _currentCursorPosition!.row;
    final screenColOffset = _currentCursorPosition.col;
    final bufferMaxLength = dimensions.width - screenColOffset - 3;
    for (;;) {
      final key = readKey();
      key.match(
        printable: (key) {
          if (buffer.length < bufferMaxLength) {
            if (index == buffer.length) {
              buffer += key.char;
              index++;
            } else {
              buffer = buffer.substring(0, index) + key.char + buffer.substring(index);
              index++;
            }
          }
        },
        control: (key) {
          switch (key.controlChar) {
            case ControlCharacters.enter:
              if (_scrollbackBuffer != null) {
                _scrollbackBuffer!.add(buffer);
              }
              writeLine();
              return buffer;
            case ControlCharacters.ctrlC:
              if (cancelOnBreak) {
                return null;
              }
              break;
            case ControlCharacters.escape:
              if (cancelOnEscape) {
                return null;
              }
              break;
            case ControlCharacters.backspace:
            case ControlCharacters.ctrlH:
              if (index > 0) {
                buffer = buffer.substring(0, index - 1) + buffer.substring(index);
                index--;
              }
              break;
            case ControlCharacters.ctrlU:
              buffer = buffer.substring(index, buffer.length);
              index = 0;
              break;
            case ControlCharacters.delete:
            case ControlCharacters.ctrlD:
              if (index < buffer.length - 1) {
                buffer = buffer.substring(0, index) + buffer.substring(index + 1);
              } else if (cancelOnEOF) {
                return null;
              }
              break;
            case ControlCharacters.ctrlK:
              buffer = buffer.substring(0, index);
              break;
            case ControlCharacters.arrowLeft:
            case ControlCharacters.ctrlB:
              index = () {
                if (index > 0) {
                  return index - 1;
                } else {
                  return index;
                }
              }();
              break;
            case ControlCharacters.arrowUp:
              if (_scrollbackBuffer != null) {
                buffer = _scrollbackBuffer!.up(buffer);
                index = buffer.length;
              }
              break;
            case ControlCharacters.arrowDown:
              if (_scrollbackBuffer != null) {
                final temp = _scrollbackBuffer!.down();
                if (temp != null) {
                  buffer = temp;
                  index = buffer.length;
                }
              }
              break;
            case ControlCharacters.arrowRight:
            case ControlCharacters.ctrlF:
              index = () {
                if (index < buffer.length) {
                  return index + 1;
                } else {
                  return index;
                }
              }();
              break;
            case ControlCharacters.wordLeft:
              if (index > 0) {
                final bufferLeftOfCursor = buffer.substring(0, index - 1);
                final lastSpace = bufferLeftOfCursor.lastIndexOf(' ');
                index = () {
                  if (lastSpace != -1) {
                    return lastSpace + 1;
                  } else {
                    return 0;
                  }
                }();
              }
              break;
            case ControlCharacters.wordRight:
              if (index < buffer.length) {
                final bufferRightOfCursor = buffer.substring(index + 1);
                final nextSpace = bufferRightOfCursor.indexOf(' ');
                if (nextSpace != -1) {
                  index = min(index + nextSpace + 2, buffer.length);
                } else {
                  index = buffer.length;
                }
              }
              break;
            case ControlCharacters.home:
            case ControlCharacters.ctrlA:
              index = 0;
              break;
            case ControlCharacters.end:
            case ControlCharacters.ctrlE:
              index = buffer.length;
              break;
            case ControlCharacters.ctrlG:
            case ControlCharacters.tab:
            case ControlCharacters.ctrlJ:
            case ControlCharacters.ctrlL:
            case ControlCharacters.ctrlN:
            case ControlCharacters.ctrlO:
            case ControlCharacters.ctrlP:
            case ControlCharacters.ctrlQ:
            case ControlCharacters.ctrlR:
            case ControlCharacters.ctrlS:
            case ControlCharacters.ctrlT:
            case ControlCharacters.ctrlV:
            case ControlCharacters.ctrlW:
            case ControlCharacters.ctrlX:
            case ControlCharacters.ctrlY:
            case ControlCharacters.ctrlZ:
            case ControlCharacters.pageUp:
            case ControlCharacters.pageDown:
            case ControlCharacters.wordBackspace:
            case ControlCharacters.F1:
            case ControlCharacters.F2:
            case ControlCharacters.F3:
            case ControlCharacters.F4:
            case ControlCharacters.unknown:
              // Do nothing.
              break;
          }
        },
      );
      cursorPosition.update(
        SneathCoordinateImpl(
          row: screenRow,
          col: screenColOffset,
        ),
      );
      eraseCursorToEnd();
      write(buffer); // allow for backspace condition
      cursorPosition.update(
        SneathCoordinateImpl(
          row: screenRow,
          col: screenColOffset + index,
        ),
      );
      if (callback != null) {
        callback(buffer, key);
      }
    }
  }

  @override
  void writeLineCentered(String? text) => writeLine(text, ConsoleTextAlignments.center);

  @override
  void writeLines(
    Iterable<String> lines,
    ConsoleTextAlignment alignment,
  ) {
    for (final line in lines) {
      writeLine(line, alignment);
    }
  }

  @override
  void writeLinesCentered(
    final Iterable<String> lines,
  ) =>
      lines.forEach(writeLineCentered);
}

class AnsiParserInputBufferStdinImpl implements AnsiParserInputBuffer {
  const AnsiParserInputBufferStdinImpl();

  @override
  int readByte() => stdin.readByteSync();
}

/// The ScrollbackBuffer class is a utility for handling multi-line user
/// input in readline(). It doesn't support history editing a la bash,
/// but it should handle the most common use cases.
abstract class _ScrollbackBuffer {
  /// Add a new line to the scrollback buffer. This would normally happen
  /// when the user finishes typing/editing the line and taps the 'enter'
  /// key.
  void add(
    final String buffer,
  );

  /// Scroll 'up' -- Replace the user-input buffer with the contents of the
  /// previous line. ScrollbackBuffer tracks which lines are the 'current'
  /// and 'previous' lines. The up() method stores the current line buffer
  /// so that the contents will not be lost in the event the user starts
  /// typing/editing the line and then wants to review a previous line.
  String up(
    final String buffer,
  );

  /// Scroll 'down' -- Replace the user-input buffer with the contents of
  /// the next line. The final 'next line' is the original contents of the
  /// line buffer.
  String? down();
}

class _ScrollbackBufferImpl implements _ScrollbackBuffer {
  final List<String> lineList = [];
  final bool recordBlanks;
  int? lineIndex;
  String? currentLineBuffer;

  _ScrollbackBufferImpl({
    required final this.recordBlanks,
  });

  @override
  void add(
    final String buffer,
  ) {
    if (recordBlanks) {
      _add(buffer);
    } else {
      if (buffer.isEmpty) {
        // Don't add blank line to scrollback history if !recordBlanks.
      } else {
        _add(buffer);
      }
    }
  }

  void _add(
    final String buffer,
  ) {
    lineList.add(buffer);
    lineIndex = lineList.length;
    currentLineBuffer = null;
  }

  @override
  String up(
    final String buffer,
  ) {
    final _lineIndex = lineIndex;
    // Handle the case of the user tapping 'up' before there is a
    // scrollback buffer to scroll through.
    if (_lineIndex == null) {
      return buffer;
    } else {
      // Only store the current line buffer once while scrolling up
      currentLineBuffer ??= buffer;
      // Decrease the line index by one and lower-clamp it to the first line list item.
      if (_lineIndex == 0) {
        lineIndex = 0;
      } else {
        lineIndex = _lineIndex - 1;
      }
      return lineList[_lineIndex];
    }
  }

  @override
  String? down() {
    final _lineIndex = lineIndex;
    // Handle the case of the user tapping 'down' before there is a
    // scrollback buffer to scroll through.
    if (_lineIndex == null) {
      return null;
    } else {
      // Increase the line index by one and upper-clamp it to the last lineList item.
      if (_lineIndex == lineList.length) {
        lineIndex = lineList.length;
      } else {
        lineIndex = _lineIndex + 1;
      }
      if (lineIndex == lineList.length) {
        // Once the user scrolls to the bottom, reset the current line
        // buffer so that up() can store it again: The user might have
        // edited it between down() and up().
        final temp = currentLineBuffer;
        currentLineBuffer = null;
        return temp;
      } else {
        return lineList[_lineIndex];
      }
    }
  }
}

class KeyDelegateKeyBindingsImpl implements KeyDelegate<Key, int> {
  const KeyDelegateKeyBindingsImpl();

  @override
  KeyControlImpl nil(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl startOfHeader(final int context) => const KeyControlImpl(ControlCharacters.ctrlA);

  @override
  KeyControlImpl startOfText(final int context) => const KeyControlImpl(ControlCharacters.ctrlB);

  @override
  KeyControlImpl endOfText(final int context) => const KeyControlImpl(ControlCharacters.ctrlC);

  @override
  KeyControlImpl endOfTransmission(final int context) => const KeyControlImpl(ControlCharacters.ctrlD);

  @override
  KeyControlImpl enquiry(final int context) => const KeyControlImpl(ControlCharacters.ctrlE);

  @override
  KeyControlImpl acknowledgment(final int context) => const KeyControlImpl(ControlCharacters.ctrlF);

  @override
  KeyControlImpl bell(final int context) => const KeyControlImpl(ControlCharacters.ctrlG);

  @override
  KeyControlImpl backspace(final int context) => const KeyControlImpl(ControlCharacters.ctrlH);

  @override
  KeyControlImpl horizontalTab(final int context) => const KeyControlImpl(ControlCharacters.tab);

  @override
  KeyControlImpl lineFeed(final int context) => const KeyControlImpl(ControlCharacters.ctrlJ);

  @override
  KeyControlImpl verticalTab(final int context) => const KeyControlImpl(ControlCharacters.ctrlK);

  @override
  KeyControlImpl formFeed(final int context) => const KeyControlImpl(ControlCharacters.ctrlL);

  @override
  KeyControlImpl carriageReturn(final int context) => const KeyControlImpl(ControlCharacters.enter);

  @override
  KeyControlImpl shiftOut(final int context) => const KeyControlImpl(ControlCharacters.ctrlN);

  @override
  KeyControlImpl shiftIn(final int context) => const KeyControlImpl(ControlCharacters.ctrlO);

  @override
  KeyControlImpl dataLinkEscape(final int context) => const KeyControlImpl(ControlCharacters.ctrlP);

  @override
  KeyControlImpl deviceControl1(final int context) => const KeyControlImpl(ControlCharacters.ctrlQ);

  @override
  KeyControlImpl deviceControl2(final int context) => const KeyControlImpl(ControlCharacters.ctrlR);

  @override
  KeyControlImpl deviceControl3(final int context) => const KeyControlImpl(ControlCharacters.ctrlS);

  @override
  KeyControlImpl deviceControl4(final int context) => const KeyControlImpl(ControlCharacters.ctrlT);

  @override
  KeyControlImpl negativeAcknowledgment(final int context) => const KeyControlImpl(ControlCharacters.ctrlU);

  @override
  KeyControlImpl syncIdle(final int context) => const KeyControlImpl(ControlCharacters.ctrlV);

  @override
  KeyControlImpl endOfTransmissionBlock(final int context) => const KeyControlImpl(ControlCharacters.ctrlW);

  @override
  KeyControlImpl cancel(final int context) => const KeyControlImpl(ControlCharacters.ctrlX);

  @override
  KeyControlImpl endOfMedium(final int context) => const KeyControlImpl(ControlCharacters.ctrlY);

  @override
  KeyControlImpl substitute(final int context) => const KeyControlImpl(ControlCharacters.ctrlZ);

  @override
  KeyControlImpl escapeEOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeDelete(final int context) => const KeyControlImpl(ControlCharacters.wordBackspace);

  @override
  KeyControlImpl escapeAnsiBracketEOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracketUp(final int context) => const KeyControlImpl(ControlCharacters.arrowUp);

  @override
  KeyControlImpl escapeAnsiBracketDown(final int context) => const KeyControlImpl(ControlCharacters.arrowDown);

  @override
  KeyControlImpl escapeAnsiBracketForward(final int context) => const KeyControlImpl(ControlCharacters.arrowRight);

  @override
  KeyControlImpl escapeAnsiBracketBackward(final int context) => const KeyControlImpl(ControlCharacters.arrowLeft);

  @override
  KeyControlImpl escapeAnsiBracketHome(final int context) => const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escapeAnsiBracketEnd(final int context) => const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escapeAnsiBracket1EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket1Tilde(final int context) => const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escapeAnsiBracket1Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket3EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket3Tilde(final int context) => const KeyControlImpl(ControlCharacters.delete);

  @override
  KeyControlImpl escapeAnsiBracket3Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket4EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket4Tilde(final int context) => const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escapeAnsiBracket4Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket5EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket5Tilde(final int context) => const KeyControlImpl(ControlCharacters.pageUp);

  @override
  KeyControlImpl escapeAnsiBracket5Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket6EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket6Tilde(final int context) => const KeyControlImpl(ControlCharacters.pageDown);

  @override
  KeyControlImpl escapeAnsiBracket6Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket7EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket7Tilde(final int context) => const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escapeAnsiBracket7Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracket8EOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiBracket8Tilde(final int context) => const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escapeAnsiBracket8Default(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiBracketDefault(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escapeAnsiOEOF(final int context) => const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escapeAnsiOHome(final int context) => const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escapeAnsiOEnd(final int context) => const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escapeAnsiOP(final int context) => const KeyControlImpl(ControlCharacters.F1);

  @override
  KeyControlImpl escapeAnsiOQ(final int context) => const KeyControlImpl(ControlCharacters.F2);

  @override
  KeyControlImpl escapeAnsiOR(final int context) => const KeyControlImpl(ControlCharacters.F3);

  @override
  KeyControlImpl escapeAnsiOS(final int context) => const KeyControlImpl(ControlCharacters.F4);

  @override
  KeyControlImpl escapeAnsiODefault(final int context) => throw Exception("Unexpected O command");

  @override
  KeyControlImpl escapeAnsib(final int context) => const KeyControlImpl(ControlCharacters.wordLeft);

  @override
  KeyControlImpl escapeAnsif(final int context) => const KeyControlImpl(ControlCharacters.wordRight);

  @override
  KeyControlImpl escapeAnsiDefault(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl fileSeparator(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl groupSeparator(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl recordSeparator(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl unitSeparator(final int context) => const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyPrintableImpl space(final int context) => const KeyPrintableImpl(' ');

  @override
  KeyPrintableImpl exclamation(final int context) => const KeyPrintableImpl('!');

  @override
  KeyPrintableImpl doubleQuote(final int context) => const KeyPrintableImpl('"');

  @override
  KeyPrintableImpl hash(final int context) => const KeyPrintableImpl("#");

  @override
  KeyPrintableImpl dollar(final int context) => const KeyPrintableImpl(r"$");

  @override
  KeyPrintableImpl percent(final int context) => const KeyPrintableImpl("%");

  @override
  KeyPrintableImpl ampersand(final int context) => const KeyPrintableImpl("&");

  @override
  KeyPrintableImpl singleQuote(final int context) => const KeyPrintableImpl("'");

  @override
  KeyPrintableImpl lparen(final int context) => const KeyPrintableImpl("(");

  @override
  KeyPrintableImpl rparen(final int context) => const KeyPrintableImpl(")");

  @override
  KeyPrintableImpl asterisk(final int context) => const KeyPrintableImpl("*");

  @override
  KeyPrintableImpl plus(final int context) => const KeyPrintableImpl("+");

  @override
  KeyPrintableImpl comma(final int context) => const KeyPrintableImpl(",");

  @override
  KeyPrintableImpl minus(final int context) => const KeyPrintableImpl("-");

  @override
  KeyPrintableImpl dot(final int context) => const KeyPrintableImpl(".");

  @override
  KeyPrintableImpl slash(final int context) => const KeyPrintableImpl("/");

  @override
  KeyPrintableImpl zero(final int context) => const KeyPrintableImpl("0");

  @override
  KeyPrintableImpl one(final int context) => const KeyPrintableImpl("1");

  @override
  KeyPrintableImpl two(final int context) => const KeyPrintableImpl("2");

  @override
  KeyPrintableImpl three(final int context) => const KeyPrintableImpl("3");

  @override
  KeyPrintableImpl four(final int context) => const KeyPrintableImpl("4");

  @override
  KeyPrintableImpl five(final int context) => const KeyPrintableImpl("5");

  @override
  KeyPrintableImpl six(final int context) => const KeyPrintableImpl("6");

  @override
  KeyPrintableImpl seven(final int context) => const KeyPrintableImpl("7");

  @override
  KeyPrintableImpl eight(final int context) => const KeyPrintableImpl("8");

  @override
  KeyPrintableImpl nine(final int context) => const KeyPrintableImpl("9");

  @override
  KeyPrintableImpl colon(final int context) => const KeyPrintableImpl(":");

  @override
  KeyPrintableImpl semicolon(final int context) => const KeyPrintableImpl(";");

  @override
  KeyPrintableImpl lt(final int context) => const KeyPrintableImpl("<");

  @override
  KeyPrintableImpl equal(final int context) => const KeyPrintableImpl("=");

  @override
  KeyPrintableImpl gt(final int context) => const KeyPrintableImpl(">");

  @override
  KeyPrintableImpl question(final int context) => const KeyPrintableImpl("?");

  @override
  KeyPrintableImpl at(final int context) => const KeyPrintableImpl("@");

  @override
  KeyPrintableImpl capA(final int context) => const KeyPrintableImpl("A");

  @override
  KeyPrintableImpl capB(final int context) => const KeyPrintableImpl("B");

  @override
  KeyPrintableImpl capC(final int context) => const KeyPrintableImpl("C");

  @override
  KeyPrintableImpl capD(final int context) => const KeyPrintableImpl("D");

  @override
  KeyPrintableImpl capE(final int context) => const KeyPrintableImpl("E");

  @override
  KeyPrintableImpl capF(final int context) => const KeyPrintableImpl("F");

  @override
  KeyPrintableImpl capG(final int context) => const KeyPrintableImpl("G");

  @override
  KeyPrintableImpl capH(final int context) => const KeyPrintableImpl("H");

  @override
  KeyPrintableImpl capI(final int context) => const KeyPrintableImpl("I");

  @override
  KeyPrintableImpl capJ(final int context) => const KeyPrintableImpl("J");

  @override
  KeyPrintableImpl capK(final int context) => const KeyPrintableImpl("K");

  @override
  KeyPrintableImpl capL(final int context) => const KeyPrintableImpl("L");

  @override
  KeyPrintableImpl capM(final int context) => const KeyPrintableImpl("M");

  @override
  KeyPrintableImpl capN(final int context) => const KeyPrintableImpl("N");

  @override
  KeyPrintableImpl capO(final int context) => const KeyPrintableImpl("O");

  @override
  KeyPrintableImpl capP(final int context) => const KeyPrintableImpl("P");

  @override
  KeyPrintableImpl capQ(final int context) => const KeyPrintableImpl("Q");

  @override
  KeyPrintableImpl capR(final int context) => const KeyPrintableImpl("R");

  @override
  KeyPrintableImpl capS(final int context) => const KeyPrintableImpl("S");

  @override
  KeyPrintableImpl capT(final int context) => const KeyPrintableImpl("T");

  @override
  KeyPrintableImpl capU(final int context) => const KeyPrintableImpl("U");

  @override
  KeyPrintableImpl capV(final int context) => const KeyPrintableImpl("V");

  @override
  KeyPrintableImpl capW(final int context) => const KeyPrintableImpl("W");

  @override
  KeyPrintableImpl capX(final int context) => const KeyPrintableImpl("X");

  @override
  KeyPrintableImpl capY(final int context) => const KeyPrintableImpl("Y");

  @override
  KeyPrintableImpl capZ(final int context) => const KeyPrintableImpl("Z");

  @override
  KeyPrintableImpl lBra(final int context) => const KeyPrintableImpl("[");

  @override
  KeyPrintableImpl backslash(final int context) => const KeyPrintableImpl(r"\");

  @override
  KeyPrintableImpl rBra(final int context) => const KeyPrintableImpl("]");

  @override
  KeyPrintableImpl caret(final int context) => const KeyPrintableImpl("^");

  @override
  KeyPrintableImpl underscore(final int context) => const KeyPrintableImpl("_");

  @override
  KeyPrintableImpl backquote(final int context) => const KeyPrintableImpl("`");

  @override
  KeyPrintableImpl lowerA(final int context) => const KeyPrintableImpl("a");

  @override
  KeyPrintableImpl lowerB(final int context) => const KeyPrintableImpl("b");

  @override
  KeyPrintableImpl lowerC(final int context) => const KeyPrintableImpl("c");

  @override
  KeyPrintableImpl lowerD(final int context) => const KeyPrintableImpl("d");

  @override
  KeyPrintableImpl lowerE(final int context) => const KeyPrintableImpl("e");

  @override
  KeyPrintableImpl lowerF(final int context) => const KeyPrintableImpl("f");

  @override
  KeyPrintableImpl lowerG(final int context) => const KeyPrintableImpl("g");

  @override
  KeyPrintableImpl lowerH(final int context) => const KeyPrintableImpl("h");

  @override
  KeyPrintableImpl lowerI(final int context) => const KeyPrintableImpl("i");

  @override
  KeyPrintableImpl lowerJ(final int context) => const KeyPrintableImpl("j");

  @override
  KeyPrintableImpl lowerK(final int context) => const KeyPrintableImpl("k");

  @override
  KeyPrintableImpl lowerL(final int context) => const KeyPrintableImpl("l");

  @override
  KeyPrintableImpl lowerM(final int context) => const KeyPrintableImpl("m");

  @override
  KeyPrintableImpl lowerN(final int context) => const KeyPrintableImpl("n");

  @override
  KeyPrintableImpl lowerO(final int context) => const KeyPrintableImpl("o");

  @override
  KeyPrintableImpl lowerP(final int context) => const KeyPrintableImpl("p");

  @override
  KeyPrintableImpl lowerQ(final int context) => const KeyPrintableImpl("q");

  @override
  KeyPrintableImpl lowerR(final int context) => const KeyPrintableImpl("r");

  @override
  KeyPrintableImpl lowerS(final int context) => const KeyPrintableImpl("s");

  @override
  KeyPrintableImpl lowerT(final int context) => const KeyPrintableImpl("t");

  @override
  KeyPrintableImpl lowerU(final int context) => const KeyPrintableImpl("u");

  @override
  KeyPrintableImpl lowerV(final int context) => const KeyPrintableImpl("v");

  @override
  KeyPrintableImpl lowerW(final int context) => const KeyPrintableImpl("w");

  @override
  KeyPrintableImpl lowerX(final int context) => const KeyPrintableImpl("x");

  @override
  KeyPrintableImpl lowerY(final int context) => const KeyPrintableImpl("y");

  @override
  KeyPrintableImpl lowerZ(final int context) => const KeyPrintableImpl("z");

  @override
  KeyPrintableImpl lBrace(final int context) => const KeyPrintableImpl("{");

  @override
  KeyPrintableImpl bar(final int context) => const KeyPrintableImpl("|");

  @override
  KeyPrintableImpl rBrace(final int context) => const KeyPrintableImpl("}");

  @override
  KeyPrintableImpl tilde(final int context) => const KeyPrintableImpl("~");

  @override
  KeyControlImpl del(final int context) => const KeyControlImpl(ControlCharacters.backspace);

  @override
  KeyPrintableImpl extended(final int context) => KeyPrintableImpl(String.fromCharCode(context));
}
