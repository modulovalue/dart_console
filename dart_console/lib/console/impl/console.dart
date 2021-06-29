import 'dart:io';
import 'dart:math';

import 'package:dart_ansi/ansi.dart';

import '../../parser.dart';
import '../../terminal/interface/terminal_lib.dart';
import '../alignment.dart';
import '../interface/console.dart';
import '../interface/control_character.dart';
import '../interface/cursor_position.dart';
import '../interface/dimensions.dart';
import '../interface/key.dart';
import 'coordinate.dart';
import 'cursor_position.dart';
import 'dimensions/constant.dart';

/// TODO have a mixin and separate impls. for scrolling and non scrolling.
class SneathConsoleImpl implements SneathConsole {
  bool _isRawMode = false;
  final SneathTerminal _terminal;
  final _ScrollbackBuffer? _scrollbackBuffer;

  SneathConsoleImpl(this._terminal) : _scrollbackBuffer = null;

  @override
  late final SneathConsoleDimensions dimensions = SneathConsoleDimensionsCachedImpl(
    _terminal,
    cursorPosition,
  );

  @override
  late final SneathCursorPositionDelegate cursorPosition = SneathCursorPositionDelegateImpl(
    _terminal,
    (newRawMode) => rawMode = newRawMode,
  );

  /// Create a named constructor specifically for scrolling consoles
  /// Use `Console.scrolling(recordBlanks: false)` to omit blank lines
  /// from console history
  SneathConsoleImpl.scrolling(
    this._terminal, {
    bool recordBlanks = true,
  }) : _scrollbackBuffer = _ScrollbackBufferImpl(recordBlanks: recordBlanks);

  @override
  set rawMode(bool value) {
    _isRawMode = value;
    if (value) {
      _terminal.enableRawMode();
    } else {
      _terminal.disableRawMode();
    }
  }

  @override
  bool get rawMode => _isRawMode;

  @override
  void clearScreen() => _terminal.clearScreen();

  @override
  void eraseLine() => stdout.write(ansiEraseInLineAll);

  @override
  void eraseCursorToEnd() => stdout.write(ansiEraseCursorToEnd);

  @override
  void hideCursor() => stdout.write(ansiHideCursor);

  @override
  void showCursor() => stdout.write(ansiShowCursor);

  @override
  void cursorLeft() => stdout.write(ansiCursorLeft);

  @override
  void cursorRight() => stdout.write(ansiCursorRight);

  @override
  void cursorUp() => stdout.write(ansiCursorUp);

  @override
  void cursorDown() => stdout.write(ansiCursorDown);

  @override
  void resetCursorPosition() => //
      stdout.write(ansiCursorPositionTo(1, 1));

  @override
  void setForegroundColor(NamedAnsiColor foreground) => //
      stdout.write(ansiSetTextColor(foreground));

  @override
  void setBackgroundColor(NamedAnsiColor background) => //
      stdout.write(ansiSetBackgroundColor(background));

  @override
  void setForegroundExtendedColor(AnsiExtendedColorPalette color) {
    stdout.write(
      ansiSetExtendedForegroundColor(
        color,
      ),
    );
  }

  @override
  void setBackgroundExtendedColor(AnsiExtendedColorPalette color) {
    stdout.write(
      ansiSetExtendedBackgroundColor(
        color,
      ),
    );
  }

  @override
  void setTextStyle({
    bool bold = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
  }) =>
      stdout.write(ansiSetTextStyles(
        bold: bold,
        underscore: underscore,
        blink: blink,
        inverted: inverted,
      ));

  @override
  void resetColorAttributes() => stdout.write(ansiResetColor);

  @override
  void write(String text) => stdout.write(text);

  /// TODO extract constants.
  @override
  String get newLine => _isRawMode ? '\r\n' : '\n';

  @override
  void writeErrorLine(String text) {
    stderr.write(text);
    // Even if we're in raw mode, we write '\n', since raw mode only applies
    // to stdout
    /// TODO extract constants.
    stderr.write('\n');
  }

  @override
  void writeLine([
    String? text,
    ConsoleTextAlignment alignment = ConsoleTextAlignments.left,
  ]) {
    if (text != null) {
      stdout.write(alignment.align(text, dimensions.width));
    }
    stdout.write(newLine);
  }

  @override
  Key readKey() {
    rawMode = true;
    final key = parseKey(const AnsiParserInputBufferStdinImpl());
    rawMode = false;
    return key;
  }

  @override
  String? readLine({
    bool cancelOnBreak = false,
    bool cancelOnEscape = false,
    bool cancelOnEOF = false,
    void Function(String text, Key lastPressed)? callback,
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
              if (cancelOnBreak) return null;
              break;
            case ControlCharacters.escape:
              if (cancelOnEscape) return null;
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
              index = index > 0 ? index - 1 : index;
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
              index = index < buffer.length ? index + 1 : index;
              break;
            case ControlCharacters.wordLeft:
              if (index > 0) {
                final bufferLeftOfCursor = buffer.substring(0, index - 1);
                final lastSpace = bufferLeftOfCursor.lastIndexOf(' ');
                index = lastSpace != -1 ? lastSpace + 1 : 0;
              }
              break;
            case ControlCharacters.wordRight:
              if (index < buffer.length) {
                final bufferRightOfCursor = buffer.substring(index + 1);
                final nextSpace = bufferRightOfCursor.indexOf(' ');
                index = nextSpace != -1 ? min(index + nextSpace + 2, buffer.length) : buffer.length;
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
      cursorPosition.update(SneathCoordinateImpl(screenRow, screenColOffset));
      eraseCursorToEnd();
      write(buffer); // allow for backspace condition
      cursorPosition.update(SneathCoordinateImpl(screenRow, screenColOffset + index));
      if (callback != null) callback(buffer, key);
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
  void writeLinesCentered(Iterable<String> lines) => lines.forEach(writeLineCentered);
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
  void add(String buffer);

  /// Scroll 'up' -- Replace the user-input buffer with the contents of the
  /// previous line. ScrollbackBuffer tracks which lines are the 'current'
  /// and 'previous' lines. The up() method stores the current line buffer
  /// so that the contents will not be lost in the event the user starts
  /// typing/editing the line and then wants to review a previous line.
  String up(String buffer);

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

  _ScrollbackBufferImpl({required this.recordBlanks});

  @override
  void add(String buffer) {
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

  void _add(String buffer) {
    lineList.add(buffer);
    lineIndex = lineList.length;
    currentLineBuffer = null;
  }

  @override
  String up(String buffer) {
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
