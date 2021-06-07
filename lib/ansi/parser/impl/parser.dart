import '../../../ansi/spec/ascii.dart';
import '../../../ansi/spec/bracket.dart';
import '../../../ansi/spec/end_of_file.dart';
import '../../../ansi/spec/escape.dart';
import '../../../ansi/spec/lib.dart';
import '../../../ansi/spec/sizes.dart';
import '../../../console/impl/key.dart';
import '../../../console/interface/control_character.dart';
import '../../../console/interface/key.dart';
import '../interface/parser.dart';

class AnsiParserImpl implements AnsiParser {
  final AnsiParserInputBuffer buffer;

  const AnsiParserImpl(this.buffer);

  @override
  Key readKey() {
    final firstValidByte = _readContinuousByte(buffer.readByte);
    return _readKey(firstValidByte, buffer.readByte);
  }
}

int _readContinuousByte(int Function() readByte) {
  var _readByte = 0;
  while (_readByte <= 0) {
    _readByte = readByte();
    if (_readByte < stdinEndOfFileIndicator) {
      throw ByteReadExceptionTooSmallImpl(_readByte);
    } else if (_readByte > byteSize) {
      // Let callers handle integers that are too big.
      return _readByte;
    }
  }
  return _readByte;
}

Key _readKey(int firstByte, int Function() nextByte) {
  switch (firstByte) {
    // https://en.wikipedia.org/wiki/ASCII#Control_characters
    case $nul: // Null
      return const KeyControlImpl(ControlCharacters.unknown);
    case $soh: // Start of header
      return const KeyControlImpl(ControlCharacters.ctrlA);
    case $stx: // Start of text
      return const KeyControlImpl(ControlCharacters.ctrlB);
    case $etx: // End of text
      return const KeyControlImpl(ControlCharacters.ctrlC);
    case $eot: // End of transmission
      return const KeyControlImpl(ControlCharacters.ctrlD);
    case $enq: // Enquiry
      return const KeyControlImpl(ControlCharacters.ctrlE);
    case $ack: // Acknowledgment
      return const KeyControlImpl(ControlCharacters.ctrlF);
    case $bel: // Bell
      return const KeyControlImpl(ControlCharacters.ctrlG);
    case $bs: // Backspace
      return const KeyControlImpl(ControlCharacters.ctrlH);
    case $ht: // Horizontal Tab
      return const KeyControlImpl(ControlCharacters.tab);
    case $lf: // Line feed
      return const KeyControlImpl(ControlCharacters.ctrlJ);
    case $vt: // Vertical Tab
      return const KeyControlImpl(ControlCharacters.ctrlK);
    case $ff: // Form feed
      return const KeyControlImpl(ControlCharacters.ctrlL);
    case $cr: // Carriage return
      return const KeyControlImpl(ControlCharacters.enter);
    case $so: // Shift out
      return const KeyControlImpl(ControlCharacters.ctrlN);
    case $si: // Shift in
      return const KeyControlImpl(ControlCharacters.ctrlO);
    case $dle: // Data link escape
      return const KeyControlImpl(ControlCharacters.ctrlP);
    case $dc1: // Device control 1
      return const KeyControlImpl(ControlCharacters.ctrlQ);
    case $dc2: // Device control 2
      return const KeyControlImpl(ControlCharacters.ctrlR);
    case $dc3: // Device control 3
      return const KeyControlImpl(ControlCharacters.ctrlS);
    case $dc4: // Device control 4
      return const KeyControlImpl(ControlCharacters.ctrlT);
    case $nak: // Negative Acknowledgment
      return const KeyControlImpl(ControlCharacters.ctrlU);
    case $syn: // Synchronous idle
      return const KeyControlImpl(ControlCharacters.ctrlV);
    case $etb: // End of Transmission Block
      return const KeyControlImpl(ControlCharacters.ctrlW);
    case $can: // Cancel
      return const KeyControlImpl(ControlCharacters.ctrlX);
    case $em: // End of Medium
      return const KeyControlImpl(ControlCharacters.ctrlY);
    case $sub: // Substitute
      return const KeyControlImpl(ControlCharacters.ctrlZ);
    case ansiEscapeByte:
      switch (nextByte()) {
        case stdinEndOfFileIndicator:
          return const KeyControlImpl(ControlCharacters.escape);
        case $del:
          return const KeyControlImpl(ControlCharacters.wordBackspace);
        case ansiBracketByte:
          switch (nextByte()) {
            case stdinEndOfFileIndicator:
              return const KeyControlImpl(ControlCharacters.escape);
            case AnsiStandardLib.cursorUpNameByte:
              return const KeyControlImpl(ControlCharacters.arrowUp);
            case AnsiStandardLib.cursorDownNameByte:
              return const KeyControlImpl(ControlCharacters.arrowDown);
            case AnsiStandardLib.cursorForwardNameByte:
              return const KeyControlImpl(ControlCharacters.arrowRight);
            case AnsiStandardLib.cursorBackNameByte:
              return const KeyControlImpl(ControlCharacters.arrowLeft);
            case AnsiStandardLib.charHomeByte:
              return const KeyControlImpl(ControlCharacters.home);
            case AnsiStandardLib.charEndByte:
              return const KeyControlImpl(ControlCharacters.end);
            case $1:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.home);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $3:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.delete);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $4:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.end);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $5:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.pageUp);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $6:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.pageDown);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $7:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.home);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
            case $8:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return const KeyControlImpl(ControlCharacters.escape);
                case $tilde:
                  return const KeyControlImpl(ControlCharacters.end);
                default:
                  return const KeyControlImpl(ControlCharacters.unknown);
              }
          }
          return const KeyControlImpl(ControlCharacters.unknown);
        case AnsiStandardLib.commandOPrefixByte:
          switch (nextByte()) {
            case stdinEndOfFileIndicator:
              return const KeyControlImpl(ControlCharacters.escape);
            case AnsiStandardLib.charHomeByte:
              return const KeyControlImpl(ControlCharacters.home);
            case AnsiStandardLib.charEndByte:
              return const KeyControlImpl(ControlCharacters.end);
            case $P:
              return const KeyControlImpl(ControlCharacters.F1);
            case $Q:
              return const KeyControlImpl(ControlCharacters.F2);
            case $R:
              return const KeyControlImpl(ControlCharacters.F3);
            case $S:
              return const KeyControlImpl(ControlCharacters.F4);
            default:
              throw Exception("Unexpected O command");
          }
        case AnsiStandardLib.charWordLeftByte:
          return const KeyControlImpl(ControlCharacters.wordLeft);
        case AnsiStandardLib.charWordRightByte:
          return const KeyControlImpl(ControlCharacters.wordRight);
        default:
          return const KeyControlImpl(ControlCharacters.unknown);
      }
    case $fs: // File Separator
      return const KeyControlImpl(ControlCharacters.unknown);
    case $gs: // Group Separator
      return const KeyControlImpl(ControlCharacters.unknown);
    case $rs: // Record Separator
      return const KeyControlImpl(ControlCharacters.unknown);
    case $us: // Unit Separator
      return const KeyControlImpl(ControlCharacters.unknown);
    case $space: // ' '
      return const KeyPrintableImpl(' ');
    case $exclamation: // !
      return const KeyPrintableImpl('!');
    case $double_quote: // "
      return const KeyPrintableImpl('"');
    case $hash: // #
      return const KeyPrintableImpl("#");
    case $$: // $
      return const KeyPrintableImpl(r"$");
    case $percent: // %
      return const KeyPrintableImpl("%");
    case $ampersand: // &
      return const KeyPrintableImpl("&");
    case $single_quote: // '
      return const KeyPrintableImpl("'");
    case $lparen: // (
      return const KeyPrintableImpl("(");
    case $rparen: // )
      return const KeyPrintableImpl(")");
    case $asterisk: // *
      return const KeyPrintableImpl("*");
    case $plus: // +
      return const KeyPrintableImpl("+");
    case $comma: // ,
      return const KeyPrintableImpl(",");
    case $minus: // -
      return const KeyPrintableImpl("-");
    case $dot: // .
      return const KeyPrintableImpl(".");
    case $slash: // /
      return const KeyPrintableImpl("/");
    case $0: // 0
      return const KeyPrintableImpl("0");
    case $1: // 1
      return const KeyPrintableImpl("1");
    case $2: // 2
      return const KeyPrintableImpl("2");
    case $3: // 3
      return const KeyPrintableImpl("3");
    case $4: // 4
      return const KeyPrintableImpl("4");
    case $5: // 5
      return const KeyPrintableImpl("5");
    case $6: // 6
      return const KeyPrintableImpl("6");
    case $7: // 7
      return const KeyPrintableImpl("7");
    case $8: // 8
      return const KeyPrintableImpl("8");
    case $9: // 9
      return const KeyPrintableImpl("9");
    case $colon: // :
      return const KeyPrintableImpl(":");
    case $semicolon: // ;
      return const KeyPrintableImpl(";");
    case $lt: // <
      return const KeyPrintableImpl("<");
    case $equal: // =
      return const KeyPrintableImpl("=");
    case $gt: // >
      return const KeyPrintableImpl(">");
    case $question: // ?
      return const KeyPrintableImpl("?");
    case $at: // @
      return const KeyPrintableImpl("@");
    case $A: // A
      return const KeyPrintableImpl("A");
    case $B: // B
      return const KeyPrintableImpl("B");
    case $C: // C
      return const KeyPrintableImpl("C");
    case $D: // D
      return const KeyPrintableImpl("D");
    case $E: // E
      return const KeyPrintableImpl("E");
    case $F: // F
      return const KeyPrintableImpl("F");
    case $G: // G
      return const KeyPrintableImpl("G");
    case $H: // H
      return const KeyPrintableImpl("H");
    case $I: // I
      return const KeyPrintableImpl("I");
    case $J: // J
      return const KeyPrintableImpl("J");
    case $K: // K
      return const KeyPrintableImpl("K");
    case $L: // L
      return const KeyPrintableImpl("L");
    case $M: // M
      return const KeyPrintableImpl("M");
    case $N: // N
      return const KeyPrintableImpl("N");
    case $O: // O
      return const KeyPrintableImpl("O");
    case $P: // P
      return const KeyPrintableImpl("P");
    case $Q: // Q
      return const KeyPrintableImpl("Q");
    case $R: // R
      return const KeyPrintableImpl("R");
    case $S: // S
      return const KeyPrintableImpl("S");
    case $T: // T
      return const KeyPrintableImpl("T");
    case $U: // U
      return const KeyPrintableImpl("U");
    case $V: // V
      return const KeyPrintableImpl("V");
    case $W: // W
      return const KeyPrintableImpl("W");
    case $X: // X
      return const KeyPrintableImpl("X");
    case $Y: // Y
      return const KeyPrintableImpl("Y");
    case $Z: // Z
      return const KeyPrintableImpl("Z");
    case $lbracket: // [
      return const KeyPrintableImpl("[");
    case $backslash: // \
      return const KeyPrintableImpl(r"\");
    case $rbracket: // ]
      return const KeyPrintableImpl("]");
    case $caret: // ^
      return const KeyPrintableImpl("^");
    case $underscore: // _
      return const KeyPrintableImpl("_");
    case $backquote: // `
      return const KeyPrintableImpl("`");
    case $a: // a
      return const KeyPrintableImpl("a");
    case $b: // b
      return const KeyPrintableImpl("b");
    case $c: // c
      return const KeyPrintableImpl("c");
    case $d: // d
      return const KeyPrintableImpl("d");
    case $e: // e
      return const KeyPrintableImpl("e");
    case $f: // f
      return const KeyPrintableImpl("f");
    case $g: // g
      return const KeyPrintableImpl("g");
    case $h: // h
      return const KeyPrintableImpl("h");
    case $i: // i
      return const KeyPrintableImpl("i");
    case $j: // j
      return const KeyPrintableImpl("j");
    case $k: // k
      return const KeyPrintableImpl("k");
    case $l: // l
      return const KeyPrintableImpl("l");
    case $m: // m
      return const KeyPrintableImpl("m");
    case $n: // n
      return const KeyPrintableImpl("n");
    case $o: // o
      return const KeyPrintableImpl("o");
    case $p: // p
      return const KeyPrintableImpl("p");
    case $q: // q
      return const KeyPrintableImpl("q");
    case $r: // r
      return const KeyPrintableImpl("r");
    case $s: // s
      return const KeyPrintableImpl("s");
    case $t: // t
      return const KeyPrintableImpl("t");
    case $u: // u
      return const KeyPrintableImpl("u");
    case $v: // v
      return const KeyPrintableImpl("v");
    case $w: // w
      return const KeyPrintableImpl("w");
    case $x: // x
      return const KeyPrintableImpl("x");
    case $y: // y
      return const KeyPrintableImpl("y");
    case $z: // z
      return const KeyPrintableImpl("z");
    case $lbrace: // {
      return const KeyPrintableImpl("{");
    case $bar: // |
      return const KeyPrintableImpl("|");
    case $rbrace: // }
      return const KeyPrintableImpl("}");
    case $tilde: // ~
      return const KeyPrintableImpl("~");
    case $del:
      return const KeyControlImpl(ControlCharacters.backspace);
    default:
      // https://www.torsten-horn.de/techdocs/ascii.htm
      return KeyPrintableImpl(String.fromCharCode(firstByte));
  }
}

class ByteReadExceptionTooSmallImpl implements ByteReadExceptionTooSmall {
  @override
  final int value;

  const ByteReadExceptionTooSmallImpl(this.value);

  @override
  String get message => "Read invalid byte. Number was below ${stdinEndOfFileIndicator} $value";

  @override
  String toString() => message;
}
