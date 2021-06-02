import '../interface/color.dart';

abstract class NamedAnsiColors {
  static const _NamedAnsiColorImpl black = _NamedAnsiColorImpl._(40, 30, "black");
  static const _NamedAnsiColorImpl red = _NamedAnsiColorImpl._(41, 31, "red");
  static const _NamedAnsiColorImpl green = _NamedAnsiColorImpl._(42, 32, "green");
  static const _NamedAnsiColorImpl yellow = _NamedAnsiColorImpl._(43, 33, "yellow");
  static const _NamedAnsiColorImpl blue = _NamedAnsiColorImpl._(44, 34, "blue");
  static const _NamedAnsiColorImpl magenta = _NamedAnsiColorImpl._(45, 35, "magenta");
  static const _NamedAnsiColorImpl cyan = _NamedAnsiColorImpl._(46, 36, "cyan");
  static const _NamedAnsiColorImpl white = _NamedAnsiColorImpl._(47, 37, "white");
  static const _NamedAnsiColorImpl brightBlack = _NamedAnsiColorImpl._(100, 90, "brighBlack");
  static const _NamedAnsiColorImpl brightRed = _NamedAnsiColorImpl._(101, 91, "brightRed");
  static const _NamedAnsiColorImpl brightGreen = _NamedAnsiColorImpl._(102, 92, "brightGreen");
  static const _NamedAnsiColorImpl brightYellow = _NamedAnsiColorImpl._(103, 93, "brightYellow");
  static const _NamedAnsiColorImpl brightBlue = _NamedAnsiColorImpl._(104, 94, "brightBlue");
  static const _NamedAnsiColorImpl brightMagenta = _NamedAnsiColorImpl._(105, 95, "brightMagenta");
  static const _NamedAnsiColorImpl brightCyan = _NamedAnsiColorImpl._(106, 96, "brightCyan");
  static const _NamedAnsiColorImpl brightWhite = _NamedAnsiColorImpl._(107, 97, "brightWhite");

  static const List<_NamedAnsiColorImpl> all = [
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    brightBlack,
    brightRed,
    brightGreen,
    brightYellow,
    brightBlue,
    brightMagenta,
    brightCyan,
    brightWhite,
  ];
}

class _NamedAnsiColorImpl implements NamedAnsiColor {
  @override
  final int backgroundColorCode;
  @override
  final int foregroundColorCode;
  @override
  final String name;

  const _NamedAnsiColorImpl._(
    this.backgroundColorCode,
    this.foregroundColorCode,
    this.name,
  );
}
