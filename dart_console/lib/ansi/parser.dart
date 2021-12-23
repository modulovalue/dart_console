/// May throw [ByteReadExceptionTooSmall] if any
/// given byte is smaller than [_stdinEndOfFileIndicator].
KEY parseKey<KEY>({
  required final AnsiParserInputBuffer buffer,
  required final KeyDelegate<KEY, int> delegate,
}) {
  final firstValidByte = () {
    var _readByte = 0;
    while (_readByte <= 0) {
      _readByte = buffer.readByte();
      if (_readByte < _stdinEndOfFileIndicator) {
        throw _ByteReadExceptionTooSmallImpl(
          value: _readByte,
        );
      } else if (_readByte > _byteSize) {
        // Let callers handle bytes that are too big.
        return _readByte;
      }
    }
    return _readByte;
  }();
  return ansiParserReadKey(
    firstByte: firstValidByte,
    nextByte: buffer.readByte,
    delegate: delegate,
    context: firstValidByte,
  );
}

class _ByteReadExceptionTooSmallImpl implements ByteReadExceptionTooSmall {
  @override
  final int value;

  const _ByteReadExceptionTooSmallImpl({
    required final this.value,
  });

  @override
  String get message =>
      "An invalid byte was read. Byte '" +
      value.toString() +
      "' was below " +
      _stdinEndOfFileIndicator.toString() +
      ".";

  @override
  String toString() => message;
}

abstract class AnsiParserInputBuffer {
  int readByte();
}

abstract class ByteReadExceptionTooSmall implements Exception {
  int get value;

  String get message;
}

/// Parses the given first byte [firstByte] and any next bytes [nextByte].
/// into a key from [delegate] with context [context].
///
/// In other words, maps sequences of bytes into type safe, exhaustive types.
R ansiParserReadKey<R, CONTEXT>({
  required final int firstByte,
  required final int Function() nextByte,
  required final KeyDelegate<R, CONTEXT> delegate,
  required final CONTEXT context,
}) {
  switch (firstByte) {
    // https://en.wikipedia.org/wiki/ASCII#Control_characters
    case $nul: // Null
      return delegate.nil(context);
    case $soh: // Start of header
      return delegate.startOfHeader(context);
    case $stx: // Start of text
      return delegate.startOfText(context);
    case $etx: // End of text
      return delegate.endOfText(context);
    case $eot: // End of transmission
      return delegate.endOfTransmission(context);
    case $enq: // Enquiry
      return delegate.enquiry(context);
    case $ack: // Acknowledgment
      return delegate.acknowledgment(context);
    case $bel: // Bell
      return delegate.bell(context);
    case $bs: // Backspace
      return delegate.backspace(context);
    case $ht: // Horizontal Tab
      return delegate.horizontalTab(context);
    case $lf: // Line feed
      return delegate.lineFeed(context);
    case $vt: // Vertical Tab
      return delegate.verticalTab(context);
    case $ff: // Form feed
      return delegate.formFeed(context);
    case $cr: // Carriage return
      return delegate.carriageReturn(context);
    case $so: // Shift out
      return delegate.shiftOut(context);
    case $si: // Shift in
      return delegate.shiftIn(context);
    case $dle: // Data link escape
      return delegate.dataLinkEscape(context);
    case $dc1: // Device control 1
      return delegate.deviceControl1(context);
    case $dc2: // Device control 2
      return delegate.deviceControl2(context);
    case $dc3: // Device control 3
      return delegate.deviceControl3(context);
    case $dc4: // Device control 4
      return delegate.deviceControl4(context);
    case $nak: // Negative Acknowledgment
      return delegate.negativeAcknowledgment(context);
    case $syn: // Synchronous idle
      return delegate.syncIdle(context);
    case $etb: // End of Transmission Block
      return delegate.endOfTransmissionBlock(context);
    case $can: // Cancel
      return delegate.cancel(context);
    case $em: // End of Medium
      return delegate.endOfMedium(context);
    case $sub: // Substitute
      return delegate.substitute(context);
    case _ansiEscapeByte:
      switch (nextByte()) {
        case _stdinEndOfFileIndicator:
          return delegate.escapeEOF(context);
        case $del:
          return delegate.escapeDelete(context);
        case ansiBracketByte:
          switch (nextByte()) {
            case _stdinEndOfFileIndicator:
              return delegate.escapeAnsiBracketEOF(context);
            case ansiCursorUpNameByte:
              return delegate.escapeAnsiBracketUp(context);
            case ansiCursorDownNameByte:
              return delegate.escapeAnsiBracketDown(context);
            case ansiCursorForwardNameByte:
              return delegate.escapeAnsiBracketForward(context);
            case ansiCursorBackNameByte:
              return delegate.escapeAnsiBracketBackward(context);
            case ansiCharHomeByte:
              return delegate.escapeAnsiBracketHome(context);
            case ansiCharEndByte:
              return delegate.escapeAnsiBracketEnd(context);
            case $1:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket1EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket1Tilde(context);
                default:
                  return delegate.escapeAnsiBracket1Default(context);
              }
            case $3:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket3EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket3Tilde(context);
                default:
                  return delegate.escapeAnsiBracket3Default(context);
              }
            case $4:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket4EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket4Tilde(context);
                default:
                  return delegate.escapeAnsiBracket4Default(context);
              }
            case $5:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket5EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket5Tilde(context);
                default:
                  return delegate.escapeAnsiBracket5Default(context);
              }
            case $6:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket6EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket6Tilde(context);
                default:
                  return delegate.escapeAnsiBracket6Default(context);
              }
            case $7:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket7EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket7Tilde(context);
                default:
                  return delegate.escapeAnsiBracket7Default(context);
              }
            case $8:
              switch (nextByte()) {
                case _stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket8EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket8Tilde(context);
                default:
                  return delegate.escapeAnsiBracket8Default(context);
              }
          }
          return delegate.escapeAnsiBracketDefault(context);
        case ansiCommandOPrefixByte:
          switch (nextByte()) {
            case _stdinEndOfFileIndicator:
              return delegate.escapeAnsiOEOF(context);
            case ansiCharHomeByte:
              return delegate.escapeAnsiOHome(context);
            case ansiCharEndByte:
              return delegate.escapeAnsiOEnd(context);
            case $P:
              return delegate.escapeAnsiOP(context);
            case $Q:
              return delegate.escapeAnsiOQ(context);
            case $R:
              return delegate.escapeAnsiOR(context);
            case $S:
              return delegate.escapeAnsiOS(context);
            default:
              return delegate.escapeAnsiODefault(context);
          }
        case ansiCharWordLeftByte:
          return delegate.escapeAnsib(context);
        case ansiCharWordRightByte:
          return delegate.escapeAnsif(context);
        default:
          return delegate.escapeAnsiDefault(context);
      }
    case $fs: // File Separator
      return delegate.fileSeparator(context);
    case $gs: // Group Separator
      return delegate.groupSeparator(context);
    case $rs: // Record Separator
      return delegate.recordSeparator(context);
    case $us: // Unit Separator
      return delegate.unitSeparator(context);
    case $space: // ' '
      return delegate.space(context);
    case $exclamation: // !
      return delegate.exclamation(context);
    case $double_quote: // "
      return delegate.doubleQuote(context);
    case $hash: // #
      return delegate.hash(context);
    case $$: // $
      return delegate.dollar(context);
    case $percent: // %
      return delegate.percent(context);
    case $ampersand: // &
      return delegate.ampersand(context);
    case $single_quote: // '
      return delegate.singleQuote(context);
    case $lparen: // (
      return delegate.lparen(context);
    case $rparen: // )
      return delegate.rparen(context);
    case $asterisk: // *
      return delegate.asterisk(context);
    case $plus: // +
      return delegate.plus(context);
    case $comma: // ,
      return delegate.comma(context);
    case $minus: // -
      return delegate.minus(context);
    case $dot: // .
      return delegate.dot(context);
    case $slash: // /
      return delegate.slash(context);
    case $0: // 0
      return delegate.zero(context);
    case $1: // 1
      return delegate.one(context);
    case $2: // 2
      return delegate.two(context);
    case $3: // 3
      return delegate.three(context);
    case $4: // 4
      return delegate.four(context);
    case $5: // 5
      return delegate.five(context);
    case $6: // 6
      return delegate.six(context);
    case $7: // 7
      return delegate.seven(context);
    case $8: // 8
      return delegate.eight(context);
    case $9: // 9
      return delegate.nine(context);
    case $colon: // :
      return delegate.colon(context);
    case $semicolon: // ;
      return delegate.semicolon(context);
    case $lt: // <
      return delegate.lt(context);
    case $equal: // =
      return delegate.equal(context);
    case $gt: // >
      return delegate.gt(context);
    case $question: // ?
      return delegate.question(context);
    case $at: // @
      return delegate.at(context);
    case $A: // A
      return delegate.capA(context);
    case $B: // B
      return delegate.capB(context);
    case $C: // C
      return delegate.capC(context);
    case $D: // D
      return delegate.capD(context);
    case $E: // E
      return delegate.capE(context);
    case $F: // F
      return delegate.capF(context);
    case $G: // G
      return delegate.capG(context);
    case $H: // H
      return delegate.capH(context);
    case $I: // I
      return delegate.capI(context);
    case $J: // J
      return delegate.capJ(context);
    case $K: // K
      return delegate.capK(context);
    case $L: // L
      return delegate.capL(context);
    case $M: // M
      return delegate.capM(context);
    case $N: // N
      return delegate.capN(context);
    case $O: // O
      return delegate.capO(context);
    case $P: // P
      return delegate.capP(context);
    case $Q: // Q
      return delegate.capQ(context);
    case $R: // R
      return delegate.capR(context);
    case $S: // S
      return delegate.capS(context);
    case $T: // T
      return delegate.capT(context);
    case $U: // U
      return delegate.capU(context);
    case $V: // V
      return delegate.capV(context);
    case $W: // W
      return delegate.capW(context);
    case $X: // X
      return delegate.capX(context);
    case $Y: // Y
      return delegate.capY(context);
    case $Z: // Z
      return delegate.capZ(context);
    case $lbracket: // [
      return delegate.lBra(context);
    case $backslash: // \
      return delegate.backslash(context);
    case $rbracket: // ]
      return delegate.rBra(context);
    case $caret: // ^
      return delegate.caret(context);
    case $underscore: // _
      return delegate.underscore(context);
    case $backquote: // `
      return delegate.backquote(context);
    case $a: // a
      return delegate.lowerA(context);
    case $b: // b
      return delegate.lowerB(context);
    case $c: // c
      return delegate.lowerC(context);
    case $d: // d
      return delegate.lowerD(context);
    case $e: // e
      return delegate.lowerE(context);
    case $f: // f
      return delegate.lowerF(context);
    case $g: // g
      return delegate.lowerG(context);
    case $h: // h
      return delegate.lowerH(context);
    case $i: // i
      return delegate.lowerI(context);
    case $j: // j
      return delegate.lowerJ(context);
    case $k: // k
      return delegate.lowerK(context);
    case $l: // l
      return delegate.lowerL(context);
    case $m: // m
      return delegate.lowerM(context);
    case $n: // n
      return delegate.lowerN(context);
    case $o: // o
      return delegate.lowerO(context);
    case $p: // p
      return delegate.lowerP(context);
    case $q: // q
      return delegate.lowerQ(context);
    case $r: // r
      return delegate.lowerR(context);
    case $s: // s
      return delegate.lowerS(context);
    case $t: // t
      return delegate.lowerT(context);
    case $u: // u
      return delegate.lowerU(context);
    case $v: // v
      return delegate.lowerV(context);
    case $w: // w
      return delegate.lowerW(context);
    case $x: // x
      return delegate.lowerX(context);
    case $y: // y
      return delegate.lowerY(context);
    case $z: // z
      return delegate.lowerZ(context);
    case $lbrace: // {
      return delegate.lBrace(context);
    case $bar: // |
      return delegate.bar(context);
    case $rbrace: // }
      return delegate.rBrace(context);
    case $tilde: // ~
      return delegate.tilde(context);
    case $del:
      return delegate.del(context);
    default:
      // https://www.torsten-horn.de/techdocs/ascii.htm
      return delegate.extended(context);
  }
}

/// What integer indicates that the end of a file has been reached?
const int _stdinEndOfFileIndicator = -1;

/// What is the size of a byte?
const int _byteSize = 0xff;

/// What byte indicates an asci escape sequence?
const int _ansiEscapeByte = 0x1B;

/// What byte, that comes after the escape
/// character byte indicates an ansi escape sequence?
const int ansiBracketByte = 0x5B;

const int ansiCursorUpNameByte = 0x41;

const int ansiCursorDownNameByte = 0x42;

const int ansiCursorForwardNameByte = 0x43;

const int ansiCursorBackNameByte = 0x44;

const int ansiCommandOPrefixByte = 0x4F;

const int ansiCharEndByte = 0x46;

const int ansiCharHomeByte = 0x48;

const int ansiCharWordRightByte = 0x66;

const int ansiCharWordLeftByte = 0x62;

/// This decouples the parser from the representation of the keys.
abstract class KeyDelegate<T, CONTEXT> {
  T nil(final CONTEXT context);

  T startOfHeader(final CONTEXT context);

  T startOfText(final CONTEXT context);

  T endOfText(final CONTEXT context);

  T endOfTransmission(final CONTEXT context);

  T enquiry(final CONTEXT context);

  T acknowledgment(final CONTEXT context);

  T bell(final CONTEXT context);

  T backspace(final CONTEXT context);

  T horizontalTab(final CONTEXT context);

  T lineFeed(final CONTEXT context);

  T verticalTab(final CONTEXT context);

  T formFeed(final CONTEXT context);

  T carriageReturn(final CONTEXT context);

  T shiftOut(final CONTEXT context);

  T shiftIn(final CONTEXT context);

  T dataLinkEscape(final CONTEXT context);

  T deviceControl1(final CONTEXT context);

  T deviceControl2(final CONTEXT context);

  T deviceControl3(final CONTEXT context);

  T deviceControl4(final CONTEXT context);

  T negativeAcknowledgment(final CONTEXT context);

  T syncIdle(final CONTEXT context);

  T endOfTransmissionBlock(final CONTEXT context);

  T cancel(final CONTEXT context);

  T endOfMedium(final CONTEXT context);

  T substitute(final CONTEXT context);

  T escapeEOF(final CONTEXT context);

  T escapeDelete(final CONTEXT context);

  T escapeAnsiBracketEOF(final CONTEXT context);

  T escapeAnsiBracketUp(final CONTEXT context);

  T escapeAnsiBracketDown(final CONTEXT context);

  T escapeAnsiBracketForward(final CONTEXT context);

  T escapeAnsiBracketBackward(final CONTEXT context);

  T escapeAnsiBracketHome(final CONTEXT context);

  T escapeAnsiBracketEnd(final CONTEXT context);

  T escapeAnsiBracket1EOF(final CONTEXT context);

  T escapeAnsiBracket1Tilde(final CONTEXT context);

  T escapeAnsiBracket1Default(final CONTEXT context);

  T escapeAnsiBracket3EOF(final CONTEXT context);

  T escapeAnsiBracket3Tilde(final CONTEXT context);

  T escapeAnsiBracket3Default(final CONTEXT context);

  T escapeAnsiBracket4EOF(final CONTEXT context);

  T escapeAnsiBracket4Tilde(final CONTEXT context);

  T escapeAnsiBracket4Default(final CONTEXT context);

  T escapeAnsiBracket5EOF(final CONTEXT context);

  T escapeAnsiBracket5Tilde(final CONTEXT context);

  T escapeAnsiBracket5Default(final CONTEXT context);

  T escapeAnsiBracket6EOF(final CONTEXT context);

  T escapeAnsiBracket6Tilde(final CONTEXT context);

  T escapeAnsiBracket6Default(final CONTEXT context);

  T escapeAnsiBracket7EOF(final CONTEXT context);

  T escapeAnsiBracket7Tilde(final CONTEXT context);

  T escapeAnsiBracket7Default(final CONTEXT context);

  T escapeAnsiBracket8EOF(final CONTEXT context);

  T escapeAnsiBracket8Tilde(final CONTEXT context);

  T escapeAnsiBracket8Default(final CONTEXT context);

  T escapeAnsiBracketDefault(final CONTEXT context);

  T escapeAnsiOEOF(final CONTEXT context);

  T escapeAnsiOHome(final CONTEXT context);

  T escapeAnsiOEnd(final CONTEXT context);

  T escapeAnsiOP(final CONTEXT context);

  T escapeAnsiOQ(final CONTEXT context);

  T escapeAnsiOR(final CONTEXT context);

  T escapeAnsiOS(final CONTEXT context);

  T escapeAnsiODefault(final CONTEXT context);

  T escapeAnsib(final CONTEXT context);

  T escapeAnsif(final CONTEXT context);

  T escapeAnsiDefault(final CONTEXT context);

  T fileSeparator(final CONTEXT context);

  T groupSeparator(final CONTEXT context);

  T recordSeparator(final CONTEXT context);

  T unitSeparator(final CONTEXT context);

  T space(final CONTEXT context);

  T exclamation(final CONTEXT context);

  T doubleQuote(final CONTEXT context);

  T hash(final CONTEXT context);

  T dollar(final CONTEXT context);

  T percent(final CONTEXT context);

  T ampersand(final CONTEXT context);

  T singleQuote(final CONTEXT context);

  T lparen(final CONTEXT context);

  T rparen(final CONTEXT context);

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

  T capA(final CONTEXT context);

  T capB(final CONTEXT context);

  T capC(final CONTEXT context);

  T capD(final CONTEXT context);

  T capE(final CONTEXT context);

  T capF(final CONTEXT context);

  T capG(final CONTEXT context);

  T capH(final CONTEXT context);

  T capI(final CONTEXT context);

  T capJ(final CONTEXT context);

  T capK(final CONTEXT context);

  T capL(final CONTEXT context);

  T capM(final CONTEXT context);

  T capN(final CONTEXT context);

  T capO(final CONTEXT context);

  T capP(final CONTEXT context);

  T capQ(final CONTEXT context);

  T capR(final CONTEXT context);

  T capS(final CONTEXT context);

  T capT(final CONTEXT context);

  T capU(final CONTEXT context);

  T capV(final CONTEXT context);

  T capW(final CONTEXT context);

  T capX(final CONTEXT context);

  T capY(final CONTEXT context);

  T capZ(final CONTEXT context);

  T lBra(final CONTEXT context);

  T backslash(final CONTEXT context);

  T rBra(final CONTEXT context);

  T caret(final CONTEXT context);

  T underscore(final CONTEXT context);

  T backquote(final CONTEXT context);

  T lowerA(final CONTEXT context);

  T lowerB(final CONTEXT context);

  T lowerC(final CONTEXT context);

  T lowerD(final CONTEXT context);

  T lowerE(final CONTEXT context);

  T lowerF(final CONTEXT context);

  T lowerG(final CONTEXT context);

  T lowerH(final CONTEXT context);

  T lowerI(final CONTEXT context);

  T lowerJ(final CONTEXT context);

  T lowerK(final CONTEXT context);

  T lowerL(final CONTEXT context);

  T lowerM(final CONTEXT context);

  T lowerN(final CONTEXT context);

  T lowerO(final CONTEXT context);

  T lowerP(final CONTEXT context);

  T lowerQ(final CONTEXT context);

  T lowerR(final CONTEXT context);

  T lowerS(final CONTEXT context);

  T lowerT(final CONTEXT context);

  T lowerU(final CONTEXT context);

  T lowerV(final CONTEXT context);

  T lowerW(final CONTEXT context);

  T lowerX(final CONTEXT context);

  T lowerY(final CONTEXT context);

  T lowerZ(final CONTEXT context);

  T lBrace(final CONTEXT context);

  T bar(final CONTEXT context);

  T rBrace(final CONTEXT context);

  T tilde(final CONTEXT context);

  T del(final CONTEXT context);

  T extended(final CONTEXT context);
}

// TODO have constant String chars for printable characters and use them everywhere instead of using string literals.
/// "Null character" control character.
const int $nul = 0x00;

/// "Start of Header" control character.
const int $soh = 0x01;

/// "Start of Text" control character.
const int $stx = 0x02;

/// "End of Text" control character.
const int $etx = 0x03;

/// "End of Transmission" control character.
const int $eot = 0x04;

/// "Enquiry" control character.
const int $enq = 0x05;

/// "Acknowledgment" control character.
const int $ack = 0x06;

/// "Bell" control character.
const int $bel = 0x07;

/// "Backspace" control character.
const int $bs = 0x08;

/// "Horizontal Tab" control character.
const int $ht = 0x09;

/// "Line feed" control character.
const int $lf = 0x0A;

/// "Vertical Tab" control character.
const int $vt = 0x0B;

/// "Form feed" control character.
const int $ff = 0x0C;

/// "Carriage return" control character.
const int $cr = 0x0D;

/// "Shift Out" control character.
const int $so = 0x0E;

/// "Shift In" control character.
const int $si = 0x0F;

/// "Data Link Escape" control character.
const int $dle = 0x10;

/// "Device Control 1" control character (oft. XON).
const int $dc1 = 0x11;

/// "Device Control 2" control character.
const int $dc2 = 0x12;

/// "Device Control 3" control character (oft. XOFF).
const int $dc3 = 0x13;

/// "Device Control 4" control character.
const int $dc4 = 0x14;

/// "Negative Acknowledgment" control character.
const int $nak = 0x15;

/// "Synchronous idle" control character.
const int $syn = 0x16;

/// "End of Transmission Block" control character.
const int $etb = 0x17;

/// "Cancel" control character.
const int $can = 0x18;

/// "End of Medium" control character.
const int $em = 0x19;

/// "Substitute" control character.
const int $sub = 0x1A;

/// "Escape" control character.
const int $esc = 0x1B;

/// "File Separator" control character.
const int $fs = 0x1C;

/// "Group Separator" control character.
const int $gs = 0x1D;

/// "Record Separator" control character.
const int $rs = 0x1E;

/// "Unit Separator" control character.
const int $us = 0x1F;

/// "Delete" control character.
const int $del = 0x7F;

// Printable characters.

/// Space character.
const int $space = 0x20;

/// Character '!'.
const int $exclamation = 0x21;

/// Character '"'.
const int $double_quote = 0x22;

/// Character '#'.
const int $hash = 0x23;

/// Character '$'.
const int $$ = 0x24;

/// Character '$'.
const int $dollar = 0x24;

/// Character '%'.
const int $percent = 0x25;

/// Character '&'.
const int $ampersand = 0x26;

/// Character '''.
const int $single_quote = 0x27;

/// Character '('.
const int $lparen = 0x28;

/// Character ')'.
const int $rparen = 0x29;

/// Character '*'.
const int $asterisk = 0x2A;

/// Character '+'.
const int $plus = 0x2B;

/// Character ','.
const int $comma = 0x2C;

/// Character '-'.
const int $minus = 0x2D;

/// Character '.'.
const int $dot = 0x2E;

/// Character '/'.
const int $slash = 0x2F;

/// Character '0'.
const int $0 = 0x30;

/// Character '1'.
const int $1 = 0x31;

/// Character '2'.
const int $2 = 0x32;

/// Character '3'.
const int $3 = 0x33;

/// Character '4'.
const int $4 = 0x34;

/// Character '5'.
const int $5 = 0x35;

/// Character '6'.
const int $6 = 0x36;

/// Character '7'.
const int $7 = 0x37;

/// Character '8'.
const int $8 = 0x38;

/// Character '9'.
const int $9 = 0x39;

/// Character ':'.
const int $colon = 0x3A;

/// Character ';'.
const int $semicolon = 0x3B;

/// Character '<'.
const int $lt = 0x3C;

/// Character '<'.
const int $less_than = 0x3C;

/// Character '<'.
const int $langle = 0x3C;

/// Character '<'.
const int $open_angle = 0x3C;

/// Character '='.
const int $equal = 0x3D;

/// Character '>'.
const int $gt = 0x3E;

/// Character '>'.
const int $greater_than = 0x3E;

/// Character '>'.
const int $rangle = 0x3E;

/// Character '>'.
const int $close_angle = 0x3E;

/// Character '?'.
const int $question = 0x3F;

/// Character '@'.
const int $at = 0x40;

/// Character 'A'.
const int $A = 0x41;

/// Character 'B'.
const int $B = 0x42;

/// Character 'C'.
const int $C = 0x43;

/// Character 'D'.
const int $D = 0x44;

/// Character 'E'.
const int $E = 0x45;

/// Character 'F'.
const int $F = 0x46;

/// Character 'G'.
const int $G = 0x47;

/// Character 'H'.
const int $H = 0x48;

/// Character 'I'.
const int $I = 0x49;

/// Character 'J'.
const int $J = 0x4A;

/// Character 'K'.
const int $K = 0x4B;

/// Character 'L'.
const int $L = 0x4C;

/// Character 'M'.
const int $M = 0x4D;

/// Character 'N'.
const int $N = 0x4E;

/// Character 'O'.
const int $O = 0x4F;

/// Character 'P'.
const int $P = 0x50;

/// Character 'Q'.
const int $Q = 0x51;

/// Character 'R'.
const int $R = 0x52;

/// Character 'S'.
const int $S = 0x53;

/// Character 'T'.
const int $T = 0x54;

/// Character 'U'.
const int $U = 0x55;

/// Character 'V'.
const int $V = 0x56;

/// Character 'W'.
const int $W = 0x57;

/// Character 'X'.
const int $X = 0x58;

/// Character 'Y'.
const int $Y = 0x59;

/// Character 'Z'.
const int $Z = 0x5A;

/// Character '['.
const int $lbracket = 0x5B;

/// Character '['.
const int $open_bracket = 0x5B;

/// Character '\'.
const int $backslash = 0x5C;

/// Character ']'.
const int $rbracket = 0x5D;

/// Character ']'.
const int $close_bracket = 0x5D;

/// Character '^'.
const int $circumflex = 0x5E;

/// Character '^'.
const int $caret = 0x5E;

/// Character '^'.
const int $hat = 0x5E;

/// Character '_'.
const int $_ = 0x5F;

/// Character '_'.
const int $underscore = 0x5F;

/// Character '_'.
const int $underline = 0x5F;

/// Character '`'.
const int $backquote = 0x60;

/// Character '`'.
const int $grave = 0x60;

/// Character 'a'.
const int $a = 0x61;

/// Character 'b'.
const int $b = 0x62;

/// Character 'c'.
const int $c = 0x63;

/// Character 'd'.
const int $d = 0x64;

/// Character 'e'.
const int $e = 0x65;

/// Character 'f'.
const int $f = 0x66;

/// Character 'g'.
const int $g = 0x67;

/// Character 'h'.
const int $h = 0x68;

/// Character 'i'.
const int $i = 0x69;

/// Character 'j'.
const int $j = 0x6A;

/// Character 'k'.
const int $k = 0x6B;

/// Character 'l'.
const int $l = 0x6C;

/// Character 'm'.
const int $m = 0x6D;

/// Character 'n'.
const int $n = 0x6E;

/// Character 'o'.
const int $o = 0x6F;

/// Character 'p'.
const int $p = 0x70;

/// Character 'q'.
const int $q = 0x71;

/// Character 'r'.
const int $r = 0x72;

/// Character 's'.
const int $s = 0x73;

/// Character 't'.
const int $t = 0x74;

/// Character 'u'.
const int $u = 0x75;

/// Character 'v'.
const int $v = 0x76;

/// Character 'w'.
const int $w = 0x77;

/// Character 'x'.
const int $x = 0x78;

/// Character 'y'.
const int $y = 0x79;

/// Character 'z'.
const int $z = 0x7A;

/// Character '{'.
const int $lbrace = 0x7B;

/// Character '{'.
const int $open_brace = 0x7B;

/// Character '|'.
const int $pipe = 0x7C;

/// Character '|'.
const int $bar = 0x7C;

/// Character '}'.
const int $rbrace = 0x7D;

/// Character '}'.
const int $close_brace = 0x7D;

/// Character '~'.
const int $tilde = 0x7E;
