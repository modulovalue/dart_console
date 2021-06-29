import 'package:dart_ansi/ansi.dart';
import 'package:dart_ansi/parser.dart';

import 'console/impl/key.dart';
import 'console/interface/control_character.dart';
import 'console/interface/key.dart';

// ignore_for_file: annotate_overrides
// ignore_for_file: always_declare_return_types
// ignore_for_file: type_annotate_public_apis
// ignore_for_file: inference_failure_on_untyped_parameter

abstract class AnsiParserInputBuffer {
  int readByte();
}

abstract class ByteReadExceptionTooSmall implements Exception {
  int get value;

  String get message;
}

/// May throw [ByteReadExceptionTooSmall] if any
/// given byte is smaller than [stdinEndOfFileIndicator].
Key parseKey(AnsiParserInputBuffer buffer) {
  final firstValidByte = _ansiParserReadContinuousByte(buffer.readByte);
  return ansiParserReadKey(
    firstByte: firstValidByte,
    nextByte: buffer.readByte,
    delegate: const _KeyDelegateKeyBindingsImpl(),
    context: firstValidByte,
  );
}

//
// Private.
//

/// Reads bytes via [readByte] until it returns a [stdinEndOfFileIndicator]
///
/// May throw ByteReadExceptionTooSmall if any
/// given byte is smaller than [stdinEndOfFileIndicator].
int _ansiParserReadContinuousByte(int Function() readByte) {
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

  const _ByteReadExceptionTooSmallImpl(this.value);

  @override
  String get message => "An invalid byte was read. Byte '$value' was below ${stdinEndOfFileIndicator}.";

  @override
  String toString() => message;
}

class _KeyDelegateKeyBindingsImpl implements KeyDelegate<Key, int> {
  const _KeyDelegateKeyBindingsImpl();

  nil(context) => const KeyControlImpl(ControlCharacters.unknown); //
  startOfHeader(context) => const KeyControlImpl(ControlCharacters.ctrlA); //
  startOfText(context) => const KeyControlImpl(ControlCharacters.ctrlB); //
  endOfText(context) => const KeyControlImpl(ControlCharacters.ctrlC); //
  endOfTransmission(context) => const KeyControlImpl(ControlCharacters.ctrlD); //
  enquiry(context) => const KeyControlImpl(ControlCharacters.ctrlE); //
  acknowledgment(context) => const KeyControlImpl(ControlCharacters.ctrlF); //
  bell(context) => const KeyControlImpl(ControlCharacters.ctrlG); //
  backspace(context) => const KeyControlImpl(ControlCharacters.ctrlH); //
  horizontalTab(context) => const KeyControlImpl(ControlCharacters.tab); //
  lineFeed(context) => const KeyControlImpl(ControlCharacters.ctrlJ); //
  verticalTab(context) => const KeyControlImpl(ControlCharacters.ctrlK); //
  formFeed(context) => const KeyControlImpl(ControlCharacters.ctrlL); //
  carriageReturn(context) => const KeyControlImpl(ControlCharacters.enter); //
  shiftOut(context) => const KeyControlImpl(ControlCharacters.ctrlN); //
  shiftIn(context) => const KeyControlImpl(ControlCharacters.ctrlO); //
  dataLinkEscape(context) => const KeyControlImpl(ControlCharacters.ctrlP); //
  deviceControl1(context) => const KeyControlImpl(ControlCharacters.ctrlQ); //
  deviceControl2(context) => const KeyControlImpl(ControlCharacters.ctrlR); //
  deviceControl3(context) => const KeyControlImpl(ControlCharacters.ctrlS); //
  deviceControl4(context) => const KeyControlImpl(ControlCharacters.ctrlT); //
  negativeAcknowledgment(context) => const KeyControlImpl(ControlCharacters.ctrlU); //
  syncIdle(context) => const KeyControlImpl(ControlCharacters.ctrlV); //
  endOfTransmissionBlock(context) => const KeyControlImpl(ControlCharacters.ctrlW); //
  cancel(context) => const KeyControlImpl(ControlCharacters.ctrlX); //
  endOfMedium(context) => const KeyControlImpl(ControlCharacters.ctrlY); //
  substitute(context) => const KeyControlImpl(ControlCharacters.ctrlZ); //
  escapeEOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeDelete(context) => const KeyControlImpl(ControlCharacters.wordBackspace); //
  escapeAnsiBracketEOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracketUp(context) => const KeyControlImpl(ControlCharacters.arrowUp); //
  escapeAnsiBracketDown(context) => const KeyControlImpl(ControlCharacters.arrowDown); //
  escapeAnsiBracketForward(context) => const KeyControlImpl(ControlCharacters.arrowRight); //
  escapeAnsiBracketBackward(context) => const KeyControlImpl(ControlCharacters.arrowLeft); //
  escapeAnsiBracketHome(context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracketEnd(context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket1EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket1Tilde(context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracket1Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket3EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket3Tilde(context) => const KeyControlImpl(ControlCharacters.delete); //
  escapeAnsiBracket3Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket4EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket4Tilde(context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket4Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket5EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket5Tilde(context) => const KeyControlImpl(ControlCharacters.pageUp); //
  escapeAnsiBracket5Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket6EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket6Tilde(context) => const KeyControlImpl(ControlCharacters.pageDown); //
  escapeAnsiBracket6Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket7EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket7Tilde(context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiBracket7Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracket8EOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiBracket8Tilde(context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiBracket8Default(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiBracketDefault(context) => const KeyControlImpl(ControlCharacters.unknown); //
  escapeAnsiOEOF(context) => const KeyControlImpl(ControlCharacters.escape); //
  escapeAnsiOHome(context) => const KeyControlImpl(ControlCharacters.home); //
  escapeAnsiOEnd(context) => const KeyControlImpl(ControlCharacters.end); //
  escapeAnsiOP(context) => const KeyControlImpl(ControlCharacters.F1); //
  escapeAnsiOQ(context) => const KeyControlImpl(ControlCharacters.F2); //
  escapeAnsiOR(context) => const KeyControlImpl(ControlCharacters.F3); //
  escapeAnsiOS(context) => const KeyControlImpl(ControlCharacters.F4); //
  escapeAnsiODefault(context) => throw Exception("Unexpected O command"); //
  escapeAnsib(context) => const KeyControlImpl(ControlCharacters.wordLeft); //
  escapeAnsif(context) => const KeyControlImpl(ControlCharacters.wordRight); //
  escapeAnsiDefault(context) => const KeyControlImpl(ControlCharacters.unknown); //
  fileSeparator(context) => const KeyControlImpl(ControlCharacters.unknown); //
  groupSeparator(context) => const KeyControlImpl(ControlCharacters.unknown); //
  recordSeparator(context) => const KeyControlImpl(ControlCharacters.unknown); //
  unitSeparator(context) => const KeyControlImpl(ControlCharacters.unknown); //
  space(context) => const KeyPrintableImpl(' '); //
  exclamation(context) => const KeyPrintableImpl('!'); //
  doubleQuote(context) => const KeyPrintableImpl('"'); //
  hash(context) => const KeyPrintableImpl("#"); //
  dollar(context) => const KeyPrintableImpl(r"$"); //
  percent(context) => const KeyPrintableImpl("%"); //
  ampersand(context) => const KeyPrintableImpl("&"); //
  singleQuote(context) => const KeyPrintableImpl("'"); //
  lparen(context) => const KeyPrintableImpl("("); //
  rparen(context) => const KeyPrintableImpl(")"); //
  asterisk(context) => const KeyPrintableImpl("*"); //
  plus(context) => const KeyPrintableImpl("+"); //
  comma(context) => const KeyPrintableImpl(","); //
  minus(context) => const KeyPrintableImpl("-"); //
  dot(context) => const KeyPrintableImpl("."); //
  slash(context) => const KeyPrintableImpl("/"); //
  zero(context) => const KeyPrintableImpl("0"); //
  one(context) => const KeyPrintableImpl("1"); //
  two(context) => const KeyPrintableImpl("2"); //
  three(context) => const KeyPrintableImpl("3"); //
  four(context) => const KeyPrintableImpl("4"); //
  five(context) => const KeyPrintableImpl("5"); //
  six(context) => const KeyPrintableImpl("6"); //
  seven(context) => const KeyPrintableImpl("7"); //
  eight(context) => const KeyPrintableImpl("8"); //
  nine(context) => const KeyPrintableImpl("9"); //
  colon(context) => const KeyPrintableImpl(":"); //
  semicolon(context) => const KeyPrintableImpl(";"); //
  lt(context) => const KeyPrintableImpl("<"); //
  equal(context) => const KeyPrintableImpl("="); //
  gt(context) => const KeyPrintableImpl(">"); //
  question(context) => const KeyPrintableImpl("?"); //
  at(context) => const KeyPrintableImpl("@"); //
  capA(context) => const KeyPrintableImpl("A"); //
  capB(context) => const KeyPrintableImpl("B"); //
  capC(context) => const KeyPrintableImpl("C"); //
  capD(context) => const KeyPrintableImpl("D"); //
  capE(context) => const KeyPrintableImpl("E"); //
  capF(context) => const KeyPrintableImpl("F"); //
  capG(context) => const KeyPrintableImpl("G"); //
  capH(context) => const KeyPrintableImpl("H"); //
  capI(context) => const KeyPrintableImpl("I"); //
  capJ(context) => const KeyPrintableImpl("J"); //
  capK(context) => const KeyPrintableImpl("K"); //
  capL(context) => const KeyPrintableImpl("L"); //
  capM(context) => const KeyPrintableImpl("M"); //
  capN(context) => const KeyPrintableImpl("N"); //
  capO(context) => const KeyPrintableImpl("O"); //
  capP(context) => const KeyPrintableImpl("P"); //
  capQ(context) => const KeyPrintableImpl("Q"); //
  capR(context) => const KeyPrintableImpl("R"); //
  capS(context) => const KeyPrintableImpl("S"); //
  capT(context) => const KeyPrintableImpl("T"); //
  capU(context) => const KeyPrintableImpl("U"); //
  capV(context) => const KeyPrintableImpl("V"); //
  capW(context) => const KeyPrintableImpl("W"); //
  capX(context) => const KeyPrintableImpl("X"); //
  capY(context) => const KeyPrintableImpl("Y"); //
  capZ(context) => const KeyPrintableImpl("Z"); //
  lBra(context) => const KeyPrintableImpl("["); //
  backslash(context) => const KeyPrintableImpl(r"\"); //
  rBra(context) => const KeyPrintableImpl("]"); //
  caret(context) => const KeyPrintableImpl("^"); //
  underscore(context) => const KeyPrintableImpl("_"); //
  backquote(context) => const KeyPrintableImpl("`"); //
  lowerA(context) => const KeyPrintableImpl("a"); //
  lowerB(context) => const KeyPrintableImpl("b"); //
  lowerC(context) => const KeyPrintableImpl("c"); //
  lowerD(context) => const KeyPrintableImpl("d"); //
  lowerE(context) => const KeyPrintableImpl("e"); //
  lowerF(context) => const KeyPrintableImpl("f"); //
  lowerG(context) => const KeyPrintableImpl("g"); //
  lowerH(context) => const KeyPrintableImpl("h"); //
  lowerI(context) => const KeyPrintableImpl("i"); //
  lowerJ(context) => const KeyPrintableImpl("j"); //
  lowerK(context) => const KeyPrintableImpl("k"); //
  lowerL(context) => const KeyPrintableImpl("l"); //
  lowerM(context) => const KeyPrintableImpl("m"); //
  lowerN(context) => const KeyPrintableImpl("n"); //
  lowerO(context) => const KeyPrintableImpl("o"); //
  lowerP(context) => const KeyPrintableImpl("p"); //
  lowerQ(context) => const KeyPrintableImpl("q"); //
  lowerR(context) => const KeyPrintableImpl("r"); //
  lowerS(context) => const KeyPrintableImpl("s"); //
  lowerT(context) => const KeyPrintableImpl("t"); //
  lowerU(context) => const KeyPrintableImpl("u"); //
  lowerV(context) => const KeyPrintableImpl("v"); //
  lowerW(context) => const KeyPrintableImpl("w"); //
  lowerX(context) => const KeyPrintableImpl("x"); //
  lowerY(context) => const KeyPrintableImpl("y"); //
  lowerZ(context) => const KeyPrintableImpl("z"); //
  lBrace(context) => const KeyPrintableImpl("{"); //
  bar(context) => const KeyPrintableImpl("|"); //
  rBrace(context) => const KeyPrintableImpl("}"); //
  tilde(context) => const KeyPrintableImpl("~"); //
  del(context) => const KeyControlImpl(ControlCharacters.backspace); //
  extended(context) => KeyPrintableImpl(String.fromCharCode(context)); //
}
