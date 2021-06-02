import 'dart:io';
import 'dart:math';

import '../../ansi/impl/ansi.dart';
import '../../ansi/interface/color.dart';
import '../../terminal/interface/terminal_lib.dart';
import '../interface/console.dart';
import '../interface/control_character.dart';
import '../interface/coordinate.dart';
import '../interface/key.dart';
import '../interface/text_alignment.dart';
import 'coordinate.dart';
import 'key.dart';
import 'text_alignment.dart';

class SneathConsoleImpl implements SneathConsole {
  // We cache these values so we don't have to keep retrieving them. The
  // downside is that the class isn't dynamically responsive to a resized
  // console, but that's not unusual for console applications anyway.
  int _windowWidth = 0;
  int _windowHeight = 0;
  bool _isRawMode = false;
  final SneathTerminal _terminal;
  final _ScrollbackBuffer? _scrollbackBuffer;

  SneathConsoleImpl(this._terminal) : _scrollbackBuffer = null;

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
  void eraseLine() => stdout.write(AnsiConstants.ansiEraseInLineAll);

  @override
  void eraseCursorToEnd() => stdout.write(AnsiConstants.ansiEraseCursorToEnd);

  @override
  int get windowWidth {
    if (_windowWidth == 0) {
      // try using ioctl() to give us the screen size
      final width = _terminal.getWindowWidth();
      if (width != -1) {
        _windowWidth = width;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition;
        stdout.write(AnsiConstants.ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition;
        cursorPosition = originalCursor;
        if (newCursor != null) {
          _windowWidth = newCursor.col;
        } else {
          // we've run out of options; terminal is unsupported
          throw const SneathConsoleExceptionImpl("Couldn't retrieve window width");
        }
      }
    }
    return _windowWidth;
  }

  @override
  int get windowHeight {
    if (_windowHeight == 0) {
      // try using ioctl() to give us the screen size
      final height = _terminal.getWindowHeight();
      if (height != -1) {
        _windowHeight = height;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition;
        stdout.write(AnsiConstants.ansiMoveCursorToScreenEdge);
        final newCursor = cursorPosition;
        cursorPosition = originalCursor;
        if (newCursor != null) {
          _windowHeight = newCursor.row;
        } else {
          // we've run out of options; terminal is unsupported
          throw const SneathConsoleExceptionImpl("Couldn't retrieve window height");
        }
      }
    }
    return _windowHeight;
  }

  @override
  void hideCursor() => stdout.write(AnsiConstants.ansiHideCursor);

  @override
  void showCursor() => stdout.write(AnsiConstants.ansiShowCursor);

  @override
  void cursorLeft() => stdout.write(AnsiConstants.ansiCursorLeft);

  @override
  void cursorRight() => stdout.write(AnsiConstants.ansiCursorRight);

  @override
  void cursorUp() => stdout.write(AnsiConstants.ansiCursorUp);

  @override
  void cursorDown() => stdout.write(AnsiConstants.ansiCursorDown);

  @override
  void resetCursorPosition() => stdout.write(AnsiLib.ansiCursorPosition(1, 1));

  @override
  Coordinate? get cursorPosition {
    rawMode = true;
    stdout.write(AnsiConstants.ansiDeviceStatusReportCursorPosition);
    // returns a Cursor Position Report result in the form <ESC>[24;80R
    // which we have to parse apart, unfortunately
    var result = '';
    var i = 0;
    // avoid infinite loop if we're getting a bad result
    while (i < 16) {
      // ignore: use_string_buffers
      result += String.fromCharCode(stdin.readByteSync());
      if (result.endsWith('R')) {
        break;
      }
      i++;
    }
    rawMode = false;
    if (result[0] != '\x1b') {
      print(' result: $result  result.length: ${result.length}');
      return null;
    } else {
      result = result.substring(2, result.length - 1);
      final coords = result.split(';');
      if (coords.length != 2) {
        print(' coords.length: ${coords.length}');
        return null;
      } else {
        final parsedX = int.tryParse(coords[0]);
        final parsedY = int.tryParse(coords[1]);
        if ((parsedX != null) && (parsedY != null)) {
          return CoordinateImpl(parsedX - 1, parsedY - 1);
        } else {
          print(' coords[0]: ${coords[0]}   coords[1]: ${coords[1]}');
          return null;
        }
      }
    }
  }

  @override
  set cursorPosition(Coordinate? cursor) {
    if (cursor != null) {
      _terminal.setCursorPosition(cursor.col, cursor.row);
    }
  }

  @override
  void setForegroundColor(NamedAnsiColor foreground) {
    stdout.write(AnsiLib.ansiSetColor(foreground.foregroundColorCode));
  }

  @override
  void setBackgroundColor(NamedAnsiColor background) {
    stdout.write(AnsiLib.ansiSetColor(background.backgroundColorCode));
  }

  @override
  void setForegroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF, 'Color must be a value between 0 and 255.');
    stdout.write(AnsiLib.ansiSetExtendedForegroundColor(colorValue));
  }

  @override
  void setBackgroundExtendedColor(int colorValue) {
    assert(colorValue >= 0 && colorValue <= 0xFF, 'Color must be a value between 0 and 255.');
    stdout.write(AnsiLib.ansiSetExtendedBackgroundColor(colorValue));
  }

  @override
  void setTextStyle({
    bool bold = false,
    bool underscore = false,
    bool blink = false,
    bool inverted = false,
  }) =>
      stdout.write(AnsiLib.ansiSetTextStyles(
        bold: bold,
        underscore: underscore,
        blink: blink,
        inverted: inverted,
      ));

  @override
  void resetColorAttributes() => stdout.write(AnsiConstants.ansiResetColor);

  @override
  void write(String text) => stdout.write(text);

  @override
  String get newLine => _isRawMode ? '\r\n' : '\n';

  @override
  void writeErrorLine(String text) {
    stderr.write(text);
    // Even if we're in raw mode, we write '\n', since raw mode only applies
    // to stdout
    stderr.write('\n');
  }

  /// TODO think about adding write Centered/Left/Right Line extensions?
  @override
  void writeLine([
    String? text,
    ConsoleTextAlignment alignment = ConsoleTextAlignments.left,
  ]) {
    if (text != null) {
      stdout.write(alignment.align(text, windowWidth));
    }
    stdout.write(newLine);
  }

  @override
  Key readKey() {
    var codeUnit = 0;
    rawMode = true;
    while (codeUnit <= 0) {
      codeUnit = stdin.readByteSync();
    }
    if (codeUnit >= 0x01 && codeUnit <= 0x1a) {
      rawMode = false;
      // Ctrl+A through Ctrl+Z are mapped to the 1st-26th entries in the
      // enum, so it's easy to convert them across
      return KeyControlMutableImpl(ControlCharacter.values[codeUnit]);
    } else if (codeUnit == 0x1b) {
      int charCode;
      KeyControlMutableImpl key;
      // escape sequence (e.g. \x1b[A for up arrow)
      key = KeyControlMutableImpl(ControlCharacter.escape);
      final escapeSequence = <String>[];
      charCode = stdin.readByteSync();
      if (charCode == -1) {
        rawMode = false;
        return key;
      } else {
        escapeSequence.add(String.fromCharCode(charCode));
        if (charCode == 127) {
          key = KeyControlMutableImpl(ControlCharacter.wordBackspace);
        } else if (escapeSequence[0] == '[') {
          charCode = stdin.readByteSync();
          // ignore: invariant_booleans
          if (charCode == -1) {
            rawMode = false;
            return key;
          } else {
            escapeSequence.add(String.fromCharCode(charCode));
            switch (escapeSequence[1]) {

              /// TODO put constants into control character once it is an adt.
              case 'A':
                key.controlChar = ControlCharacter.arrowUp;
                break;
              case 'B':
                key.controlChar = ControlCharacter.arrowDown;
                break;
              case 'C':
                key.controlChar = ControlCharacter.arrowRight;
                break;
              case 'D':
                key.controlChar = ControlCharacter.arrowLeft;
                break;
              case 'H':
                key.controlChar = ControlCharacter.home;
                break;
              case 'F':
                key.controlChar = ControlCharacter.end;
                break;
              default:
                if (escapeSequence[1].codeUnits[0] > '0'.codeUnits[0] && escapeSequence[1].codeUnits[0] < '9'.codeUnits[0]) {
                  charCode = stdin.readByteSync();
                  // ignore: invariant_booleans
                  if (charCode == -1) {
                    rawMode = false;
                    return key;
                  } else {
                    escapeSequence.add(String.fromCharCode(charCode));
                    if (escapeSequence[2] != '~') {
                      key.controlChar = ControlCharacter.unknown;
                    } else {
                      switch (escapeSequence[1]) {
                        case '1':
                          key.controlChar = ControlCharacter.home;
                          break;
                        case '3':
                          key.controlChar = ControlCharacter.delete;
                          break;
                        case '4':
                          key.controlChar = ControlCharacter.end;
                          break;
                        case '5':
                          key.controlChar = ControlCharacter.pageUp;
                          break;
                        case '6':
                          key.controlChar = ControlCharacter.pageDown;
                          break;
                        case '7':
                          key.controlChar = ControlCharacter.home;
                          break;
                        case '8':
                          key.controlChar = ControlCharacter.end;
                          break;
                        default:
                          key.controlChar = ControlCharacter.unknown;
                      }
                    }
                  }
                } else {
                  key.controlChar = ControlCharacter.unknown;
                }
            }
          }
        } else if (escapeSequence[0] == 'O') {
          charCode = stdin.readByteSync();
          if (charCode == -1) {
            rawMode = false;
            return key;
          } else {
            escapeSequence.add(String.fromCharCode(charCode));
            // ignore: prefer_asserts_with_message
            assert(escapeSequence.length == 2);
            switch (escapeSequence[1]) {
              case 'H':
                key.controlChar = ControlCharacter.home;
                break;
              case 'F':
                key.controlChar = ControlCharacter.end;
                break;
              case 'P':
                key.controlChar = ControlCharacter.F1;
                break;
              case 'Q':
                key.controlChar = ControlCharacter.F2;
                break;
              case 'R':
                key.controlChar = ControlCharacter.F3;
                break;
              case 'S':
                key.controlChar = ControlCharacter.F4;
                break;
              default:
            }
          }
        } else if (escapeSequence[0] == 'b') {
          key.controlChar = ControlCharacter.wordLeft;
        } else if (escapeSequence[0] == 'f') {
          key.controlChar = ControlCharacter.wordRight;
        } else {
          key.controlChar = ControlCharacter.unknown;
        }
        rawMode = false;
        return key;
      }
    } else if (codeUnit == 0x7f) {
      rawMode = false;
      return KeyControlMutableImpl(ControlCharacter.backspace);
    } else if (codeUnit == 0x00 || (codeUnit >= 0x1c && codeUnit <= 0x1f)) {
      rawMode = false;
      return KeyControlMutableImpl(ControlCharacter.unknown);
    } else {
      // Assume other characters are printable.
      rawMode = false;
      return KeyPrintableImpl(String.fromCharCode(codeUnit));
    }
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
    final screenRow = cursorPosition!.row;
    final screenColOffset = cursorPosition!.col;
    final bufferMaxLength = windowWidth - screenColOffset - 3;
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
            case ControlCharacter.enter:
              if (_scrollbackBuffer != null) {
                _scrollbackBuffer!.add(buffer);
              }
              writeLine();
              return buffer;
            case ControlCharacter.ctrlC:
              if (cancelOnBreak) return null;
              break;
            case ControlCharacter.escape:
              if (cancelOnEscape) return null;
              break;
            case ControlCharacter.backspace:
            case ControlCharacter.ctrlH:
              if (index > 0) {
                buffer = buffer.substring(0, index - 1) + buffer.substring(index);
                index--;
              }
              break;
            case ControlCharacter.ctrlU:
              buffer = buffer.substring(index, buffer.length);
              index = 0;
              break;
            case ControlCharacter.delete:
            case ControlCharacter.ctrlD:
              if (index < buffer.length - 1) {
                buffer = buffer.substring(0, index) + buffer.substring(index + 1);
              } else if (cancelOnEOF) {
                return null;
              }
              break;
            case ControlCharacter.ctrlK:
              buffer = buffer.substring(0, index);
              break;
            case ControlCharacter.arrowLeft:
            case ControlCharacter.ctrlB:
              index = index > 0 ? index - 1 : index;
              break;
            case ControlCharacter.arrowUp:
              if (_scrollbackBuffer != null) {
                buffer = _scrollbackBuffer!.up(buffer);
                index = buffer.length;
              }
              break;
            case ControlCharacter.arrowDown:
              if (_scrollbackBuffer != null) {
                final temp = _scrollbackBuffer!.down();
                if (temp != null) {
                  buffer = temp;
                  index = buffer.length;
                }
              }
              break;
            case ControlCharacter.arrowRight:
            case ControlCharacter.ctrlF:
              index = index < buffer.length ? index + 1 : index;
              break;
            case ControlCharacter.wordLeft:
              if (index > 0) {
                final bufferLeftOfCursor = buffer.substring(0, index - 1);
                final lastSpace = bufferLeftOfCursor.lastIndexOf(' ');
                index = lastSpace != -1 ? lastSpace + 1 : 0;
              }
              break;
            case ControlCharacter.wordRight:
              if (index < buffer.length) {
                final bufferRightOfCursor = buffer.substring(index + 1);
                final nextSpace = bufferRightOfCursor.indexOf(' ');
                index = nextSpace != -1 ? min(index + nextSpace + 2, buffer.length) : buffer.length;
              }
              break;
            case ControlCharacter.home:
            case ControlCharacter.ctrlA:
              index = 0;
              break;
            case ControlCharacter.end:
            case ControlCharacter.ctrlE:
              index = buffer.length;
              break;
            case ControlCharacter.none:
            case ControlCharacter.ctrlG:
            case ControlCharacter.tab:
            case ControlCharacter.ctrlJ:
            case ControlCharacter.ctrlL:
            case ControlCharacter.ctrlN:
            case ControlCharacter.ctrlO:
            case ControlCharacter.ctrlP:
            case ControlCharacter.ctrlQ:
            case ControlCharacter.ctrlR:
            case ControlCharacter.ctrlS:
            case ControlCharacter.ctrlT:
            case ControlCharacter.ctrlV:
            case ControlCharacter.ctrlW:
            case ControlCharacter.ctrlX:
            case ControlCharacter.ctrlY:
            case ControlCharacter.ctrlZ:
            case ControlCharacter.pageUp:
            case ControlCharacter.pageDown:
            case ControlCharacter.wordBackspace:
            case ControlCharacter.F1:
            case ControlCharacter.F2:
            case ControlCharacter.F3:
            case ControlCharacter.F4:
            case ControlCharacter.unknown:
              // Do nothing.
              break;
          }
        },
      );
      cursorPosition = CoordinateImpl(screenRow, screenColOffset);
      eraseCursorToEnd();
      write(buffer); // allow for backspace condition
      cursorPosition = CoordinateImpl(screenRow, screenColOffset + index);
      if (callback != null) callback(buffer, key);
    }
  }

  @override
  void writeLineCentered(String? text) => writeLine(text, ConsoleTextAlignments.center);

  @override
  void writeLines(Iterable<String> lines, ConsoleTextAlignment alignment) {
    for (final line in lines) {
      writeLine(line, alignment);
    }
  }

  @override
  void writeLinesCentered(Iterable<String> lines) => lines.forEach(writeLineCentered);
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

class SneathConsoleExceptionImpl implements Exception {
  final String message;

  const SneathConsoleExceptionImpl(this.message);

  @override
  String toString() => 'SneathConsoleExceptionImpl{message: $message}';
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
