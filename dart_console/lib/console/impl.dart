import 'dart:io';
import 'dart:math';

import '../ansi_parser/ansi_parser.dart';
import '../ansi_writer/ansi_writer.dart';
import '../terminal/terminal_lib.dart';
import 'interface.dart';

// TODO needs a cleanup

// region public
// TODO have a mixin and separate impls. for scrolling and non scrolling.
class SneathConsoleImpl implements SneathConsole {
  bool _is_raw_mode = false;
  final SneathTerminal terminal;
  final _ScrollbackBuffer? _scrollback_buffer;

  SneathConsoleImpl({
    required final this.terminal,
  }) : _scrollback_buffer = null;

  @override
  late final SneathConsoleDimensions dimensions =
      SneathConsoleDimensionsCachedImpl(
    terminal,
    cursor_position,
  );

  @override
  late final SneathCursorPositionDelegate cursor_position =
      SneathCursorPositionDelegateImpl(
    terminal,
    (final new_raw_mode) => set_raw_mode(new_raw_mode),
  );

  /// Create a named constructor specifically for scrolling consoles
  /// Use `Console.scrolling(recordBlanks: false)` to omit blank lines
  /// from console history
  SneathConsoleImpl.scrolling({
    required final this.terminal,
    final bool record_blanks = true,
  }) : _scrollback_buffer = _ScrollbackBufferImpl(
          record_blanks: record_blanks,
        );

  @override
  bool get raw_mode {
    return _is_raw_mode;
  }

  @override
  void clear_screen() {
    terminal.clear_screen();
  }

  @override
  void erase_line() {
    stdout.write(control_sequence_identifier + '2K');
  }

  @override
  void erase_cursor_to_end() {
    stdout.write(control_sequence_identifier + 'K');
  }

  @override
  void hide_cursor() {
    stdout.write(control_sequence_identifier + "?25l");
  }

  @override
  void show_cursor() {
    stdout.write(control_sequence_identifier + "?25h");
  }

  @override
  void cursor_left() {
    stdout.write(control_sequence_identifier + 'D');
  }

  @override
  void cursor_right() {
    stdout.write(control_sequence_identifier + 'C');
  }

  @override
  void cursor_up() {
    stdout.write(control_sequence_identifier + 'A');
  }

  @override
  void cursor_down() {
    stdout.write(control_sequence_identifier + 'B');
  }

  @override
  void reset_cursor_position() {
    stdout.write(
      control_sequence_identifier + "1;1H",
    );
  }

  @override
  void set_foreground_color(
    final AnsiForegroundColor foreground,
  ) {
    stdout.write(
      ansi_set_text_color(foreground),
    );
  }

  @override
  void set_background_color(
    final AnsiBackgroundColor background,
  ) {
    stdout.write(
      ansi_set_background_color(background),
    );
  }

  @override
  void set_foreground_extended_color(
    final AnsiExtendedColorPalette color,
  ) {
    stdout.write(
      ansi_set_extended_foreground_color(
        color,
      ),
    );
  }

  @override
  void set_background_extended_color(
    final AnsiExtendedColorPalette color,
  ) {
    stdout.write(
      ansi_set_extended_background_color(
        color,
      ),
    );
  }

  @override
  void set_text_style({
    final bool bold = false,
    final bool underscore = false,
    final bool blink = false,
    final bool inverted = false,
  }) {
    stdout.write(
      ansi_set_text_styles(
        bold: bold,
        underscore: underscore,
        blink: blink,
        inverted: inverted,
      ),
    );
  }

  @override
  void reset_color_attributes() {
    stdout.write(
      control_sequence_identifier + 'm',
    );
  }

  @override
  void write(
    final String text,
  ) {
    stdout.write(text);
  }

  @override
  String get new_line {
    if (_is_raw_mode) {
      return '\r\n';
    } else {
      return '\n';
    }
  }

  @override
  void write_error_line(
    final String text,
  ) {
    stderr.write(text);
    // Even if we're in raw mode, we write '\n',
    // since raw mode only applies to stdout.
    stderr.write('\n');
  }

  @override
  void write_line([
    final String? text,
    final ConsoleTextAlignment alignment = ConsoleTextAlignments.left,
  ]) {
    if (text != null) {
      stdout.write(
        _apply_alignment(
          alignment,
          text,
          dimensions.width,
        ),
      );
    }
    stdout.write(new_line);
  }

  @override
  Key read_key() {
    set_raw_mode(true);
    final key = parse_key(
      buffer: const AnsiParserInputBufferStdinImpl(),
      delegate: const KeyDelegateKeyBindingsImpl(),
    );
    set_raw_mode(false);
    return key;
  }

  @override
  String? read_line({
    final bool cancel_on_break = false,
    final bool cancel_on_escape = false,
    final bool cancel_on_eof = false,
    final void Function(String text, Key lastPressed)? callback,
  }) {
    String buffer = '';
    // Cursor position relative to buffer, not screen.
    int index = 0;
    final current_cursor_position = cursor_position.get();
    final screen_row = current_cursor_position!.row;
    final screen_col_offset = current_cursor_position.col;
    final buffer_max_length = dimensions.width - screen_col_offset - 3;
    for (;;) {
      final key = read_key();
      key.match(
        printable: (final key) {
          if (buffer.length < buffer_max_length) {
            if (index == buffer.length) {
              buffer += key.char;
              index++;
            } else {
              buffer = buffer.substring(0, index) +
                  key.char +
                  buffer.substring(index);
              index++;
            }
          }
        },
        control: (final key) {
          switch (key.control_char) {
            case ControlCharacters.enter:
              if (_scrollback_buffer != null) {
                _scrollback_buffer!.add(buffer);
              }
              write_line();
              return buffer;
            case ControlCharacters.ctrlC:
              if (cancel_on_break) {
                return null;
              }
              break;
            case ControlCharacters.escape:
              if (cancel_on_escape) {
                return null;
              }
              break;
            case ControlCharacters.backspace:
            case ControlCharacters.ctrlH:
              if (index > 0) {
                buffer =
                    buffer.substring(0, index - 1) + buffer.substring(index);
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
                buffer =
                    buffer.substring(0, index) + buffer.substring(index + 1);
              } else if (cancel_on_eof) {
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
              if (_scrollback_buffer != null) {
                buffer = _scrollback_buffer!.up(buffer);
                index = buffer.length;
              }
              break;
            case ControlCharacters.arrowDown:
              if (_scrollback_buffer != null) {
                final temp = _scrollback_buffer!.down();
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
      cursor_position.update(
        SneathCoordinateImpl(
          row: screen_row,
          col: screen_col_offset,
        ),
      );
      erase_cursor_to_end();
      // Allow for backspace condition.
      write(buffer);
      cursor_position.update(
        SneathCoordinateImpl(
          row: screen_row,
          col: screen_col_offset + index,
        ),
      );
      if (callback != null) {
        callback(buffer, key);
      }
    }
  }

  @override
  void write_line_centered(
    final String? text,
  ) {
    write_line(text, ConsoleTextAlignments.center);
  }

  @override
  void write_lines(
    final Iterable<String> lines,
    final ConsoleTextAlignment alignment,
  ) {
    for (final line in lines) {
      write_line(line, alignment);
    }
  }

  @override
  void write_lines_centered(
    final Iterable<String> lines,
  ) {
    lines.forEach(write_line_centered);
  }

  @override
  void set_raw_mode(final bool value) {
    _is_raw_mode = value;
    if (value) {
      terminal.enable_raw_mode();
    } else {
      terminal.disable_raw_mode();
    }
  }
}

class AnsiParserInputBufferStdinImpl implements AnsiParserInputBuffer {
  const AnsiParserInputBufferStdinImpl();

  @override
  int read_byte() {
    return stdin.readByteSync();
  }
}

class KeyDelegateKeyBindingsImpl implements KeyDelegate<Key, int> {
  const KeyDelegateKeyBindingsImpl();

  @override
  KeyControlImpl nil(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl start_of_header(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlA);

  @override
  KeyControlImpl start_of_text(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlB);

  @override
  KeyControlImpl end_of_text(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlC);

  @override
  KeyControlImpl end_of_transmission(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlD);

  @override
  KeyControlImpl enquiry(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlE);

  @override
  KeyControlImpl acknowledgment(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlF);

  @override
  KeyControlImpl bell(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlG);

  @override
  KeyControlImpl backspace(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlH);

  @override
  KeyControlImpl horizontal_tab(final int context) =>
      const KeyControlImpl(ControlCharacters.tab);

  @override
  KeyControlImpl line_feed(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlJ);

  @override
  KeyControlImpl vertical_tab(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlK);

  @override
  KeyControlImpl form_feed(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlL);

  @override
  KeyControlImpl carriage_return(final int context) =>
      const KeyControlImpl(ControlCharacters.enter);

  @override
  KeyControlImpl shift_out(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlN);

  @override
  KeyControlImpl shift_in(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlO);

  @override
  KeyControlImpl data_link_escape(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlP);

  @override
  KeyControlImpl device_control_1(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlQ);

  @override
  KeyControlImpl device_control_2(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlR);

  @override
  KeyControlImpl device_control_3(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlS);

  @override
  KeyControlImpl device_control_4(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlT);

  @override
  KeyControlImpl negative_acknowledgment(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlU);

  @override
  KeyControlImpl sync_idle(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlV);

  @override
  KeyControlImpl end_of_transmission_block(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlW);

  @override
  KeyControlImpl cancel(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlX);

  @override
  KeyControlImpl end_of_medium(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlY);

  @override
  KeyControlImpl substitute(final int context) =>
      const KeyControlImpl(ControlCharacters.ctrlZ);

  @override
  KeyControlImpl escape_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_delete(final int context) =>
      const KeyControlImpl(ControlCharacters.wordBackspace);

  @override
  KeyControlImpl escape_ansi_bracket_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket_up(final int context) =>
      const KeyControlImpl(ControlCharacters.arrowUp);

  @override
  KeyControlImpl escape_ansi_bracket_down(final int context) =>
      const KeyControlImpl(ControlCharacters.arrowDown);

  @override
  KeyControlImpl escape_ansi_bracket_forward(final int context) =>
      const KeyControlImpl(ControlCharacters.arrowRight);

  @override
  KeyControlImpl escape_ansi_bracket_backward(final int context) =>
      const KeyControlImpl(ControlCharacters.arrowLeft);

  @override
  KeyControlImpl escape_ansi_bracket_home(final int context) =>
      const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escape_ansi_bracket_end(final int context) =>
      const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escape_ansi_bracket1_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket1_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escape_ansi_bracket1_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket3_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket3_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.delete);

  @override
  KeyControlImpl escape_ansi_bracket3_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket4_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket4_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escape_ansi_bracket4_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket5_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket5_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.pageUp);

  @override
  KeyControlImpl escape_ansi_bracket5_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket6_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket6_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.pageDown);

  @override
  KeyControlImpl escape_ansi_bracket6_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket7_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket7_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escape_ansi_bracket7_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket8_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_bracket8_tilde(final int context) =>
      const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escape_ansi_bracket8_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_bracket_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl escape_ansi_o_eof(final int context) =>
      const KeyControlImpl(ControlCharacters.escape);

  @override
  KeyControlImpl escape_ansi_o_home(final int context) =>
      const KeyControlImpl(ControlCharacters.home);

  @override
  KeyControlImpl escape_ansi_o_end(final int context) =>
      const KeyControlImpl(ControlCharacters.end);

  @override
  KeyControlImpl escape_ansi_o_p(final int context) =>
      const KeyControlImpl(ControlCharacters.F1);

  @override
  KeyControlImpl escape_ansi_o_q(final int context) =>
      const KeyControlImpl(ControlCharacters.F2);

  @override
  KeyControlImpl escape_ansi_o_r(final int context) =>
      const KeyControlImpl(ControlCharacters.F3);

  @override
  KeyControlImpl escape_ansi_o_s(final int context) =>
      const KeyControlImpl(ControlCharacters.F4);

  @override
  KeyControlImpl escape_ansi_o_default(final int context) =>
      throw Exception("Unexpected O command");

  @override
  KeyControlImpl escape_ansi_b(final int context) =>
      const KeyControlImpl(ControlCharacters.wordLeft);

  @override
  KeyControlImpl escape_ansi_f(final int context) =>
      const KeyControlImpl(ControlCharacters.wordRight);

  @override
  KeyControlImpl escape_ansi_default(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl file_separator(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl group_separator(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl record_separator(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyControlImpl unit_separator(final int context) =>
      const KeyControlImpl(ControlCharacters.unknown);

  @override
  KeyPrintableImpl space(final int context) => const KeyPrintableImpl(' ');

  @override
  KeyPrintableImpl exclamation(final int context) =>
      const KeyPrintableImpl('!');

  @override
  KeyPrintableImpl double_quote(final int context) =>
      const KeyPrintableImpl('"');

  @override
  KeyPrintableImpl hash(final int context) => const KeyPrintableImpl("#");

  @override
  KeyPrintableImpl dollar(final int context) => const KeyPrintableImpl(r"$");

  @override
  KeyPrintableImpl percent(final int context) => const KeyPrintableImpl("%");

  @override
  KeyPrintableImpl ampersand(final int context) => const KeyPrintableImpl("&");

  @override
  KeyPrintableImpl single_quote(final int context) =>
      const KeyPrintableImpl("'");

  @override
  KeyPrintableImpl l_paren(final int context) => const KeyPrintableImpl("(");

  @override
  KeyPrintableImpl r_paren(final int context) => const KeyPrintableImpl(")");

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
  KeyPrintableImpl cap_a(final int context) => const KeyPrintableImpl("A");

  @override
  KeyPrintableImpl cap_b(final int context) => const KeyPrintableImpl("B");

  @override
  KeyPrintableImpl cap_c(final int context) => const KeyPrintableImpl("C");

  @override
  KeyPrintableImpl cap_d(final int context) => const KeyPrintableImpl("D");

  @override
  KeyPrintableImpl cap_e(final int context) => const KeyPrintableImpl("E");

  @override
  KeyPrintableImpl cap_f(final int context) => const KeyPrintableImpl("F");

  @override
  KeyPrintableImpl cap_g(final int context) => const KeyPrintableImpl("G");

  @override
  KeyPrintableImpl cap_h(final int context) => const KeyPrintableImpl("H");

  @override
  KeyPrintableImpl cap_i(final int context) => const KeyPrintableImpl("I");

  @override
  KeyPrintableImpl cap_j(final int context) => const KeyPrintableImpl("J");

  @override
  KeyPrintableImpl cap_k(final int context) => const KeyPrintableImpl("K");

  @override
  KeyPrintableImpl cap_l(final int context) => const KeyPrintableImpl("L");

  @override
  KeyPrintableImpl cap_m(final int context) => const KeyPrintableImpl("M");

  @override
  KeyPrintableImpl cap_n(final int context) => const KeyPrintableImpl("N");

  @override
  KeyPrintableImpl cap_o(final int context) => const KeyPrintableImpl("O");

  @override
  KeyPrintableImpl cap_p(final int context) => const KeyPrintableImpl("P");

  @override
  KeyPrintableImpl cap_q(final int context) => const KeyPrintableImpl("Q");

  @override
  KeyPrintableImpl cap_r(final int context) => const KeyPrintableImpl("R");

  @override
  KeyPrintableImpl cap_s(final int context) => const KeyPrintableImpl("S");

  @override
  KeyPrintableImpl cap_t(final int context) => const KeyPrintableImpl("T");

  @override
  KeyPrintableImpl cap_u(final int context) => const KeyPrintableImpl("U");

  @override
  KeyPrintableImpl cap_v(final int context) => const KeyPrintableImpl("V");

  @override
  KeyPrintableImpl cap_w(final int context) => const KeyPrintableImpl("W");

  @override
  KeyPrintableImpl cap_x(final int context) => const KeyPrintableImpl("X");

  @override
  KeyPrintableImpl cap_y(final int context) => const KeyPrintableImpl("Y");

  @override
  KeyPrintableImpl cap_z(final int context) => const KeyPrintableImpl("Z");

  @override
  KeyPrintableImpl l_bra(final int context) => const KeyPrintableImpl("[");

  @override
  KeyPrintableImpl backslash(final int context) => const KeyPrintableImpl(r"\");

  @override
  KeyPrintableImpl r_bra(final int context) => const KeyPrintableImpl("]");

  @override
  KeyPrintableImpl caret(final int context) => const KeyPrintableImpl("^");

  @override
  KeyPrintableImpl underscore(final int context) => const KeyPrintableImpl("_");

  @override
  KeyPrintableImpl backquote(final int context) => const KeyPrintableImpl("`");

  @override
  KeyPrintableImpl lower_a(final int context) => const KeyPrintableImpl("a");

  @override
  KeyPrintableImpl lower_b(final int context) => const KeyPrintableImpl("b");

  @override
  KeyPrintableImpl lower_c(final int context) => const KeyPrintableImpl("c");

  @override
  KeyPrintableImpl lower_d(final int context) => const KeyPrintableImpl("d");

  @override
  KeyPrintableImpl lower_e(final int context) => const KeyPrintableImpl("e");

  @override
  KeyPrintableImpl lower_f(final int context) => const KeyPrintableImpl("f");

  @override
  KeyPrintableImpl lower_g(final int context) => const KeyPrintableImpl("g");

  @override
  KeyPrintableImpl lower_h(final int context) => const KeyPrintableImpl("h");

  @override
  KeyPrintableImpl lower_i(final int context) => const KeyPrintableImpl("i");

  @override
  KeyPrintableImpl lower_j(final int context) => const KeyPrintableImpl("j");

  @override
  KeyPrintableImpl lower_k(final int context) => const KeyPrintableImpl("k");

  @override
  KeyPrintableImpl lower_l(final int context) => const KeyPrintableImpl("l");

  @override
  KeyPrintableImpl lower_m(final int context) => const KeyPrintableImpl("m");

  @override
  KeyPrintableImpl lower_n(final int context) => const KeyPrintableImpl("n");

  @override
  KeyPrintableImpl lower_o(final int context) => const KeyPrintableImpl("o");

  @override
  KeyPrintableImpl lower_p(final int context) => const KeyPrintableImpl("p");

  @override
  KeyPrintableImpl lower_q(final int context) => const KeyPrintableImpl("q");

  @override
  KeyPrintableImpl lower_r(final int context) => const KeyPrintableImpl("r");

  @override
  KeyPrintableImpl lower_s(final int context) => const KeyPrintableImpl("s");

  @override
  KeyPrintableImpl lower_t(final int context) => const KeyPrintableImpl("t");

  @override
  KeyPrintableImpl lower_u(final int context) => const KeyPrintableImpl("u");

  @override
  KeyPrintableImpl lower_v(final int context) => const KeyPrintableImpl("v");

  @override
  KeyPrintableImpl lower_w(final int context) => const KeyPrintableImpl("w");

  @override
  KeyPrintableImpl lower_x(final int context) => const KeyPrintableImpl("x");

  @override
  KeyPrintableImpl lower_y(final int context) => const KeyPrintableImpl("y");

  @override
  KeyPrintableImpl lower_z(final int context) => const KeyPrintableImpl("z");

  @override
  KeyPrintableImpl l_brace(final int context) => const KeyPrintableImpl("{");

  @override
  KeyPrintableImpl bar(final int context) => const KeyPrintableImpl("|");

  @override
  KeyPrintableImpl r_brace(final int context) => const KeyPrintableImpl("}");

  @override
  KeyPrintableImpl tilde(final int context) => const KeyPrintableImpl("~");

  @override
  KeyControlImpl del(final int context) =>
      const KeyControlImpl(ControlCharacters.backspace);

  @override
  KeyPrintableImpl extended(final int context) =>
      KeyPrintableImpl(String.fromCharCode(context));
}

class SneathCoordinateImpl implements SneathCoordinate {
  @override
  final int row;
  @override
  final int col;

  const SneathCoordinateImpl({
    required final this.row,
    required final this.col,
  });
}

class SneathCursorPositionDelegateImpl implements SneathCursorPositionDelegate {
  final SneathTerminal terminal;
  final void Function(bool) setRawModeDelegate;

  const SneathCursorPositionDelegateImpl(
    final this.terminal,
    final this.setRawModeDelegate,
  );

  @override
  SneathCoordinate? get() {
    setRawModeDelegate(true);
    stdout.write(control_sequence_identifier + '6n');
    // returns a Cursor Position Report result in the form <ESC>[24;80R
    // which we have to parse apart.
    String result = '';
    int i = 0;
    // avoid infinite loop if we're getting a bad result
    while (i < 16) {
      // ignore: use_string_buffers
      result += String.fromCharCode(stdin.readByteSync());
      if (result.endsWith('R')) {
        break;
      }
      i++;
    }
    setRawModeDelegate(false);
    if (result[0] != "\x1b") {
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
          return SneathCoordinateImpl(row: parsedX - 1, col: parsedY - 1);
        } else {
          print(' coords[0]: ${coords[0]}   coords[1]: ${coords[1]}');
          return null;
        }
      }
    }
  }

  @override
  void update(
    final SneathCoordinate? cursor,
  ) {
    if (cursor != null) {
      terminal.set_cursor_position(cursor.col, cursor.row);
    }
  }
}

// TODO dimensions that are updated by a Platform.sig stream.
/// A [SneathConsoleDimensions] that caches the dimensions
/// the first time that they are retrieved.
///
/// This command attempts to use the ioctl() system call to retrieve the
/// window height, and if that fails uses ANSI escape codes to identify its
/// location by walking off the edge of the screen and seeing what the
/// terminal clipped the cursor to.
class SneathConsoleDimensionsCachedImpl implements SneathConsoleDimensions {
  final SneathCursorPositionDelegate cursorPosition;
  final SneathTerminal _terminal;

  int? _width;
  int? _height;

  SneathConsoleDimensionsCachedImpl(
    final this._terminal,
    final this.cursorPosition,
  );

  // TODO return either if ran out of options.
  @override
  int get width {
    if (_width == null) {
      // try using ioctl() to give us the screen size
      final width = _terminal.get_window_width();
      if (width != -1) {
        return _width = width;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition.get();
        stdout.write(control_sequence_identifier +
            '999C' +
            control_sequence_identifier +
            '999B');
        final newCursor = cursorPosition.get();
        cursorPosition.update(originalCursor);
        if (newCursor != null) {
          return _width = newCursor.col;
        } else {
          // we've run out of options; terminal is unsupported
          throw Exception(
            "Couldn't retrieve window width.",
          );
        }
      }
    } else {
      return _width!;
    }
  }

  // TODO return either if ran out of options.
  @override
  int get height {
    if (_height == null) {
      // try using ioctl() to give us the screen size
      final height = _terminal.get_window_height();
      if (height != -1) {
        return _height = height;
      } else {
        // otherwise, fall back to the approach of setting the cursor to beyond
        // the edge of the screen and then reading back its actual position
        final originalCursor = cursorPosition.get();
        stdout.write(control_sequence_identifier +
            '999C' +
            control_sequence_identifier +
            '999B');
        final newCursor = cursorPosition.get();
        cursorPosition.update(originalCursor);
        if (newCursor != null) {
          return _height = newCursor.row;
        } else {
          // we've run out of options; terminal is unsupported
          throw Exception(
            "Couldn't retrieve window height",
          );
        }
      }
    } else {
      return _height!;
    }
  }
}

class KeyControlImpl with KeyControlMixin {
  @override
  final ControlCharacter control_char;

  const KeyControlImpl(
    final this.control_char,
  );
}

mixin KeyControlMixin implements KeyControl {
  @override
  ControlCharacter get control_char;

  @override
  Z match<Z>({
    required final Z Function(KeyPrintable p1) printable,
    required final Z Function(KeyControl p1) control,
  }) =>
      control(this);

  @override
  String toString() => 'KeyControl{controlChar: $control_char}';

  @override
  bool operator ==(
    final Object other,
  ) =>
      identical(this, other) ||
      other is KeyControl && control_char == other.control_char;

  @override
  int get hashCode => control_char.hashCode;
}

class KeyPrintableImpl implements KeyPrintable {
  @override
  final String char;

  const KeyPrintableImpl(
    final this.char,
  ) : assert(
          char.length == 1,
          "The given character " +
              char +
              " must be a character i.e. of length 1.",
        );

  @override
  Z match<Z>({
    required final Z Function(KeyPrintable p1) printable,
    required final Z Function(KeyControl p1) control,
  }) {
    return printable(this);
  }

  @override
  String toString() {
    return char;
  }

  @override
  bool operator ==(
    final Object other,
  ) {
    return identical(this, other) || other is KeyPrintable && char == other.char;
  }

  @override
  int get hashCode => char.hashCode;
}
// endregion

// region internal
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
  final List<String> line_list = [];
  final bool record_blanks;
  int? line_index;
  String? current_line_buffer;

  _ScrollbackBufferImpl({
    required final this.record_blanks,
  });

  @override
  void add(
      final String buffer,
      ) {
    if (record_blanks) {
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
    line_list.add(buffer);
    line_index = line_list.length;
    current_line_buffer = null;
  }

  @override
  String up(
      final String buffer,
      ) {
    final _line_index = line_index;
    // Handle the case of the user tapping 'up' before there is a
    // scrollback buffer to scroll through.
    if (_line_index == null) {
      return buffer;
    } else {
      // Only store the current line buffer once while scrolling up
      current_line_buffer ??= buffer;
      // Decrease the line index by one and lower-clamp it to the first line list item.
      if (_line_index == 0) {
        line_index = 0;
      } else {
        line_index = _line_index - 1;
      }
      return line_list[_line_index];
    }
  }

  @override
  String? down() {
    final _line_index = line_index;
    // Handle the case of the user tapping 'down' before there is a
    // scrollback buffer to scroll through.
    if (_line_index == null) {
      return null;
    } else {
      // Increase the line index by one and upper-clamp it to the last lineList item.
      if (_line_index == line_list.length) {
        line_index = line_list.length;
      } else {
        line_index = _line_index + 1;
      }
      if (line_index == line_list.length) {
        // Once the user scrolls to the bottom, reset the current line
        // buffer so that up() can store it again: The user might have
        // edited it between down() and up().
        final temp = current_line_buffer;
        current_line_buffer = null;
        return temp;
      } else {
        return line_list[_line_index];
      }
    }
  }
}

String _apply_alignment(
  final ConsoleTextAlignment alignment,
  final String text,
  final int window_width,
) {
  return alignment.match(
    left: (final a) => text,
    center: (final a) {
      String align_single_line(
        final String text,
        final int windowWidth,
      ) =>
          text
              .padLeft(
                text.length + ((windowWidth - text.length) / 2).round(),
              )
              .padRight(windowWidth);
      return text
          .split("\n")
          .map(
            (final line) => align_single_line(
              line,
              window_width,
            ),
          )
          .join("\n");
    },
    right: (final a) => text.padLeft(window_width),
  );
}
// endregion
