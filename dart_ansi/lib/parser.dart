import 'ansi.dart';
import 'ascii.dart';

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
    case ansiEscapeByte:
      switch (nextByte()) {
        case stdinEndOfFileIndicator:
          return delegate.escapeEOF(context);
        case $del:
          return delegate.escapeDelete(context);
        case ansiBracketByte:
          switch (nextByte()) {
            case stdinEndOfFileIndicator:
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
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket1EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket1Tilde(context);
                default:
                  return delegate.escapeAnsiBracket1Default(context);
              }
            case $3:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket3EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket3Tilde(context);
                default:
                  return delegate.escapeAnsiBracket3Default(context);
              }
            case $4:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket4EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket4Tilde(context);
                default:
                  return delegate.escapeAnsiBracket4Default(context);
              }
            case $5:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket5EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket5Tilde(context);
                default:
                  return delegate.escapeAnsiBracket5Default(context);
              }
            case $6:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket6EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket6Tilde(context);
                default:
                  return delegate.escapeAnsiBracket6Default(context);
              }
            case $7:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
                  return delegate.escapeAnsiBracket7EOF(context);
                case $tilde:
                  return delegate.escapeAnsiBracket7Tilde(context);
                default:
                  return delegate.escapeAnsiBracket7Default(context);
              }
            case $8:
              switch (nextByte()) {
                case stdinEndOfFileIndicator:
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
            case stdinEndOfFileIndicator:
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

/// Builds all keys that [ansiParserReadKey] supports.
/// This decouples the parser from the representation of the keys.
abstract class KeyDelegate<T, CONTEXT> {
  T nil(CONTEXT context); //
  T startOfHeader(CONTEXT context); //
  T startOfText(CONTEXT context); //
  T endOfText(CONTEXT context); //
  T endOfTransmission(CONTEXT context); //
  T enquiry(CONTEXT context); //
  T acknowledgment(CONTEXT context); //
  T bell(CONTEXT context); //
  T backspace(CONTEXT context); //
  T horizontalTab(CONTEXT context); //
  T lineFeed(CONTEXT context); //
  T verticalTab(CONTEXT context); //
  T formFeed(CONTEXT context); //
  T carriageReturn(CONTEXT context); //
  T shiftOut(CONTEXT context); //
  T shiftIn(CONTEXT context); //
  T dataLinkEscape(CONTEXT context); //
  T deviceControl1(CONTEXT context); //
  T deviceControl2(CONTEXT context); //
  T deviceControl3(CONTEXT context); //
  T deviceControl4(CONTEXT context); //
  T negativeAcknowledgment(CONTEXT context); //
  T syncIdle(CONTEXT context); //
  T endOfTransmissionBlock(CONTEXT context); //
  T cancel(CONTEXT context); //
  T endOfMedium(CONTEXT context); //
  T substitute(CONTEXT context); //
  T escapeEOF(CONTEXT context); //
  T escapeDelete(CONTEXT context); //
  T escapeAnsiBracketEOF(CONTEXT context); //
  T escapeAnsiBracketUp(CONTEXT context); //
  T escapeAnsiBracketDown(CONTEXT context); //
  T escapeAnsiBracketForward(CONTEXT context); //
  T escapeAnsiBracketBackward(CONTEXT context); //
  T escapeAnsiBracketHome(CONTEXT context); //
  T escapeAnsiBracketEnd(CONTEXT context); //
  T escapeAnsiBracket1EOF(CONTEXT context); //
  T escapeAnsiBracket1Tilde(CONTEXT context); //
  T escapeAnsiBracket1Default(CONTEXT context); //
  T escapeAnsiBracket3EOF(CONTEXT context); //
  T escapeAnsiBracket3Tilde(CONTEXT context); //
  T escapeAnsiBracket3Default(CONTEXT context); //
  T escapeAnsiBracket4EOF(CONTEXT context); //
  T escapeAnsiBracket4Tilde(CONTEXT context); //
  T escapeAnsiBracket4Default(CONTEXT context); //
  T escapeAnsiBracket5EOF(CONTEXT context); //
  T escapeAnsiBracket5Tilde(CONTEXT context); //
  T escapeAnsiBracket5Default(CONTEXT context); //
  T escapeAnsiBracket6EOF(CONTEXT context); //
  T escapeAnsiBracket6Tilde(CONTEXT context); //
  T escapeAnsiBracket6Default(CONTEXT context); //
  T escapeAnsiBracket7EOF(CONTEXT context); //
  T escapeAnsiBracket7Tilde(CONTEXT context); //
  T escapeAnsiBracket7Default(CONTEXT context); //
  T escapeAnsiBracket8EOF(CONTEXT context); //
  T escapeAnsiBracket8Tilde(CONTEXT context); //
  T escapeAnsiBracket8Default(CONTEXT context); //
  T escapeAnsiBracketDefault(CONTEXT context); //
  T escapeAnsiOEOF(CONTEXT context); //
  T escapeAnsiOHome(CONTEXT context); //
  T escapeAnsiOEnd(CONTEXT context); //
  T escapeAnsiOP(CONTEXT context); //
  T escapeAnsiOQ(CONTEXT context); //
  T escapeAnsiOR(CONTEXT context); //
  T escapeAnsiOS(CONTEXT context); //
  T escapeAnsiODefault(CONTEXT context); //
  T escapeAnsib(CONTEXT context); //
  T escapeAnsif(CONTEXT context); //
  T escapeAnsiDefault(CONTEXT context); //
  T fileSeparator(CONTEXT context); //
  T groupSeparator(CONTEXT context); //
  T recordSeparator(CONTEXT context); //
  T unitSeparator(CONTEXT context); //
  T space(CONTEXT context); //
  T exclamation(CONTEXT context); //
  T doubleQuote(CONTEXT context); //
  T hash(CONTEXT context); //
  T dollar(CONTEXT context); //
  T percent(CONTEXT context); //
  T ampersand(CONTEXT context); //
  T singleQuote(CONTEXT context); //
  T lparen(CONTEXT context); //
  T rparen(CONTEXT context); //
  T asterisk(CONTEXT context); //
  T plus(CONTEXT context); //
  T comma(CONTEXT context); //
  T minus(CONTEXT context); //
  T dot(CONTEXT context); //
  T slash(CONTEXT context); //
  T zero(CONTEXT context); //
  T one(CONTEXT context); //
  T two(CONTEXT context); //
  T three(CONTEXT context); //
  T four(CONTEXT context); //
  T five(CONTEXT context); //
  T six(CONTEXT context); //
  T seven(CONTEXT context); //
  T eight(CONTEXT context); //
  T nine(CONTEXT context); //
  T colon(CONTEXT context); //
  T semicolon(CONTEXT context); //
  T lt(CONTEXT context); //
  T equal(CONTEXT context); //
  T gt(CONTEXT context); //
  T question(CONTEXT context); //
  T at(CONTEXT context); //
  T capA(CONTEXT context); //
  T capB(CONTEXT context); //
  T capC(CONTEXT context); //
  T capD(CONTEXT context); //
  T capE(CONTEXT context); //
  T capF(CONTEXT context); //
  T capG(CONTEXT context); //
  T capH(CONTEXT context); //
  T capI(CONTEXT context); //
  T capJ(CONTEXT context); //
  T capK(CONTEXT context); //
  T capL(CONTEXT context); //
  T capM(CONTEXT context); //
  T capN(CONTEXT context); //
  T capO(CONTEXT context); //
  T capP(CONTEXT context); //
  T capQ(CONTEXT context); //
  T capR(CONTEXT context); //
  T capS(CONTEXT context); //
  T capT(CONTEXT context); //
  T capU(CONTEXT context); //
  T capV(CONTEXT context); //
  T capW(CONTEXT context); //
  T capX(CONTEXT context); //
  T capY(CONTEXT context); //
  T capZ(CONTEXT context); //
  T lBra(CONTEXT context); //
  T backslash(CONTEXT context); //
  T rBra(CONTEXT context); //
  T caret(CONTEXT context); //
  T underscore(CONTEXT context); //
  T backquote(CONTEXT context); //
  T lowerA(CONTEXT context); //
  T lowerB(CONTEXT context); //
  T lowerC(CONTEXT context); //
  T lowerD(CONTEXT context); //
  T lowerE(CONTEXT context); //
  T lowerF(CONTEXT context); //
  T lowerG(CONTEXT context); //
  T lowerH(CONTEXT context); //
  T lowerI(CONTEXT context); //
  T lowerJ(CONTEXT context); //
  T lowerK(CONTEXT context); //
  T lowerL(CONTEXT context); //
  T lowerM(CONTEXT context); //
  T lowerN(CONTEXT context); //
  T lowerO(CONTEXT context); //
  T lowerP(CONTEXT context); //
  T lowerQ(CONTEXT context); //
  T lowerR(CONTEXT context); //
  T lowerS(CONTEXT context); //
  T lowerT(CONTEXT context); //
  T lowerU(CONTEXT context); //
  T lowerV(CONTEXT context); //
  T lowerW(CONTEXT context); //
  T lowerX(CONTEXT context); //
  T lowerY(CONTEXT context); //
  T lowerZ(CONTEXT context); //
  T lBrace(CONTEXT context); //
  T bar(CONTEXT context); //
  T rBrace(CONTEXT context); //
  T tilde(CONTEXT context); //
  T del(CONTEXT context); //
  T extended(CONTEXT context); //
}
