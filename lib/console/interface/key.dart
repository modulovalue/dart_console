import 'control_characters.dart';

/// A representation of a keystroke.
abstract class Key {
  Z match<Z>({
    required Z Function(PrintableKey) printable,
    required Z Function(ControlKey) control,
  });
}

/// A representation of a printable character keystroke.
abstract class PrintableKey implements Key {
  String get char;
}

/// A representation of a control character keystroke.
abstract class ControlKey implements Key {
  ControlCharacter get controlChar;
}
