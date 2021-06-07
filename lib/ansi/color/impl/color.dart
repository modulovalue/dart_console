import '../../spec/default_palette/black.dart';
import '../../spec/default_palette/blue.dart';
import '../../spec/default_palette/cyan.dart';
import '../../spec/default_palette/green.dart';
import '../../spec/default_palette/magenta.dart';
import '../../spec/default_palette/red.dart';
import '../../spec/default_palette/white.dart';
import '../../spec/default_palette/yellow.dart';
import '../interface/named/basic.dart';

abstract class NamedAnsiColors {
  static const black = NamedAnsiColorBlackImpl._();
  static const red = NamedAnsiColorRedImpl._();
  static const green = NamedAnsiColorGreenImpl._();
  static const yellow = NamedAnsiColorYellowImpl._();
  static const blue = NamedAnsiColorBlueImpl._();
  static const magenta = NamedAnsiColorMagentaImpl._();
  static const cyan = NamedAnsiColorCyanImpl._();
  static const white = NamedAnsiColorWhiteImpl._();
}

class NamedAnsiColorBlackImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorBlackImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteBlackTribit;

  @override
  String get name => defaultPaletteBlackName;
}

class NamedAnsiColorRedImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorRedImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteRedTribit;

  @override
  String get name => defaultPaletteRedName;
}

class NamedAnsiColorGreenImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorGreenImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteGreenTribit;

  @override
  String get name => defaultPaletteGreenName;
}

class NamedAnsiColorYellowImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorYellowImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteYellowTribit;

  @override
  String get name => defaultPaletteYellowName;
}

class NamedAnsiColorBlueImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorBlueImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteBlueTribit;

  @override
  String get name => defaultPaletteBlueName;
}

class NamedAnsiColorMagentaImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorMagentaImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteMagentaTribit;

  @override
  String get name => defaultPaletteMagentaName;
}

class NamedAnsiColorCyanImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorCyanImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteCyanTribit;

  @override
  String get name => defaultPaletteCyanName;
}

class NamedAnsiColorWhiteImpl implements NamedAnsiBasicColor {
  const NamedAnsiColorWhiteImpl._();

  @override
  int get paletteNumberTribit => defaultPaletteWhiteTribit;

  @override
  String get name => defaultPaletteWhiteName;
}
