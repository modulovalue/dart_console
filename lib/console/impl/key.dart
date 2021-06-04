import '../interface/control_character.dart';
import '../interface/key.dart';

class KeyControlImpl with KeyControlMixin {
  @override
  final ControlCharacter controlChar;

  const KeyControlImpl(this.controlChar);
}

mixin KeyControlMixin implements KeyControl {
  @override
  ControlCharacter get controlChar;

  @override
  Z match<Z>({
    required Z Function(KeyPrintable p1) printable,
    required Z Function(KeyControl p1) control,
  }) =>
      control(this);

  @override
  String toString() => 'KeyControl{controlChar: $controlChar}';

  @override
  bool operator ==(Object other) => identical(this, other) || other is KeyControl && controlChar == other.controlChar;

  @override
  int get hashCode => controlChar.hashCode;
}

class KeyPrintableImpl implements KeyPrintable {
  @override
  final String char;

  const KeyPrintableImpl(this.char)
      : assert(
          char.length == 1,
          "The given character " + char + " must be a character i.e. of length 1.",
        );

  @override
  Z match<Z>({
    required Z Function(KeyPrintable p1) printable,
    required Z Function(KeyControl p1) control,
  }) =>
      printable(this);

  @override
  String toString() => char.toString();

  @override
  bool operator ==(Object other) => identical(this, other) || other is KeyPrintable && char == other.char;

  @override
  int get hashCode => char.hashCode;
}
