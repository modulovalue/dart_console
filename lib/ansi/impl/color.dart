import '../interface/color.dart';

abstract class NamedAnsiColors {
  static const black = NamedAnsiColorBlackImpl._();
  static const red = NamedAnsiColorRedImpl._();
  static const green = NamedAnsiColorGreenImpl._();
  static const yellow = NamedAnsiColorYellowImpl._();
  static const blue = NamedAnsiColorBlueImpl._();
  static const magenta = NamedAnsiColorMagentaImpl._();
  static const cyan = NamedAnsiColorCyanImpl._();
  static const white = NamedAnsiColorWhiteImpl._();
  static const brightBlack = NamedAnsiColorBrightBlackImpl._();
  static const brightRed = NamedAnsiColorBrightRedImpl._();
  static const brightGreen = NamedAnsiColorBrightGreenImpl._();
  static const brightYellow = NamedAnsiColorBrightYellowImpl._();
  static const brightBlue = NamedAnsiColorBrightBlueImpl._();
  static const brightMagenta = NamedAnsiColorBrightMagentaImpl._();
  static const brightCyan = NamedAnsiColorBrightCyanImpl._();
  static const brightWhite = NamedAnsiColorBrightWhiteImpl._();
  static const allDark = [black, red, green, yellow, blue, magenta, cyan, white];
  static const allBright = [brightBlack, brightRed, brightGreen, brightYellow, brightBlue, brightMagenta, brightCyan, brightWhite];
  static const allDarkAndBright = [...allDark, ...allBright];
}

class NamedAnsiColorBlackImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorBlackImpl._();

  @override
  int get backgroundColorCode => 40;

  @override
  int get foregroundColorCode => 30;

  @override
  int get paletteNumberTribit => 0;

  @override
  String get name => "black";
}

class NamedAnsiColorRedImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorRedImpl._();

  @override
  int get backgroundColorCode => 41;

  @override
  int get foregroundColorCode => 31;

  @override
  int get paletteNumberTribit => 1;

  @override
  String get name => "red";
}

class NamedAnsiColorGreenImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorGreenImpl._();

  @override
  int get backgroundColorCode => 42;

  @override
  int get foregroundColorCode => 32;

  @override
  int get paletteNumberTribit => 2;

  @override
  String get name => "green";
}

class NamedAnsiColorYellowImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorYellowImpl._();

  @override
  int get backgroundColorCode => 43;

  @override
  int get foregroundColorCode => 33;

  @override
  int get paletteNumberTribit => 3;

  @override
  String get name => "yellow";
}

class NamedAnsiColorBlueImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorBlueImpl._();

  @override
  int get backgroundColorCode => 44;

  @override
  int get foregroundColorCode => 34;

  @override
  int get paletteNumberTribit => 4;

  @override
  String get name => "blue";
}

class NamedAnsiColorMagentaImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorMagentaImpl._();

  @override
  int get backgroundColorCode => 45;

  @override
  int get foregroundColorCode => 35;

  @override
  int get paletteNumberTribit => 5;

  @override
  String get name => "magenta";
}

class NamedAnsiColorCyanImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorCyanImpl._();

  @override
  int get backgroundColorCode => 46;

  @override
  int get foregroundColorCode => 36;

  @override
  int get paletteNumberTribit => 6;

  @override
  String get name => "cyan";
}

/// Light gray.
class NamedAnsiColorWhiteImpl implements DarkNamedAnsiColor {
  const NamedAnsiColorWhiteImpl._();

  @override
  int get backgroundColorCode => 47;

  @override
  int get foregroundColorCode => 37;

  @override
  int get paletteNumberTribit => 7;

  @override
  String get name => "white";
}

/// Gray.
class NamedAnsiColorBrightBlackImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightBlackImpl._();

  @override
  int get backgroundColorCode => 100;

  @override
  int get foregroundColorCode => 90;

  @override
  int get paletteNumberTribit => 0;

  @override
  String get name => "brighBlack";
}

class NamedAnsiColorBrightRedImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightRedImpl._();

  @override
  int get backgroundColorCode => 101;

  @override
  int get foregroundColorCode => 91;

  @override
  int get paletteNumberTribit => 1;

  @override
  String get name => "brightRed";
}

/// Lime.
class NamedAnsiColorBrightGreenImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightGreenImpl._();

  @override
  int get backgroundColorCode => 102;

  @override
  int get foregroundColorCode => 92;

  @override
  int get paletteNumberTribit => 2;

  @override
  String get name => "brightGreen";
}

class NamedAnsiColorBrightYellowImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightYellowImpl._();

  @override
  int get backgroundColorCode => 103;

  @override
  int get foregroundColorCode => 93;

  @override
  int get paletteNumberTribit => 3;

  @override
  String get name => "brightYellow";
}

class NamedAnsiColorBrightBlueImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightBlueImpl._();

  @override
  int get backgroundColorCode => 104;

  @override
  int get foregroundColorCode => 94;

  @override
  int get paletteNumberTribit => 4;

  @override
  String get name => "brightBlue";
}

class NamedAnsiColorBrightMagentaImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightMagentaImpl._();

  @override
  int get backgroundColorCode => 105;

  @override
  int get foregroundColorCode => 95;

  @override
  int get paletteNumberTribit => 5;

  @override
  String get name => "brightMagenta";
}

class NamedAnsiColorBrightCyanImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightCyanImpl._();

  @override
  int get backgroundColorCode => 106;

  @override
  int get foregroundColorCode => 96;

  @override
  int get paletteNumberTribit => 6;

  @override
  String get name => "brightCyan";
}

class NamedAnsiColorBrightWhiteImpl implements BrightNamedAnsiColor {
  const NamedAnsiColorBrightWhiteImpl._();

  @override
  int get backgroundColorCode => 107;

  @override
  int get foregroundColorCode => 97;

  @override
  int get paletteNumberTribit => 7;

  @override
  String get name => "brightWhite";
}
