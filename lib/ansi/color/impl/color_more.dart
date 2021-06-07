import '../interface/generalizing/named_basic.dart';
import '../interface/named/basic.dart';
import 'color.dart';

abstract class NamedAnsiColorsMore {
  static const allDark = [
    DarkAnsiColorAdapter(NamedAnsiColors.black),
    DarkAnsiColorAdapter(NamedAnsiColors.red),
    DarkAnsiColorAdapter(NamedAnsiColors.green),
    DarkAnsiColorAdapter(NamedAnsiColors.yellow),
    DarkAnsiColorAdapter(NamedAnsiColors.blue),
    DarkAnsiColorAdapter(NamedAnsiColors.magenta),
    DarkAnsiColorAdapter(NamedAnsiColors.cyan),
    DarkAnsiColorAdapter(NamedAnsiColors.white),
  ];
  static const allBright = [
    BrightAnsiColorAdapter(NamedAnsiColors.black),
    BrightAnsiColorAdapter(NamedAnsiColors.red),
    BrightAnsiColorAdapter(NamedAnsiColors.green),
    BrightAnsiColorAdapter(NamedAnsiColors.yellow),
    BrightAnsiColorAdapter(NamedAnsiColors.blue),
    BrightAnsiColorAdapter(NamedAnsiColors.magenta),
    BrightAnsiColorAdapter(NamedAnsiColors.cyan),
    BrightAnsiColorAdapter(NamedAnsiColors.white),
  ];
  static const allDarkAndBright = [...allDark, ...allBright];
}

class DarkAnsiColorAdapter implements NamedAnsiColor {
  final NamedAnsiBasicColor color;

  const DarkAnsiColorAdapter(this.color);

  @override
  int get backgroundColorCode => 40 + color.paletteNumberTribit;

  @override
  int get foregroundColorCode => 30 + color.paletteNumberTribit;

  @override
  int get paletteNumberTribit => color.paletteNumberTribit;

  @override
  String get name => color.name;
}

class BrightAnsiColorAdapter implements NamedAnsiColor {
  final NamedAnsiBasicColor color;

  const BrightAnsiColorAdapter(this.color);

  @override
  int get backgroundColorCode => 100 + color.paletteNumberTribit;

  @override
  int get foregroundColorCode => 90 + color.paletteNumberTribit;

  @override
  int get paletteNumberTribit => color.paletteNumberTribit;

  @override
  String get name => "bright " + color.name;
}
