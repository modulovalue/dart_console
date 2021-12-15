import '../interface/control_character.dart';
import '../interface/key.dart';

class KeyControlImpl with KeyControlMixin {
  @override
  final ControlCharacter controlChar;

  const KeyControlImpl(
    final this.controlChar,
  );
}

mixin KeyControlMixin implements KeyControl {
  @override
  ControlCharacter get controlChar;

  @override
  Z match<Z>({
    required final Z Function(KeyPrintable p1) printable,
    required final Z Function(KeyControl p1) control,
  }) =>
      control(this);

  @override
  String toString() => 'KeyControl{controlChar: $controlChar}';

  @override
  bool operator ==(
    final Object other,
  ) =>
      identical(this, other) || other is KeyControl && controlChar == other.controlChar;

  @override
  int get hashCode => controlChar.hashCode;
}

class KeyPrintableImpl implements KeyPrintable {
  @override
  final String char;

  const KeyPrintableImpl(
    final this.char,
  ) : assert(
          char.length == 1,
          "The given character " + char + " must be a character i.e. of length 1.",
        );

  @override
  Z match<Z>({
    required final Z Function(KeyPrintable p1) printable,
    required final Z Function(KeyControl p1) control,
  }) =>
      printable(this);

  @override
  String toString() => char.toString();

  @override
  bool operator ==(
    final Object other,
  ) =>
      identical(this, other) || other is KeyPrintable && char == other.char;

  @override
  int get hashCode => char.hashCode;
}
