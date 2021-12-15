import 'control_character.dart';

/// A representation of a key character.
abstract class Key {
  Z match<Z>({
    required final Z Function(KeyPrintable) printable,
    required final Z Function(KeyControl) control,
  });
}

/// A representation of a printable key character.
abstract class KeyPrintable implements Key {
  String get char;
}

/// A representation of a control key character.
abstract class KeyControl implements Key {
  ControlCharacter get controlChar;
}
