import '../interface/control_characters.dart';
import '../interface/key.dart';

class KeyControlMutableImpl implements ControlKey {
  @override
  ControlCharacter controlChar;

  KeyControlMutableImpl(this.controlChar);

  @override
  Z match<Z>({
    required Z Function(PrintableKey p1) printable,
    required Z Function(ControlKey p1) control,
  }) =>
      control(this);

  @override
  String toString() => 'KeyControlImpl{controlChar: $controlChar}';
}

class KeyPrintableImpl implements PrintableKey {
  @override
  final String char;

  const KeyPrintableImpl(this.char) : assert(char.length == 1, "The given character " + char + " must be a character i.e. of length 1.");

  @override
  Z match<Z>({
    required Z Function(PrintableKey p1) printable,
    required Z Function(ControlKey p1) control,
  }) =>
      printable(this);

  @override
  String toString() => char.toString();
}
