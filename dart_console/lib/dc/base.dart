import 'dart:io';

import '../ansi_writer/ansi_writer.dart';

/// The root of the console API
class DCConsole {
  static bool _cursor_ctrl_c = false;
  static bool _buff_ctlr_c = false;
  final DCConsoleAdapter raw_console;

  const DCConsole({
    required final this.raw_console,
  });

  static Stream<dynamic> get on_resize => ProcessSignal.sigwinch.watch();

  /// Moves the Cursor Back the specified amount of [times].
  void move_cursor_back([
    final int times = 1,
  ]) {
    write_ansi(
      '${times}D',
    );
  }

  /// Erases the Display
  void erase_display([
    final int type = 0,
  ]) {
    write_ansi(
      '${type}J',
    );
  }

  /// Erases the Line
  void erase_line([
    final int type = 0,
  ]) {
    write_ansi(
      '${type}K',
    );
  }

  /// Moves the the column specified in [number].
  void move_to_column(
    final int number,
  ) {
    write_ansi(
      '${number}G',
    );
  }

  /// Overwrites the current line with [line].
  void overwrite_line(
    final String line,
  ) {
    raw_console.write('\r');
    erase_line(2);
    raw_console.write(line);
  }

  /// Sets the Current Text Color.
  void set_text_color(
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

  void hide_cursor() {
    if (!_cursor_ctrl_c) {
      ProcessSignal.sigint.watch().listen(
        (final signal) {
          show_cursor();
          exit(0);
        },
      );
      _cursor_ctrl_c = true;
    }
    write_ansi('?25l');
  }

  void show_cursor() {
    write_ansi('?25h');
  }

  void alt_buffer() {
    if (!_buff_ctlr_c) {
      ProcessSignal.sigint.watch().listen(
        (final signal) {
          norm_buffer();
          exit(0);
        },
      );
      _buff_ctlr_c = true;
    }
    write_ansi('?47h');
  }

  void norm_buffer() {
    write_ansi('?47l');
  }

  void set_background_color(
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

  void center_cursor({
    final bool row = true,
  }) {
    if (row) {
      final column = (columns / 2).round();
      final row = (rows / 2).round();
      move_cursor(row: row, column: column);
    } else {
      move_to_column((columns / 2).round());
    }
  }

  void move_cursor({
    final int? row,
    final int? column,
  }) {
    String out = '';
    if (row != null) {
      out += row.toString();
    }
    out += ';';
    if (column != null) {
      out += column.toString();
    }
    write_ansi('${out}H');
  }

  void reset_all() {
    sgr(0);
  }

  void reset_background_color() {
    sgr(49);
  }

  void sgr(
    final int id, [
    final List<int>? params,
  ]) {
    final stuff = () {
      if (params != null) {
        return "$id;${params.join(";")}";
      } else {
        return id.toString();
      }
    }();
    write_ansi('${stuff}m');
  }

  int get rows {
    return raw_console.rows;
  }

  int get columns {
    return raw_console.columns;
  }

  void write_ansi(
    final String after,
  ) {
    raw_console.write(control_sequence_identifier + after);
  }

  DCCursorPosition get_cursor_position() {
    final lm = raw_console.line_mode;
    final em = raw_console.echo_mode;
    raw_console.line_mode = false;
    raw_console.echo_mode = false;
    write_ansi('6n');
    final bytes = <int>[];
    for (;;) {
      final byte = raw_console.read_byte();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }
    raw_console.line_mode = lm;
    raw_console.echo_mode = em;
    String str = String.fromCharCodes(bytes);
    str = str.substring(
      str.lastIndexOf("[") + 1,
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
      return '${control_sequence_identifier}${() {
        if (background) {
          return 38;
        } else {
          return 48;
        }
      }()};5;${id}m';
    } else {
      if (bright) {
        return '${control_sequence_identifier}1;${(() {
              if (background) {
                return 40;
              } else {
                return 30;
              }
            }()) + id}m';
      } else {
        return '${control_sequence_identifier}0;${(() {
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

  int read_byte();

  Stream<List<int>> byte_stream();

  abstract bool echo_mode;

  abstract bool line_mode;
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
  Stream<List<int>> byte_stream() => stdin;

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
  set echo_mode(
    final bool value,
  ) =>
      stdin.echoMode = value;

  @override
  bool get echo_mode => stdin.echoMode;

  @override
  set line_mode(
    final bool value,
  ) =>
      stdin.lineMode = value;

  @override
  bool get line_mode => stdin.lineMode;

  @override
  int read_byte() => stdin.readByteSync();
}
