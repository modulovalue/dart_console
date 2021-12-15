import 'package:dart_ansi/ansi.dart';
import 'package:dart_ansi/parser.dart';

import 'console/impl/key.dart';
import 'console/interface/control_character.dart';
import 'console/interface/key.dart';

abstract class AnsiParserInputBuffer {
  int readByte();
}

abstract class ByteReadExceptionTooSmall implements Exception {
  int get value;

  String get message;
}

/// May throw [ByteReadExceptionTooSmall] if any
/// given byte is smaller than [stdinEndOfFileIndicator].
Key parseKey(
  final AnsiParserInputBuffer buffer,
) {
  final firstValidByte = _ansiParserReadContinuousByte(
    buffer.readByte,
  );
  return ansiParserReadKey(
    firstByte: firstValidByte,
    nextByte: buffer.readByte,
    delegate: const _KeyDelegateKeyBindingsImpl(),
    context: firstValidByte,
  );
}

/// Reads bytes via [readByte] until it returns a [stdinEndOfFileIndicator]
///
/// May throw ByteReadExceptionTooSmall if any
/// given byte is smaller than [stdinEndOfFileIndicator].
int _ansiParserReadContinuousByte(
  final int Function() readByte,
) {
  var _readByte = 0;
  while (_readByte <= 0) {
    _readByte = readByte();
    if (_readByte < stdinEndOfFileIndicator) {
      throw _ByteReadExceptionTooSmallImpl(_readByte);
    } else if (_readByte > byteSize) {
      // Let callers handle bytes that are too big.
      return _readByte;
    }
  }
  return _readByte;
}

class _ByteReadExceptionTooSmallImpl implements ByteReadExceptionTooSmall {
  @override
  final int value;

  const _ByteReadExceptionTooSmallImpl(
    final this.value,
  );

  @override
  String get message =>
      "An invalid byte was read. Byte '" + value.toString() + "' was below " + stdinEndOfFileIndicator.toString() + ".";

  @override
  String toString() => message;
}

// ignore_for_file: annotate_overrides
// ignore_for_file: always_declare_return_types
// ignore_for_file: type_annotate_public_apis
// ignore_for_file: inference_failure_on_untyped_parameter
class _KeyDelegateKeyBindingsImpl implements KeyDelegate<Key, int> {
  const _KeyDelegateKeyBindingsImpl();

  nil(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  startOfHeader(final context) => const KeyControlImpl(ControlCharacters.ctrlA); //
  startOfText(final context) => const KeyControlImpl(ControlCharacters.ctrlB); //
  endOfText(final context) => const KeyControlImpl(ControlCharacters.ctrlC); //
  endOfTransmission(final context) => const KeyControlImpl(ControlCharacters.ctrlD); //
  enquiry(final context) => const KeyControlImpl(ControlCharacters.ctrlE); //
  acknowledgment(final context) => const KeyControlImpl(ControlCharacters.ctrlF); //
  bell(final context) => const KeyControlImpl(ControlCharacters.ctrlG); //
  backspace(final context) => const KeyControlImpl(ControlCharacters.ctrlH); //
  horizontalTab(final context) => const KeyControlImpl(ControlCharacters.tab); //
  lineFeed(final context) => const KeyControlImpl(ControlCharacters.ctrlJ); //
  verticalTab(final context) => const KeyControlImpl(ControlCharacters.ctrlK); //
  formFeed(final context) => const KeyControlImpl(ControlCharacters.ctrlL); //
  carriageReturn(final context) => const KeyControlImpl(ControlCharacters.enter); //
  shiftOut(final context) => const KeyControlImpl(ControlCharacters.ctrlN); //
  shiftIn(final context) => const KeyControlImpl(ControlCharacters.ctrlO); //
  dataLinkEscape(final context) => const KeyControlImpl(ControlCharacters.ctrlP); //
  deviceControl1(final context) => const KeyControlImpl(ControlCharacters.ctrlQ); //
  deviceControl2(final context) => const KeyControlImpl(ControlCharacters.ctrlR); //
  deviceControl3(final context) => const KeyControlImpl(ControlCharacters.ctrlS); //
  deviceControl4(final context) => const KeyControlImpl(ControlCharacters.ctrlT); //
  negativeAcknowledgment(final context) => const KeyControlImpl(ControlCharacters.ctrlU); //
  syncIdle(final context) => const KeyControlImpl(ControlCharacters.ctrlV); //
  endOfTransmissionBlock(final context) => const KeyControlImpl(ControlCharacters.ctrlW); //
  cancel(final context) => const KeyControlImpl(ControlCharacters.ctrlX); //
  endOfMedium(final context) => const KeyControlImpl(ControlCharacters.ctrlY); //
  substitute(final context) => const KeyControlImpl(ControlCharacters.ctrlZ); //
  escapeEOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeDelete(final context) => const KeyControlImpl(ControlCharacters.wordBackspace); //
  escapeAnsiBracketEOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracketUp(final context) => const KeyControlImpl(ControlCharacters.arrowUp); //
  escapeAnsiBracketDown(final context) => const KeyControlImpl(ControlCharacters.arrowDown); //
  escapeAnsiBracketForward(final context) => const KeyControlImpl(ControlCharacters.arrowRight); //
  escapeAnsiBracketBackward(final context) => const KeyControlImpl(ControlCharacters.arrowLeft); //
  escapeAnsiBracketHome(final context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracketEnd(final context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket1EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket1Tilde(final context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracket1Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket3EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket3Tilde(final context) => const KeyControlImpl(ControlCharacters.delete); //
  escapeAnsiBracket3Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket4EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket4Tilde(final context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket4Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket5EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket5Tilde(final context) => const KeyControlImpl(ControlCharacters.pageUp); //
  escapeAnsiBracket5Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket6EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket6Tilde(final context) => const KeyControlImpl(ControlCharacters.pageDown); //
  escapeAnsiBracket6Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket7EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket7Tilde(final context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracket7Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket8EOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket8Tilde(final context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket8Default(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracketDefault(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiOEOF(final context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiOHome(final context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiOEnd(final context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiOP(final context) => const KeyControlImpl(ControlCharacters.F1); //
  escapeAnsiOQ(final context) => const KeyControlImpl(ControlCharacters.F2); //
  escapeAnsiOR(final context) => const KeyControlImpl(ControlCharacters.F3); //
  escapeAnsiOS(final context) => const KeyControlImpl(ControlCharacters.F4); //
  escapeAnsiODefault(final context) => throw Exception("Unexpected O command"); //
  escapeAnsib(final context) => const KeyControlImpl(ControlCharacters.wordLeft); //
  escapeAnsif(final context) => const KeyControlImpl(ControlCharacters.wordRight); //
  escapeAnsiDefault(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  fileSeparator(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  groupSeparator(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  recordSeparator(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  unitSeparator(final context) => const KeyControlImpl(ControlCharacters.unknown); //
  space(final context) => const KeyPrintableImpl(' '); //
  exclamation(final context) => const KeyPrintableImpl('!'); //
  doubleQuote(final context) => const KeyPrintableImpl('"'); //
  hash(final context) => const KeyPrintableImpl("#"); //
  dollar(final context) => const KeyPrintableImpl(r"$"); //
  percent(final context) => const KeyPrintableImpl("%"); //
  ampersand(final context) => const KeyPrintableImpl("&"); //
  singleQuote(final context) => const KeyPrintableImpl("'"); //
  lparen(final context) => const KeyPrintableImpl("("); //
  rparen(final context) => const KeyPrintableImpl(")"); //
  asterisk(final context) => const KeyPrintableImpl("*"); //
  plus(final context) => const KeyPrintableImpl("+"); //
  comma(final context) => const KeyPrintableImpl(","); //
  minus(final context) => const KeyPrintableImpl("-"); //
  dot(final context) => const KeyPrintableImpl("."); //
  slash(final context) => const KeyPrintableImpl("/"); //
  zero(final context) => const KeyPrintableImpl("0"); //
  one(final context) => const KeyPrintableImpl("1"); //
  two(final context) => const KeyPrintableImpl("2"); //
  three(final context) => const KeyPrintableImpl("3"); //
  four(final context) => const KeyPrintableImpl("4"); //
  five(final context) => const KeyPrintableImpl("5"); //
  six(final context) => const KeyPrintableImpl("6"); //
  seven(final context) => const KeyPrintableImpl("7"); //
  eight(final context) => const KeyPrintableImpl("8"); //
  nine(final context) => const KeyPrintableImpl("9"); //
  colon(final context) => const KeyPrintableImpl(":"); //
  semicolon(final context) => const KeyPrintableImpl(";"); //
  lt(final context) => const KeyPrintableImpl("<"); //
  equal(final context) => const KeyPrintableImpl("="); //
  gt(final context) => const KeyPrintableImpl(">"); //
  question(final context) => const KeyPrintableImpl("?"); //
  at(final context) => const KeyPrintableImpl("@"); //
  capA(final context) => const KeyPrintableImpl("A"); //
  capB(final context) => const KeyPrintableImpl("B"); //
  capC(final context) => const KeyPrintableImpl("C"); //
  capD(final context) => const KeyPrintableImpl("D"); //
  capE(final context) => const KeyPrintableImpl("E"); //
  capF(final context) => const KeyPrintableImpl("F"); //
  capG(final context) => const KeyPrintableImpl("G"); //
  capH(final context) => const KeyPrintableImpl("H"); //
  capI(final context) => const KeyPrintableImpl("I"); //
  capJ(final context) => const KeyPrintableImpl("J"); //
  capK(final context) => const KeyPrintableImpl("K"); //
  capL(final context) => const KeyPrintableImpl("L"); //
  capM(final context) => const KeyPrintableImpl("M"); //
  capN(final context) => const KeyPrintableImpl("N"); //
  capO(final context) => const KeyPrintableImpl("O"); //
  capP(final context) => const KeyPrintableImpl("P"); //
  capQ(final context) => const KeyPrintableImpl("Q"); //
  capR(final context) => const KeyPrintableImpl("R"); //
  capS(final context) => const KeyPrintableImpl("S"); //
  capT(final context) => const KeyPrintableImpl("T"); //
  capU(final context) => const KeyPrintableImpl("U"); //
  capV(final context) => const KeyPrintableImpl("V"); //
  capW(final context) => const KeyPrintableImpl("W"); //
  capX(final context) => const KeyPrintableImpl("X"); //
  capY(final context) => const KeyPrintableImpl("Y"); //
  capZ(final context) => const KeyPrintableImpl("Z"); //
  lBra(final context) => const KeyPrintableImpl("["); //
  backslash(final context) => const KeyPrintableImpl(r"\"); //
  rBra(final context) => const KeyPrintableImpl("]"); //
  caret(final context) => const KeyPrintableImpl("^"); //
  underscore(final context) => const KeyPrintableImpl("_"); //
  backquote(final context) => const KeyPrintableImpl("`"); //
  lowerA(final context) => const KeyPrintableImpl("a"); //
  lowerB(final context) => const KeyPrintableImpl("b"); //
  lowerC(final context) => const KeyPrintableImpl("c"); //
  lowerD(final context) => const KeyPrintableImpl("d"); //
  lowerE(final context) => const KeyPrintableImpl("e"); //
  lowerF(final context) => const KeyPrintableImpl("f"); //
  lowerG(final context) => const KeyPrintableImpl("g"); //
  lowerH(final context) => const KeyPrintableImpl("h"); //
  lowerI(final context) => const KeyPrintableImpl("i"); //
  lowerJ(final context) => const KeyPrintableImpl("j"); //
  lowerK(final context) => const KeyPrintableImpl("k"); //
  lowerL(final context) => const KeyPrintableImpl("l"); //
  lowerM(final context) => const KeyPrintableImpl("m"); //
  lowerN(final context) => const KeyPrintableImpl("n"); //
  lowerO(final context) => const KeyPrintableImpl("o"); //
  lowerP(final context) => const KeyPrintableImpl("p"); //
  lowerQ(final context) => const KeyPrintableImpl("q"); //
  lowerR(final context) => const KeyPrintableImpl("r"); //
  lowerS(final context) => const KeyPrintableImpl("s"); //
  lowerT(final context) => const KeyPrintableImpl("t"); //
  lowerU(final context) => const KeyPrintableImpl("u"); //
  lowerV(final context) => const KeyPrintableImpl("v"); //
  lowerW(final context) => const KeyPrintableImpl("w"); //
  lowerX(final context) => const KeyPrintableImpl("x"); //
  lowerY(final context) => const KeyPrintableImpl("y"); //
  lowerZ(final context) => const KeyPrintableImpl("z"); //
  lBrace(final context) => const KeyPrintableImpl("{"); //
  bar(final context) => const KeyPrintableImpl("|"); //
  rBrace(final context) => const KeyPrintableImpl("}"); //
  tilde(final context) => const KeyPrintableImpl("~"); //
  del(final context) => const KeyControlImpl(ControlCharacters.backspace); //
  extended(final context) => KeyPrintableImpl(String.fromCharCode(context)); //
}
