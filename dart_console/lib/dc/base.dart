import 'dart:io';

import 'package:dart_ansi/ansi.dart';

/// The root of the console API
class DCConsole {
  static bool _cursorCTRLC = false;
  static bool _buffCTRLC = false;
  final DCConsoleAdapter rawConsole;

  const DCConsole(this.rawConsole);

  static Stream<dynamic> get onResize => ProcessSignal.sigwinch.watch();

  /// Moves the Cursor Back the specified amount of [times].
  void moveCursorBack([
    final int times = 1,
  ]) =>
      writeANSI(
        '${times}D',
      );

  /// Erases the Display
  void eraseDisplay([
    final int type = 0,
  ]) =>
      writeANSI(
        '${type}J',
      );

  /// Erases the Line
  void eraseLine([
    final int type = 0,
  ]) =>
      writeANSI(
        '${type}K',
      );

  /// Moves the the column specified in [number].
  void moveToColumn(
    final int number,
  ) =>
      writeANSI(
        '${number}G',
      );

  /// Overwrites the current line with [line].
  void overwriteLine(
    final String line,
  ) {
    rawConsole.write('\r');
    eraseLine(2);
    rawConsole.write(line);
  }

  /// Sets the Current Text Color.
  void setTextColor(
    final int id, {
    final bool xterm = false,
    final bool bright = false,
  }) {
    if (xterm) {
      sgr(
        38,
        [5, (id.clamp(0, 256))],
      );
    } else {
      if (bright) {
        sgr(
          30 + id,
          [1],
        );
      } else {
        sgr(
          30 + id,
        );
      }
    }
  }

  void hideCursor() {
    if (!_cursorCTRLC) {
      ProcessSignal.sigint.watch().listen(
        (final signal) {
          showCursor();
          exit(0);
        },
      );
      _cursorCTRLC = true;
    }
    writeANSI('?25l');
  }

  void showCursor() {
    writeANSI('?25h');
  }

  void altBuffer() {
    if (!_buffCTRLC) {
      ProcessSignal.sigint.watch().listen(
        (final signal) {
          normBuffer();
          exit(0);
        },
      );
      _buffCTRLC = true;
    }
    writeANSI('?47h');
  }

  void normBuffer() {
    writeANSI('?47l');
  }

  void setBackgroundColor(
    final int id, {
    final bool xterm = false,
    final bool bright = false,
  }) {
    if (xterm) {
      sgr(
        48,
        [5, (id.clamp(0, 256))],
      );
    } else {
      if (bright) {
        sgr(
          40 + id,
          [1],
        );
      } else {
        sgr(
          40 + id,
        );
      }
    }
  }

  void centerCursor({
    final bool row = true,
  }) {
    if (row) {
      final column = (columns / 2).round();
      final row = (rows / 2).round();
      moveCursor(row: row, column: column);
    } else {
      moveToColumn((columns / 2).round());
    }
  }

  void moveCursor({
    final int? row,
    final int? column,
  }) {
    var out = '';
    if (row != null) {
      out += row.toString();
    }
    out += ';';
    if (column != null) {
      out += column.toString();
    }
    writeANSI('${out}H');
  }

  void resetAll() => sgr(0);

  void resetBackgroundColor() => sgr(49);

  void sgr(
    final int id, [
    final List<int>? params,
  ]) {
    String stuff;
    if (params != null) {
      stuff = "$id;${params.join(";")}";
    } else {
      stuff = id.toString();
    }
    writeANSI('${stuff}m');
  }

  int get rows => rawConsole.rows;

  int get columns => rawConsole.columns;

  void writeANSI(
    final String after,
  ) =>
      rawConsole.write(controlSequenceIdentifier + after);

  DCCursorPosition getCursorPosition() {
    final lm = rawConsole.lineMode;
    final em = rawConsole.echoMode;
    rawConsole.lineMode = false;
    rawConsole.echoMode = false;
    writeANSI('6n');
    final bytes = <int>[];
    for (;;) {
      final byte = rawConsole.readByte();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }
    rawConsole.lineMode = lm;
    rawConsole.echoMode = em;
    var str = String.fromCharCodes(bytes);
    str = str.substring(
      str.lastIndexOf(ansiBracket) + 1,
      str.length - 1,
    );
    final parts = List<int>.from(
      str.split(';').map<int>(
            (final it) => int.parse(it),
          ),
    ).toList();
    return DCCursorPosition(
      parts[1],
      parts[0],
    );
  }
}

class DCCursorPosition {
  final int row;
  final int column;

  const DCCursorPosition(
    final this.column,
    final this.row,
  );

  @override
  String toString() => '($column, $row)';
}

class DCColor {
  final int id;
  final bool xterm;
  final bool bright;

  const DCColor(
    final this.id, {
    final this.xterm = false,
    final this.bright = false,
  });

  @override
  String toString({
    final bool background = false,
  }) {
    // TODO Whats the difference when it comes to xterm and the other case
    if (xterm) {
      return '${controlSequenceIdentifier}${() {
        if (background) {
          return 38;
        } else {
          return 48;
        }
      }()};5;${id}m';
    } else {
      if (bright) {
        return '${controlSequenceIdentifier}1;${(() {
              if (background) {
                return 40;
              } else {
                return 30;
              }
            }()) + id}m';
      } else {
        return '${controlSequenceIdentifier}0;${(() {
              if (background) {
                return 40;
              } else {
                return 30;
              }
            }()) + id}m';
      }
    }
  }
}

abstract class DCConsoleAdapter {
  int get rows;

  int get columns;

  void write(
    final String? data,
  );

  void writeln(
    final String? data,
  );

  String? read();

  int readByte();

  Stream<List<int>> byteStream();

  abstract bool echoMode;

  abstract bool lineMode;
}

class DCStdioConsoleAdapter implements DCConsoleAdapter {
  DCStdioConsoleAdapter();

  @override
  int get columns => stdout.terminalColumns;

  @override
  int get rows => stdout.terminalLines;

  @override
  String? read() => stdin.readLineSync();

  @override
  Stream<List<int>> byteStream() => stdin;

  @override
  void write(
    final String? data,
  ) =>
      stdout.write(data);

  @override
  void writeln(
    final String? data,
  ) =>
      stdout.writeln(data);

  @override
  set echoMode(
    final bool value,
  ) =>
      stdin.echoMode = value;

  @override
  bool get echoMode => stdin.echoMode;

  @override
  set lineMode(
    final bool value,
  ) =>
      stdin.lineMode = value;

  @override
  bool get lineMode => stdin.lineMode;

  @override
  int readByte() => stdin.readByteSync();
}
