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

/// This decouples the parser from the representation of the keys.
abstract class KeyDelegate<T, CONTEXT> {
  T nil(final CONTEXT context); //
  T startOfHeader(final CONTEXT context); //
  T startOfText(final CONTEXT context); //
  T endOfText(final CONTEXT context); //
  T endOfTransmission(final CONTEXT context); //
  T enquiry(final CONTEXT context); //
  T acknowledgment(final CONTEXT context); //
  T bell(final CONTEXT context); //
  T backspace(final CONTEXT context); //
  T horizontalTab(final CONTEXT context); //
  T lineFeed(final CONTEXT context); //
  T verticalTab(final CONTEXT context); //
  T formFeed(final CONTEXT context); //
  T carriageReturn(final CONTEXT context); //
  T shiftOut(final CONTEXT context); //
  T shiftIn(final CONTEXT context); //
  T dataLinkEscape(final CONTEXT context); //
  T deviceControl1(final CONTEXT context); //
  T deviceControl2(final CONTEXT context); //
  T deviceControl3(final CONTEXT context); //
  T deviceControl4(final CONTEXT context); //
  T negativeAcknowledgment(final CONTEXT context); //
  T syncIdle(final CONTEXT context); //
  T endOfTransmissionBlock(final CONTEXT context); //
  T cancel(final CONTEXT context); //
  T endOfMedium(final CONTEXT context); //
  T substitute(final CONTEXT context); //
  T escapeEOF(final CONTEXT context); //
  T escapeDelete(final CONTEXT context); //
  T escapeAnsiBracketEOF(final CONTEXT context); //
  T escapeAnsiBracketUp(final CONTEXT context); //
  T escapeAnsiBracketDown(final CONTEXT context); //
  T escapeAnsiBracketForward(final CONTEXT context); //
  T escapeAnsiBracketBackward(final CONTEXT context); //
  T escapeAnsiBracketHome(final CONTEXT context); //
  T escapeAnsiBracketEnd(final CONTEXT context); //
  T escapeAnsiBracket1EOF(final CONTEXT context); //
  T escapeAnsiBracket1Tilde(final CONTEXT context); //
  T escapeAnsiBracket1Default(final CONTEXT context); //
  T escapeAnsiBracket3EOF(final CONTEXT context); //
  T escapeAnsiBracket3Tilde(final CONTEXT context); //
  T escapeAnsiBracket3Default(final CONTEXT context); //
  T escapeAnsiBracket4EOF(final CONTEXT context); //
  T escapeAnsiBracket4Tilde(final CONTEXT context); //
  T escapeAnsiBracket4Default(final CONTEXT context); //
  T escapeAnsiBracket5EOF(final CONTEXT context); //
  T escapeAnsiBracket5Tilde(final CONTEXT context); //
  T escapeAnsiBracket5Default(final CONTEXT context); //
  T escapeAnsiBracket6EOF(final CONTEXT context); //
  T escapeAnsiBracket6Tilde(final CONTEXT context); //
  T escapeAnsiBracket6Default(final CONTEXT context); //
  T escapeAnsiBracket7EOF(final CONTEXT context); //
  T escapeAnsiBracket7Tilde(final CONTEXT context); //
  T escapeAnsiBracket7Default(final CONTEXT context); //
  T escapeAnsiBracket8EOF(final CONTEXT context); //
  T escapeAnsiBracket8Tilde(final CONTEXT context); //
  T escapeAnsiBracket8Default(final CONTEXT context); //
  T escapeAnsiBracketDefault(final CONTEXT context); //
  T escapeAnsiOEOF(final CONTEXT context); //
  T escapeAnsiOHome(final CONTEXT context); //
  T escapeAnsiOEnd(final CONTEXT context); //
  T escapeAnsiOP(final CONTEXT context); //
  T escapeAnsiOQ(final CONTEXT context); //
  T escapeAnsiOR(final CONTEXT context); //
  T escapeAnsiOS(final CONTEXT context); //
  T escapeAnsiODefault(final CONTEXT context); //
  T escapeAnsib(final CONTEXT context); //
  T escapeAnsif(final CONTEXT context); //
  T escapeAnsiDefault(final CONTEXT context); //
  T fileSeparator(final CONTEXT context); //
  T groupSeparator(final CONTEXT context); //
  T recordSeparator(final CONTEXT context); //
  T unitSeparator(final CONTEXT context); //
  T space(final CONTEXT context); //
  T exclamation(final CONTEXT context); //
  T doubleQuote(final CONTEXT context); //
  T hash(final CONTEXT context); //
  T dollar(final CONTEXT context); //
  T percent(final CONTEXT context); //
  T ampersand(final CONTEXT context); //
  T singleQuote(final CONTEXT context); //
  T lparen(final CONTEXT context); //
  T rparen(final CONTEXT context); //
  T asterisk(final CONTEXT context); //
  T plus(final CONTEXT context); //
  T comma(final CONTEXT context); //
  T minus(final CONTEXT context); //
  T dot(final CONTEXT context); //
  T slash(final CONTEXT context); //
  T zero(final CONTEXT context); //
  T one(final CONTEXT context); //
  T two(final CONTEXT context); //
  T three(final CONTEXT context); //
  T four(final CONTEXT context); //
  T five(final CONTEXT context); //
  T six(final CONTEXT context); //
  T seven(final CONTEXT context); //
  T eight(final CONTEXT context); //
  T nine(final CONTEXT context); //
  T colon(final CONTEXT context); //
  T semicolon(final CONTEXT context); //
  T lt(final CONTEXT context); //
  T equal(final CONTEXT context); //
  T gt(final CONTEXT context); //
  T question(final CONTEXT context); //
  T at(final CONTEXT context); //
  T capA(final CONTEXT context); //
  T capB(final CONTEXT context); //
  T capC(final CONTEXT context); //
  T capD(final CONTEXT context); //
  T capE(final CONTEXT context); //
  T capF(final CONTEXT context); //
  T capG(final CONTEXT context); //
  T capH(final CONTEXT context); //
  T capI(final CONTEXT context); //
  T capJ(final CONTEXT context); //
  T capK(final CONTEXT context); //
  T capL(final CONTEXT context); //
  T capM(final CONTEXT context); //
  T capN(final CONTEXT context); //
  T capO(final CONTEXT context); //
  T capP(final CONTEXT context); //
  T capQ(final CONTEXT context); //
  T capR(final CONTEXT context); //
  T capS(final CONTEXT context); //
  T capT(final CONTEXT context); //
  T capU(final CONTEXT context); //
  T capV(final CONTEXT context); //
  T capW(final CONTEXT context); //
  T capX(final CONTEXT context); //
  T capY(final CONTEXT context); //
  T capZ(final CONTEXT context); //
  T lBra(final CONTEXT context); //
  T backslash(final CONTEXT context); //
  T rBra(final CONTEXT context); //
  T caret(final CONTEXT context); //
  T underscore(final CONTEXT context); //
  T backquote(final CONTEXT context); //
  T lowerA(final CONTEXT context); //
  T lowerB(final CONTEXT context); //
  T lowerC(final CONTEXT context); //
  T lowerD(final CONTEXT context); //
  T lowerE(final CONTEXT context); //
  T lowerF(final CONTEXT context); //
  T lowerG(final CONTEXT context); //
  T lowerH(final CONTEXT context); //
  T lowerI(final CONTEXT context); //
  T lowerJ(final CONTEXT context); //
  T lowerK(final CONTEXT context); //
  T lowerL(final CONTEXT context); //
  T lowerM(final CONTEXT context); //
  T lowerN(final CONTEXT context); //
  T lowerO(final CONTEXT context); //
  T lowerP(final CONTEXT context); //
  T lowerQ(final CONTEXT context); //
  T lowerR(final CONTEXT context); //
  T lowerS(final CONTEXT context); //
  T lowerT(final CONTEXT context); //
  T lowerU(final CONTEXT context); //
  T lowerV(final CONTEXT context); //
  T lowerW(final CONTEXT context); //
  T lowerX(final CONTEXT context); //
  T lowerY(final CONTEXT context); //
  T lowerZ(final CONTEXT context); //
  T lBrace(final CONTEXT context); //
  T bar(final CONTEXT context); //
  T rBrace(final CONTEXT context); //
  T tilde(final CONTEXT context); //
  T del(final CONTEXT context); //
  T extended(final CONTEXT context); //
}
