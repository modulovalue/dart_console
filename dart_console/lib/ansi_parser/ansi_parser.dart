/// May throw [ByteReadExceptionTooSmall] if any
/// given byte is smaller than [_stdin_end_of_file_indicator].
// region impl
KEY parse_key<KEY>({
  required final AnsiParserInputBuffer buffer,
  required final KeyDelegate<KEY, int> delegate,
}) {
  final first_valid_byte = () {
    int _read_byte = 0;
    while (_read_byte <= 0) {
      _read_byte = buffer.read_byte();
      if (_read_byte < _stdin_end_of_file_indicator) {
        throw _ByteReadExceptionTooSmallImpl(
          value: _read_byte,
        );
      } else if (_read_byte > _byte_size) {
        // TODO throw here?
        return _read_byte;
      }
    }
    return _read_byte;
  }();
  return _ansi_parser_read_key(
    first_byte: first_valid_byte,
    next_byte: buffer.read_byte,
    delegate: delegate,
    context: first_valid_byte,
  );
}

abstract class AnsiParserInputBuffer {
  int read_byte();
}

abstract class ByteReadExceptionTooSmall implements Exception {
  int get value;

  String get message;
}

abstract class KeyDelegate<T, CONTEXT> {
  T nil(final CONTEXT context);

  T start_of_header(final CONTEXT context);

  T start_of_text(final CONTEXT context);

  T end_of_text(final CONTEXT context);

  T end_of_transmission(final CONTEXT context);

  T enquiry(final CONTEXT context);

  T acknowledgment(final CONTEXT context);

  T bell(final CONTEXT context);

  T backspace(final CONTEXT context);

  T horizontal_tab(final CONTEXT context);

  T line_feed(final CONTEXT context);

  T vertical_tab(final CONTEXT context);

  T form_feed(final CONTEXT context);

  T carriage_return(final CONTEXT context);

  T shift_out(final CONTEXT context);

  T shift_in(final CONTEXT context);

  T data_link_escape(final CONTEXT context);

  T device_control_1(final CONTEXT context);

  T device_control_2(final CONTEXT context);

  T device_control_3(final CONTEXT context);

  T device_control_4(final CONTEXT context);

  T negative_acknowledgment(final CONTEXT context);

  T sync_idle(final CONTEXT context);

  T end_of_transmission_block(final CONTEXT context);

  T cancel(final CONTEXT context);

  T end_of_medium(final CONTEXT context);

  T substitute(final CONTEXT context);

  T escape_eof(final CONTEXT context);

  T escape_delete(final CONTEXT context);

  T escape_ansi_bracket_eof(final CONTEXT context);

  T escape_ansi_bracket_up(final CONTEXT context);

  T escape_ansi_bracket_down(final CONTEXT context);

  T escape_ansi_bracket_forward(final CONTEXT context);

  T escape_ansi_bracket_backward(final CONTEXT context);

  T escape_ansi_bracket_home(final CONTEXT context);

  T escape_ansi_bracket_end(final CONTEXT context);

  T escape_ansi_bracket1_eof(final CONTEXT context);

  T escape_ansi_bracket1_tilde(final CONTEXT context);

  T escape_ansi_bracket1_default(final CONTEXT context);

  T escape_ansi_bracket3_eof(final CONTEXT context);

  T escape_ansi_bracket3_tilde(final CONTEXT context);

  T escape_ansi_bracket3_default(final CONTEXT context);

  T escape_ansi_bracket4_eof(final CONTEXT context);

  T escape_ansi_bracket4_tilde(final CONTEXT context);

  T escape_ansi_bracket4_default(final CONTEXT context);

  T escape_ansi_bracket5_eof(final CONTEXT context);

  T escape_ansi_bracket5_tilde(final CONTEXT context);

  T escape_ansi_bracket5_default(final CONTEXT context);

  T escape_ansi_bracket6_eof(final CONTEXT context);

  T escape_ansi_bracket6_tilde(final CONTEXT context);

  T escape_ansi_bracket6_default(final CONTEXT context);

  T escape_ansi_bracket7_eof(final CONTEXT context);

  T escape_ansi_bracket7_tilde(final CONTEXT context);

  T escape_ansi_bracket7_default(final CONTEXT context);

  T escape_ansi_bracket8_eof(final CONTEXT context);

  T escape_ansi_bracket8_tilde(final CONTEXT context);

  T escape_ansi_bracket8_default(final CONTEXT context);

  T escape_ansi_bracket_default(final CONTEXT context);

  T escape_ansi_o_eof(final CONTEXT context);

  T escape_ansi_o_home(final CONTEXT context);

  T escape_ansi_o_end(final CONTEXT context);

  T escape_ansi_o_p(final CONTEXT context);

  T escape_ansi_o_q(final CONTEXT context);

  T escape_ansi_o_r(final CONTEXT context);

  T escape_ansi_o_s(final CONTEXT context);

  T escape_ansi_o_default(final CONTEXT context);

  T escape_ansi_b(final CONTEXT context);

  T escape_ansi_f(final CONTEXT context);

  T escape_ansi_default(final CONTEXT context);

  T file_separator(final CONTEXT context);

  T group_separator(final CONTEXT context);

  T record_separator(final CONTEXT context);

  T unit_separator(final CONTEXT context);

  T space(final CONTEXT context);

  T exclamation(final CONTEXT context);

  T double_quote(final CONTEXT context);

  T hash(final CONTEXT context);

  T dollar(final CONTEXT context);

  T percent(final CONTEXT context);

  T ampersand(final CONTEXT context);

  T single_quote(final CONTEXT context);

  T l_paren(final CONTEXT context);

  T r_paren(final CONTEXT context);

  T asterisk(final CONTEXT context);

  T plus(final CONTEXT context);

  T comma(final CONTEXT context);

  T minus(final CONTEXT context);

  T dot(final CONTEXT context);

  T slash(final CONTEXT context);

  T zero(final CONTEXT context);

  T one(final CONTEXT context);

  T two(final CONTEXT context);

  T three(final CONTEXT context);

  T four(final CONTEXT context);

  T five(final CONTEXT context);

  T six(final CONTEXT context);

  T seven(final CONTEXT context);

  T eight(final CONTEXT context);

  T nine(final CONTEXT context);

  T colon(final CONTEXT context);

  T semicolon(final CONTEXT context);

  T lt(final CONTEXT context);

  T equal(final CONTEXT context);

  T gt(final CONTEXT context);

  T question(final CONTEXT context);

  T at(final CONTEXT context);

  T cap_a(final CONTEXT context);

  T cap_b(final CONTEXT context);

  T cap_c(final CONTEXT context);

  T cap_d(final CONTEXT context);

  T cap_e(final CONTEXT context);

  T cap_f(final CONTEXT context);

  T cap_g(final CONTEXT context);

  T cap_h(final CONTEXT context);

  T cap_i(final CONTEXT context);

  T cap_j(final CONTEXT context);

  T cap_k(final CONTEXT context);

  T cap_l(final CONTEXT context);

  T cap_m(final CONTEXT context);

  T cap_n(final CONTEXT context);

  T cap_o(final CONTEXT context);

  T cap_p(final CONTEXT context);

  T cap_q(final CONTEXT context);

  T cap_r(final CONTEXT context);

  T cap_s(final CONTEXT context);

  T cap_t(final CONTEXT context);

  T cap_u(final CONTEXT context);

  T cap_v(final CONTEXT context);

  T cap_w(final CONTEXT context);

  T cap_x(final CONTEXT context);

  T cap_y(final CONTEXT context);

  T cap_z(final CONTEXT context);

  T l_bra(final CONTEXT context);

  T backslash(final CONTEXT context);

  T r_bra(final CONTEXT context);

  T caret(final CONTEXT context);

  T underscore(final CONTEXT context);

  T backquote(final CONTEXT context);

  T lower_a(final CONTEXT context);

  T lower_b(final CONTEXT context);

  T lower_c(final CONTEXT context);

  T lower_d(final CONTEXT context);

  T lower_e(final CONTEXT context);

  T lower_f(final CONTEXT context);

  T lower_g(final CONTEXT context);

  T lower_h(final CONTEXT context);

  T lower_i(final CONTEXT context);

  T lower_j(final CONTEXT context);

  T lower_k(final CONTEXT context);

  T lower_l(final CONTEXT context);

  T lower_m(final CONTEXT context);

  T lower_n(final CONTEXT context);

  T lower_o(final CONTEXT context);

  T lower_p(final CONTEXT context);

  T lower_q(final CONTEXT context);

  T lower_r(final CONTEXT context);

  T lower_s(final CONTEXT context);

  T lower_t(final CONTEXT context);

  T lower_u(final CONTEXT context);

  T lower_v(final CONTEXT context);

  T lower_w(final CONTEXT context);

  T lower_x(final CONTEXT context);

  T lower_y(final CONTEXT context);

  T lower_z(final CONTEXT context);

  T l_brace(final CONTEXT context);

  T bar(final CONTEXT context);

  T r_brace(final CONTEXT context);

  T tilde(final CONTEXT context);

  T del(final CONTEXT context);

  T extended(final CONTEXT context);
}
// endregion

// region internal
class _ByteReadExceptionTooSmallImpl implements ByteReadExceptionTooSmall {
  @override
  final int value;

  const _ByteReadExceptionTooSmallImpl({
    required this.value,
  });

  @override
  String get message {
    return "An invalid byte was read. Byte '" +
        value.toString() +
        "' was below " +
        _stdin_end_of_file_indicator.toString() +
        ".";
  }

  @override
  String toString() {
    return message;
  }
}

/// Parses the given first byte [first_byte] and any next bytes [next_byte].
/// into a key from [delegate] with context [context].
///
/// In other words, maps sequences of bytes into type exhaustive types.
R _ansi_parser_read_key<R, CONTEXT>({
  required final int first_byte,
  required final int Function() next_byte,
  required final KeyDelegate<R, CONTEXT> delegate,
  required final CONTEXT context,
}) {
  switch (first_byte) {
    // https://en.wikipedia.org/wiki/ASCII#Control_characters
    case _$nul: // Null
      return delegate.nil(context);
    case _$soh: // Start of header
      return delegate.start_of_header(context);
    case _$stx: // Start of text
      return delegate.start_of_text(context);
    case _$etx: // End of text
      return delegate.end_of_text(context);
    case _$eot: // End of transmission
      return delegate.end_of_transmission(context);
    case _$enq: // Enquiry
      return delegate.enquiry(context);
    case _$ack: // Acknowledgment
      return delegate.acknowledgment(context);
    case _$bel: // Bell
      return delegate.bell(context);
    case _$bs: // Backspace
      return delegate.backspace(context);
    case _$ht: // Horizontal Tab
      return delegate.horizontal_tab(context);
    case _$lf: // Line feed
      return delegate.line_feed(context);
    case _$vt: // Vertical Tab
      return delegate.vertical_tab(context);
    case _$ff: // Form feed
      return delegate.form_feed(context);
    case _$cr: // Carriage return
      return delegate.carriage_return(context);
    case _$so: // Shift out
      return delegate.shift_out(context);
    case _$si: // Shift in
      return delegate.shift_in(context);
    case _$dle: // Data link escape
      return delegate.data_link_escape(context);
    case _$dc1: // Device control 1
      return delegate.device_control_1(context);
    case _$dc2: // Device control 2
      return delegate.device_control_2(context);
    case _$dc3: // Device control 3
      return delegate.device_control_3(context);
    case _$dc4: // Device control 4
      return delegate.device_control_4(context);
    case _$nak: // Negative Acknowledgment
      return delegate.negative_acknowledgment(context);
    case _$syn: // Synchronous idle
      return delegate.sync_idle(context);
    case _$etb: // End of Transmission Block
      return delegate.end_of_transmission_block(context);
    case _$can: // Cancel
      return delegate.cancel(context);
    case _$em: // End of Medium
      return delegate.end_of_medium(context);
    case _$sub: // Substitute
      return delegate.substitute(context);
    case _ansi_escape_byte:
      switch (next_byte()) {
        case _stdin_end_of_file_indicator:
          return delegate.escape_eof(context);
        case _$del:
          return delegate.escape_delete(context);
        case _ansi_bracket_byte:
          switch (next_byte()) {
            case _stdin_end_of_file_indicator:
              return delegate.escape_ansi_bracket_eof(context);
            case _ansi_cursor_up_name_byte:
              return delegate.escape_ansi_bracket_up(context);
            case _ansi_cursor_down_name_byte:
              return delegate.escape_ansi_bracket_down(context);
            case _ansi_cursor_forward_name_byte:
              return delegate.escape_ansi_bracket_forward(context);
            case _ansi_cursor_back_name_byte:
              return delegate.escape_ansi_bracket_backward(context);
            case _ansi_char_home_byte:
              return delegate.escape_ansi_bracket_home(context);
            case _ansi_char_end_byte:
              return delegate.escape_ansi_bracket_end(context);
            case _$1:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket1_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket1_tilde(context);
                default:
                  return delegate.escape_ansi_bracket1_default(context);
              }
            case _$3:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket3_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket3_tilde(context);
                default:
                  return delegate.escape_ansi_bracket3_default(context);
              }
            case _$4:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket4_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket4_tilde(context);
                default:
                  return delegate.escape_ansi_bracket4_default(context);
              }
            case _$5:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket5_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket5_tilde(context);
                default:
                  return delegate.escape_ansi_bracket5_default(context);
              }
            case _$6:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket6_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket6_tilde(context);
                default:
                  return delegate.escape_ansi_bracket6_default(context);
              }
            case _$7:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket7_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket7_tilde(context);
                default:
                  return delegate.escape_ansi_bracket7_default(context);
              }
            case _$8:
              switch (next_byte()) {
                case _stdin_end_of_file_indicator:
                  return delegate.escape_ansi_bracket8_eof(context);
                case _$tilde:
                  return delegate.escape_ansi_bracket8_tilde(context);
                default:
                  return delegate.escape_ansi_bracket8_default(context);
              }
          }
          return delegate.escape_ansi_bracket_default(context);
        case _ansi_command_o_prefix_byte:
          switch (next_byte()) {
            case _stdin_end_of_file_indicator:
              return delegate.escape_ansi_o_eof(context);
            case _ansi_char_home_byte:
              return delegate.escape_ansi_o_home(context);
            case _ansi_char_end_byte:
              return delegate.escape_ansi_o_end(context);
            case _$P:
              return delegate.escape_ansi_o_p(context);
            case _$Q:
              return delegate.escape_ansi_o_q(context);
            case _$R:
              return delegate.escape_ansi_o_r(context);
            case _$S:
              return delegate.escape_ansi_o_s(context);
            default:
              return delegate.escape_ansi_o_default(context);
          }
        case _ansi_char_word_left_byte:
          return delegate.escape_ansi_b(context);
        case _ansi_char_word_right_byte:
          return delegate.escape_ansi_f(context);
        default:
          return delegate.escape_ansi_default(context);
      }
    case _$fs: // File Separator
      return delegate.file_separator(context);
    case _$gs: // Group Separator
      return delegate.group_separator(context);
    case _$rs: // Record Separator
      return delegate.record_separator(context);
    case _$us: // Unit Separator
      return delegate.unit_separator(context);
    case _$space: // ' '
      return delegate.space(context);
    case _$exclamation: // !
      return delegate.exclamation(context);
    case _$double_quote: // "
      return delegate.double_quote(context);
    case _$hash: // #
      return delegate.hash(context);
    case _$$: // _$
      return delegate.dollar(context);
    case _$percent: // %
      return delegate.percent(context);
    case _$ampersand: // &
      return delegate.ampersand(context);
    case _$single_quote: // '
      return delegate.single_quote(context);
    case _$lparen: // (
      return delegate.l_paren(context);
    case _$rparen: // )
      return delegate.r_paren(context);
    case _$asterisk: // *
      return delegate.asterisk(context);
    case _$plus: // +
      return delegate.plus(context);
    case _$comma: // ,
      return delegate.comma(context);
    case _$minus: // -
      return delegate.minus(context);
    case _$dot: // .
      return delegate.dot(context);
    case _$slash: // /
      return delegate.slash(context);
    case _$0: // 0
      return delegate.zero(context);
    case _$1: // 1
      return delegate.one(context);
    case _$2: // 2
      return delegate.two(context);
    case _$3: // 3
      return delegate.three(context);
    case _$4: // 4
      return delegate.four(context);
    case _$5: // 5
      return delegate.five(context);
    case _$6: // 6
      return delegate.six(context);
    case _$7: // 7
      return delegate.seven(context);
    case _$8: // 8
      return delegate.eight(context);
    case _$9: // 9
      return delegate.nine(context);
    case _$colon: // :
      return delegate.colon(context);
    case _$semicolon: // ;
      return delegate.semicolon(context);
    case _$lt: // <
      return delegate.lt(context);
    case _$equal: // =
      return delegate.equal(context);
    case _$gt: // >
      return delegate.gt(context);
    case _$question: // ?
      return delegate.question(context);
    case _$at: // @
      return delegate.at(context);
    case _$A: // A
      return delegate.cap_a(context);
    case _$B: // B
      return delegate.cap_b(context);
    case _$C: // C
      return delegate.cap_c(context);
    case _$D: // D
      return delegate.cap_d(context);
    case _$E: // E
      return delegate.cap_e(context);
    case _$F: // F
      return delegate.cap_f(context);
    case _$G: // G
      return delegate.cap_g(context);
    case _$H: // H
      return delegate.cap_h(context);
    case _$I: // I
      return delegate.cap_i(context);
    case _$J: // J
      return delegate.cap_j(context);
    case _$K: // K
      return delegate.cap_k(context);
    case _$L: // L
      return delegate.cap_l(context);
    case _$M: // M
      return delegate.cap_m(context);
    case _$N: // N
      return delegate.cap_n(context);
    case _$O: // O
      return delegate.cap_o(context);
    case _$P: // P
      return delegate.cap_p(context);
    case _$Q: // Q
      return delegate.cap_q(context);
    case _$R: // R
      return delegate.cap_r(context);
    case _$S: // S
      return delegate.cap_s(context);
    case _$T: // T
      return delegate.cap_t(context);
    case _$U: // U
      return delegate.cap_u(context);
    case _$V: // V
      return delegate.cap_v(context);
    case _$W: // W
      return delegate.cap_w(context);
    case _$X: // X
      return delegate.cap_x(context);
    case _$Y: // Y
      return delegate.cap_y(context);
    case _$Z: // Z
      return delegate.cap_z(context);
    case _$lbracket: // [
      return delegate.l_bra(context);
    case _$backslash: // \
      return delegate.backslash(context);
    case _$rbracket: // ]
      return delegate.r_bra(context);
    case _$caret: // ^
      return delegate.caret(context);
    case _$underscore: // _
      return delegate.underscore(context);
    case _$backquote: // `
      return delegate.backquote(context);
    case _$a: // a
      return delegate.lower_a(context);
    case _$b: // b
      return delegate.lower_b(context);
    case _$c: // c
      return delegate.lower_c(context);
    case _$d: // d
      return delegate.lower_d(context);
    case _$e: // e
      return delegate.lower_e(context);
    case _$f: // f
      return delegate.lower_f(context);
    case _$g: // g
      return delegate.lower_g(context);
    case _$h: // h
      return delegate.lower_h(context);
    case _$i: // i
      return delegate.lower_i(context);
    case _$j: // j
      return delegate.lower_j(context);
    case _$k: // k
      return delegate.lower_k(context);
    case _$l: // l
      return delegate.lower_l(context);
    case _$m: // m
      return delegate.lower_m(context);
    case _$n: // n
      return delegate.lower_n(context);
    case _$o: // o
      return delegate.lower_o(context);
    case _$p: // p
      return delegate.lower_p(context);
    case _$q: // q
      return delegate.lower_q(context);
    case _$r: // r
      return delegate.lower_r(context);
    case _$s: // s
      return delegate.lower_s(context);
    case _$t: // t
      return delegate.lower_t(context);
    case _$u: // u
      return delegate.lower_u(context);
    case _$v: // v
      return delegate.lower_v(context);
    case _$w: // w
      return delegate.lower_w(context);
    case _$x: // x
      return delegate.lower_x(context);
    case _$y: // y
      return delegate.lower_y(context);
    case _$z: // z
      return delegate.lower_z(context);
    case _$lbrace: // {
      return delegate.l_brace(context);
    case _$bar: // |
      return delegate.bar(context);
    case _$rbrace: // }
      return delegate.r_brace(context);
    case _$tilde: // ~
      return delegate.tilde(context);
    case _$del:
      return delegate.del(context);
    default:
    // https://www.torsten-horn.de/techdocs/ascii.htm
      return delegate.extended(context);
  }
}

/// What integer indicates that the end of a file has been reached?
const int _stdin_end_of_file_indicator = -1;

/// What is the size of a byte?
const int _byte_size = 0xff;

/// What byte indicates an asci escape sequence?
const int _ansi_escape_byte = 0x1B;

/// What byte, that comes after the escape
/// character byte indicates an ansi escape sequence?
const int _ansi_bracket_byte = 0x5B;

const int _ansi_cursor_up_name_byte = 0x41;

const int _ansi_cursor_down_name_byte = 0x42;

const int _ansi_cursor_forward_name_byte = 0x43;

const int _ansi_cursor_back_name_byte = 0x44;

const int _ansi_command_o_prefix_byte = 0x4F;

const int _ansi_char_end_byte = 0x46;

const int _ansi_char_home_byte = 0x48;

const int _ansi_char_word_right_byte = 0x66;

const int _ansi_char_word_left_byte = 0x62;

// TODO have constant String chars for printable characters and use them everywhere instead of using string literals.
/// "Null character" control character.
const int _$nul = 0x00;

/// "Start of Header" control character.
const int _$soh = 0x01;

/// "Start of Text" control character.
const int _$stx = 0x02;

/// "End of Text" control character.
const int _$etx = 0x03;

/// "End of Transmission" control character.
const int _$eot = 0x04;

/// "Enquiry" control character.
const int _$enq = 0x05;

/// "Acknowledgment" control character.
const int _$ack = 0x06;

/// "Bell" control character.
const int _$bel = 0x07;

/// "Backspace" control character.
const int _$bs = 0x08;

/// "Horizontal Tab" control character.
const int _$ht = 0x09;

/// "Line feed" control character.
const int _$lf = 0x0A;

/// "Vertical Tab" control character.
const int _$vt = 0x0B;

/// "Form feed" control character.
const int _$ff = 0x0C;

/// "Carriage return" control character.
const int _$cr = 0x0D;

/// "Shift Out" control character.
const int _$so = 0x0E;

/// "Shift In" control character.
const int _$si = 0x0F;

/// "Data Link Escape" control character.
const int _$dle = 0x10;

/// "Device Control 1" control character (oft. XON).
const int _$dc1 = 0x11;

/// "Device Control 2" control character.
const int _$dc2 = 0x12;

/// "Device Control 3" control character (oft. XOFF).
const int _$dc3 = 0x13;

/// "Device Control 4" control character.
const int _$dc4 = 0x14;

/// "Negative Acknowledgment" control character.
const int _$nak = 0x15;

/// "Synchronous idle" control character.
const int _$syn = 0x16;

/// "End of Transmission Block" control character.
const int _$etb = 0x17;

/// "Cancel" control character.
const int _$can = 0x18;

/// "End of Medium" control character.
const int _$em = 0x19;

/// "Substitute" control character.
const int _$sub = 0x1A;

// /// "Escape" control character.
// const int _$esc = 0x1B;

/// "File Separator" control character.
const int _$fs = 0x1C;

/// "Group Separator" control character.
const int _$gs = 0x1D;

/// "Record Separator" control character.
const int _$rs = 0x1E;

/// "Unit Separator" control character.
const int _$us = 0x1F;

/// "Delete" control character.
const int _$del = 0x7F;

// Printable characters.

/// Space character.
const int _$space = 0x20;

/// Character '!'.
const int _$exclamation = 0x21;

/// Character '"'.
const int _$double_quote = 0x22;

/// Character '#'.
const int _$hash = 0x23;

/// Character '$'.
const int _$$ = 0x24;

// /// Character '$'.
// const int _$dollar = 0x24;

/// Character '%'.
const int _$percent = 0x25;

/// Character '&'.
const int _$ampersand = 0x26;

/// Character '''.
const int _$single_quote = 0x27;

/// Character '('.
const int _$lparen = 0x28;

/// Character ')'.
const int _$rparen = 0x29;

/// Character '*'.
const int _$asterisk = 0x2A;

/// Character '+'.
const int _$plus = 0x2B;

/// Character ','.
const int _$comma = 0x2C;

/// Character '-'.
const int _$minus = 0x2D;

/// Character '.'.
const int _$dot = 0x2E;

/// Character '/'.
const int _$slash = 0x2F;

/// Character '0'.
const int _$0 = 0x30;

/// Character '1'.
const int _$1 = 0x31;

/// Character '2'.
const int _$2 = 0x32;

/// Character '3'.
const int _$3 = 0x33;

/// Character '4'.
const int _$4 = 0x34;

/// Character '5'.
const int _$5 = 0x35;

/// Character '6'.
const int _$6 = 0x36;

/// Character '7'.
const int _$7 = 0x37;

/// Character '8'.
const int _$8 = 0x38;

/// Character '9'.
const int _$9 = 0x39;

/// Character ':'.
const int _$colon = 0x3A;

/// Character ';'.
const int _$semicolon = 0x3B;

/// Character '<'.
const int _$lt = 0x3C;

// /// Character '<'.
// const int _$less_than = 0x3C;
//
// /// Character '<'.
// const int _$langle = 0x3C;
//
// /// Character '<'.
// const int _$open_angle = 0x3C;

/// Character '='.
const int _$equal = 0x3D;

/// Character '>'.
const int _$gt = 0x3E;

// /// Character '>'.
// const int _$greater_than = 0x3E;
//
// /// Character '>'.
// const int _$rangle = 0x3E;
//
// /// Character '>'.
// const int _$close_angle = 0x3E;

/// Character '?'.
const int _$question = 0x3F;

/// Character '@'.
const int _$at = 0x40;

/// Character 'A'.
const int _$A = 0x41;

/// Character 'B'.
const int _$B = 0x42;

/// Character 'C'.
const int _$C = 0x43;

/// Character 'D'.
const int _$D = 0x44;

/// Character 'E'.
const int _$E = 0x45;

/// Character 'F'.
const int _$F = 0x46;

/// Character 'G'.
const int _$G = 0x47;

/// Character 'H'.
const int _$H = 0x48;

/// Character 'I'.
const int _$I = 0x49;

/// Character 'J'.
const int _$J = 0x4A;

/// Character 'K'.
const int _$K = 0x4B;

/// Character 'L'.
const int _$L = 0x4C;

/// Character 'M'.
const int _$M = 0x4D;

/// Character 'N'.
const int _$N = 0x4E;

/// Character 'O'.
const int _$O = 0x4F;

/// Character 'P'.
const int _$P = 0x50;

/// Character 'Q'.
const int _$Q = 0x51;

/// Character 'R'.
const int _$R = 0x52;

/// Character 'S'.
const int _$S = 0x53;

/// Character 'T'.
const int _$T = 0x54;

/// Character 'U'.
const int _$U = 0x55;

/// Character 'V'.
const int _$V = 0x56;

/// Character 'W'.
const int _$W = 0x57;

/// Character 'X'.
const int _$X = 0x58;

/// Character 'Y'.
const int _$Y = 0x59;

/// Character 'Z'.
const int _$Z = 0x5A;

/// Character '['.
const int _$lbracket = 0x5B;

// /// Character '['.
// const int _$open_bracket = 0x5B;

/// Character '\'.
const int _$backslash = 0x5C;

/// Character ']'.
const int _$rbracket = 0x5D;

// /// Character ']'.
// const int _$close_bracket = 0x5D;

// /// Character '^'.
// const int _$circumflex = 0x5E;

/// Character '^'.
const int _$caret = 0x5E;

// /// Character '^'.
// const int _$hat = 0x5E;

// /// Character '_'.
// const int _$_ = 0x5F;

/// Character '_'.
const int _$underscore = 0x5F;

// /// Character '_'.
// const int _$underline = 0x5F;

/// Character '`'.
const int _$backquote = 0x60;

// /// Character '`'.
// const int _$grave = 0x60;

/// Character 'a'.
const int _$a = 0x61;

/// Character 'b'.
const int _$b = 0x62;

/// Character 'c'.
const int _$c = 0x63;

/// Character 'd'.
const int _$d = 0x64;

/// Character 'e'.
const int _$e = 0x65;

/// Character 'f'.
const int _$f = 0x66;

/// Character 'g'.
const int _$g = 0x67;

/// Character 'h'.
const int _$h = 0x68;

/// Character 'i'.
const int _$i = 0x69;

/// Character 'j'.
const int _$j = 0x6A;

/// Character 'k'.
const int _$k = 0x6B;

/// Character 'l'.
const int _$l = 0x6C;

/// Character 'm'.
const int _$m = 0x6D;

/// Character 'n'.
const int _$n = 0x6E;

/// Character 'o'.
const int _$o = 0x6F;

/// Character 'p'.
const int _$p = 0x70;

/// Character 'q'.
const int _$q = 0x71;

/// Character 'r'.
const int _$r = 0x72;

/// Character 's'.
const int _$s = 0x73;

/// Character 't'.
const int _$t = 0x74;

/// Character 'u'.
const int _$u = 0x75;

/// Character 'v'.
const int _$v = 0x76;

/// Character 'w'.
const int _$w = 0x77;

/// Character 'x'.
const int _$x = 0x78;

/// Character 'y'.
const int _$y = 0x79;

/// Character 'z'.
const int _$z = 0x7A;

/// Character '{'.
const int _$lbrace = 0x7B;

// /// Character '{'.
// const int _$open_brace = 0x7B;
//
// /// Character '|'.
// const int _$pipe = 0x7C;

/// Character '|'.
const int _$bar = 0x7C;

/// Character '}'.
const int _$rbrace = 0x7D;

// /// Character '}'.
// const int _$close_brace = 0x7D;

/// Character '~'.
const int _$tilde = 0x7E;
// endregion
