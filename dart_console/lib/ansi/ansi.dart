class NamedAnsiColorBlackImpl implements AnsiBasicColor {
  const NamedAnsiColorBlackImpl();

  @override
  String get paletteNumberTribit => "0";

  @override
  String get name => "black";
}

class NamedAnsiColorRedImpl implements AnsiBasicColor {
  const NamedAnsiColorRedImpl();

  @override
  String get paletteNumberTribit => "1";

  @override
  String get name => "red";
}

class NamedAnsiColorGreenImpl implements AnsiBasicColor {
  const NamedAnsiColorGreenImpl();

  @override
  String get paletteNumberTribit => "2";

  @override
  String get name => "green";
}

class NamedAnsiColorYellowImpl implements AnsiBasicColor {
  const NamedAnsiColorYellowImpl();

  @override
  String get paletteNumberTribit => "3";

  @override
  String get name => "yellow";
}

class NamedAnsiColorBlueImpl implements AnsiBasicColor {
  const NamedAnsiColorBlueImpl();

  @override
  String get paletteNumberTribit => "4";

  @override
  String get name => "blue";
}

class NamedAnsiColorMagentaImpl implements AnsiBasicColor {
  const NamedAnsiColorMagentaImpl();

  @override
  String get paletteNumberTribit => "5";

  @override
  String get name => "magenta";
}

class NamedAnsiColorCyanImpl implements AnsiBasicColor {
  const NamedAnsiColorCyanImpl();

  @override
  String get paletteNumberTribit => "6";

  @override
  String get name => "cyan";
}

class NamedAnsiColorWhiteImpl implements AnsiBasicColor {
  const NamedAnsiColorWhiteImpl();

  @override
  String get paletteNumberTribit => "7";

  @override
  String get name => "white";
}

abstract class AnsiBasicColor {
  String get paletteNumberTribit;

  String get name;
}

class DarkAnsiBackgroundColorAdapter implements AnsiBackgroundColor {
  final AnsiBasicColor color;

  const DarkAnsiBackgroundColorAdapter(
    final this.color,
  );

  @override
  String get backgroundColorCode => "4" + color.paletteNumberTribit;

  @override
  String get name => color.name;
}

class BrightAnsiBackgroundColorAdapter implements AnsiBackgroundColor {
  final AnsiBasicColor color;

  const BrightAnsiBackgroundColorAdapter(
    final this.color,
  );

  @override
  String get backgroundColorCode => "10" + color.paletteNumberTribit;

  @override
  String get name => "bright " + color.name;
}

abstract class AnsiBackgroundColor {
  String get backgroundColorCode;

  String get name;
}

class DarkAnsiForegroundColorAdapter implements AnsiForegroundColor {
  final AnsiBasicColor color;

  const DarkAnsiForegroundColorAdapter(
    final this.color,
  );

  @override
  String get foregroundColorCode => "3" + color.paletteNumberTribit;

  @override
  String get name => color.name;
}

class BrightAnsiForegroundColorAdapter implements AnsiForegroundColor {
  final AnsiBasicColor color;

  const BrightAnsiForegroundColorAdapter(
    final this.color,
  );

  @override
  String get foregroundColorCode => "9" + color.paletteNumberTribit;

  @override
  String get name => "bright " + color.name;
}

abstract class AnsiForegroundColor {
  String get foregroundColorCode;

  String get name;
}

/// See https://jonasjacek.github.io/colors/
abstract class AnsiExtendedColors {
  static const AnsiExtendedColorPaletteRawImpl Black = AnsiExtendedColorPaletteRawImpl(0, "Black");
  static const AnsiExtendedColorPaletteRawImpl Maroon = AnsiExtendedColorPaletteRawImpl(1, "Maroon");
  static const AnsiExtendedColorPaletteRawImpl Green = AnsiExtendedColorPaletteRawImpl(2, "Green");
  static const AnsiExtendedColorPaletteRawImpl Olive = AnsiExtendedColorPaletteRawImpl(3, "Olive");
  static const AnsiExtendedColorPaletteRawImpl Navy = AnsiExtendedColorPaletteRawImpl(4, "Navy");
  static const AnsiExtendedColorPaletteRawImpl Purple = AnsiExtendedColorPaletteRawImpl(5, "Purple");
  static const AnsiExtendedColorPaletteRawImpl Teal = AnsiExtendedColorPaletteRawImpl(6, "Teal");
  static const AnsiExtendedColorPaletteRawImpl Silver = AnsiExtendedColorPaletteRawImpl(7, "Silver");
  static const AnsiExtendedColorPaletteRawImpl Grey = AnsiExtendedColorPaletteRawImpl(8, "Grey");
  static const AnsiExtendedColorPaletteRawImpl Red = AnsiExtendedColorPaletteRawImpl(9, "Red");
  static const AnsiExtendedColorPaletteRawImpl Lime = AnsiExtendedColorPaletteRawImpl(10, "Lime");
  static const AnsiExtendedColorPaletteRawImpl Yellow = AnsiExtendedColorPaletteRawImpl(11, "Yellow");
  static const AnsiExtendedColorPaletteRawImpl Blue = AnsiExtendedColorPaletteRawImpl(12, "Blue");
  static const AnsiExtendedColorPaletteRawImpl Fuchsia = AnsiExtendedColorPaletteRawImpl(13, "Fuchsia");
  static const AnsiExtendedColorPaletteRawImpl Aqua = AnsiExtendedColorPaletteRawImpl(14, "Aqua");
  static const AnsiExtendedColorPaletteRawImpl White = AnsiExtendedColorPaletteRawImpl(15, "White");
  static const AnsiExtendedColorPaletteRawImpl Grey0 = AnsiExtendedColorPaletteRawImpl(16, "Grey0");
  static const AnsiExtendedColorPaletteRawImpl NavyBlue = AnsiExtendedColorPaletteRawImpl(17, "NavyBlue");
  static const AnsiExtendedColorPaletteRawImpl DarkBlue = AnsiExtendedColorPaletteRawImpl(18, "DarkBlue");
  static const AnsiExtendedColorPaletteRawImpl Blue3 = AnsiExtendedColorPaletteRawImpl(19, "Blue3");
  static const AnsiExtendedColorPaletteRawImpl Blue3_2 = AnsiExtendedColorPaletteRawImpl(20, "Blue3_2");
  static const AnsiExtendedColorPaletteRawImpl Blue1 = AnsiExtendedColorPaletteRawImpl(21, "Blue1");
  static const AnsiExtendedColorPaletteRawImpl DarkGreen = AnsiExtendedColorPaletteRawImpl(22, "DarkGreen");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue4 = AnsiExtendedColorPaletteRawImpl(23, "DeepSkyBlue4");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue4_2 = AnsiExtendedColorPaletteRawImpl(24, "DeepSkyBlue4_2");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue4_3 = AnsiExtendedColorPaletteRawImpl(25, "DeepSkyBlue4_3");
  static const AnsiExtendedColorPaletteRawImpl DodgerBlue3 = AnsiExtendedColorPaletteRawImpl(26, "DodgerBlue3");
  static const AnsiExtendedColorPaletteRawImpl DodgerBlue2 = AnsiExtendedColorPaletteRawImpl(27, "DodgerBlue2");
  static const AnsiExtendedColorPaletteRawImpl Green4 = AnsiExtendedColorPaletteRawImpl(28, "Green4");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen4 = AnsiExtendedColorPaletteRawImpl(29, "SpringGreen4");
  static const AnsiExtendedColorPaletteRawImpl Turquoise4 = AnsiExtendedColorPaletteRawImpl(30, "Turquoise4");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue3 = AnsiExtendedColorPaletteRawImpl(31, "DeepSkyBlue3");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue3_2 = AnsiExtendedColorPaletteRawImpl(32, "DeepSkyBlue3_2");
  static const AnsiExtendedColorPaletteRawImpl DodgerBlue1 = AnsiExtendedColorPaletteRawImpl(33, "DodgerBlue1");
  static const AnsiExtendedColorPaletteRawImpl Green3 = AnsiExtendedColorPaletteRawImpl(34, "Green3");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen3 = AnsiExtendedColorPaletteRawImpl(35, "SpringGreen3");
  static const AnsiExtendedColorPaletteRawImpl DarkCyan = AnsiExtendedColorPaletteRawImpl(36, "DarkCyan");
  static const AnsiExtendedColorPaletteRawImpl LightSeaGreen = AnsiExtendedColorPaletteRawImpl(37, "LightSeaGreen");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue2 = AnsiExtendedColorPaletteRawImpl(38, "DeepSkyBlue2");
  static const AnsiExtendedColorPaletteRawImpl DeepSkyBlue1 = AnsiExtendedColorPaletteRawImpl(39, "DeepSkyBlue1");
  static const AnsiExtendedColorPaletteRawImpl Green3_2 = AnsiExtendedColorPaletteRawImpl(40, "Green3_2");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen3_2 = AnsiExtendedColorPaletteRawImpl(41, "SpringGreen3_2");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen2 = AnsiExtendedColorPaletteRawImpl(42, "SpringGreen2");
  static const AnsiExtendedColorPaletteRawImpl Cyan3 = AnsiExtendedColorPaletteRawImpl(43, "Cyan3");
  static const AnsiExtendedColorPaletteRawImpl DarkTurquoise = AnsiExtendedColorPaletteRawImpl(44, "DarkTurquoise");
  static const AnsiExtendedColorPaletteRawImpl Turquoise2 = AnsiExtendedColorPaletteRawImpl(45, "Turquoise2");
  static const AnsiExtendedColorPaletteRawImpl Green1 = AnsiExtendedColorPaletteRawImpl(46, "Green1");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen2_2 = AnsiExtendedColorPaletteRawImpl(47, "SpringGreen2_2");
  static const AnsiExtendedColorPaletteRawImpl SpringGreen1 = AnsiExtendedColorPaletteRawImpl(48, "SpringGreen1");
  static const AnsiExtendedColorPaletteRawImpl MediumSpringGreen =
      AnsiExtendedColorPaletteRawImpl(49, "MediumSpringGreen");
  static const AnsiExtendedColorPaletteRawImpl Cyan2 = AnsiExtendedColorPaletteRawImpl(50, "Cyan2");
  static const AnsiExtendedColorPaletteRawImpl Cyan1 = AnsiExtendedColorPaletteRawImpl(51, "Cyan1");
  static const AnsiExtendedColorPaletteRawImpl DarkRed = AnsiExtendedColorPaletteRawImpl(52, "DarkRed");
  static const AnsiExtendedColorPaletteRawImpl DeepPink4 = AnsiExtendedColorPaletteRawImpl(53, "DeepPink4");
  static const AnsiExtendedColorPaletteRawImpl Purple4 = AnsiExtendedColorPaletteRawImpl(54, "Purple4");
  static const AnsiExtendedColorPaletteRawImpl Purple4_2 = AnsiExtendedColorPaletteRawImpl(55, "Purple4_2");
  static const AnsiExtendedColorPaletteRawImpl Purple3 = AnsiExtendedColorPaletteRawImpl(56, "Purple3");
  static const AnsiExtendedColorPaletteRawImpl BlueViolet = AnsiExtendedColorPaletteRawImpl(57, "BlueViolet");
  static const AnsiExtendedColorPaletteRawImpl Orange4 = AnsiExtendedColorPaletteRawImpl(58, "Orange4");
  static const AnsiExtendedColorPaletteRawImpl Grey37 = AnsiExtendedColorPaletteRawImpl(59, "Grey37");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple4 = AnsiExtendedColorPaletteRawImpl(60, "MediumPurple4");
  static const AnsiExtendedColorPaletteRawImpl SlateBlue3 = AnsiExtendedColorPaletteRawImpl(61, "SlateBlue3");
  static const AnsiExtendedColorPaletteRawImpl SlateBlue3_2 = AnsiExtendedColorPaletteRawImpl(62, "SlateBlue3_2");
  static const AnsiExtendedColorPaletteRawImpl RoyalBlue1 = AnsiExtendedColorPaletteRawImpl(63, "RoyalBlue1");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse4 = AnsiExtendedColorPaletteRawImpl(64, "Chartreuse4");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen4 = AnsiExtendedColorPaletteRawImpl(65, "DarkSeaGreen4");
  static const AnsiExtendedColorPaletteRawImpl PaleTurquoise4 = AnsiExtendedColorPaletteRawImpl(66, "PaleTurquoise4");
  static const AnsiExtendedColorPaletteRawImpl SteelBlue = AnsiExtendedColorPaletteRawImpl(67, "SteelBlue");
  static const AnsiExtendedColorPaletteRawImpl SteelBlue3 = AnsiExtendedColorPaletteRawImpl(68, "SteelBlue3");
  static const AnsiExtendedColorPaletteRawImpl CornflowerBlue = AnsiExtendedColorPaletteRawImpl(69, "CornflowerBlue");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse3 = AnsiExtendedColorPaletteRawImpl(70, "Chartreuse3");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen4_2 = AnsiExtendedColorPaletteRawImpl(71, "DarkSeaGreen4_2");
  static const AnsiExtendedColorPaletteRawImpl CadetBlue = AnsiExtendedColorPaletteRawImpl(72, "CadetBlue");
  static const AnsiExtendedColorPaletteRawImpl CadetBlue_2 = AnsiExtendedColorPaletteRawImpl(73, "CadetBlue_2");
  static const AnsiExtendedColorPaletteRawImpl SkyBlue3 = AnsiExtendedColorPaletteRawImpl(74, "SkyBlue3");
  static const AnsiExtendedColorPaletteRawImpl SteelBlue1 = AnsiExtendedColorPaletteRawImpl(75, "SteelBlue1");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse3_2 = AnsiExtendedColorPaletteRawImpl(76, "Chartreuse3_2");
  static const AnsiExtendedColorPaletteRawImpl PaleGreen3 = AnsiExtendedColorPaletteRawImpl(77, "PaleGreen3");
  static const AnsiExtendedColorPaletteRawImpl SeaGreen3 = AnsiExtendedColorPaletteRawImpl(78, "SeaGreen3");
  static const AnsiExtendedColorPaletteRawImpl Aquamarine3 = AnsiExtendedColorPaletteRawImpl(79, "Aquamarine3");
  static const AnsiExtendedColorPaletteRawImpl MediumTurquoise = AnsiExtendedColorPaletteRawImpl(80, "MediumTurquoise");
  static const AnsiExtendedColorPaletteRawImpl SteelBlue1_2 = AnsiExtendedColorPaletteRawImpl(81, "SteelBlue1_2");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse2 = AnsiExtendedColorPaletteRawImpl(82, "Chartreuse2");
  static const AnsiExtendedColorPaletteRawImpl SeaGreen2 = AnsiExtendedColorPaletteRawImpl(83, "SeaGreen2");
  static const AnsiExtendedColorPaletteRawImpl SeaGreen1 = AnsiExtendedColorPaletteRawImpl(84, "SeaGreen1");
  static const AnsiExtendedColorPaletteRawImpl SeaGreen1_2 = AnsiExtendedColorPaletteRawImpl(85, "SeaGreen1_2");
  static const AnsiExtendedColorPaletteRawImpl Aquamarine1 = AnsiExtendedColorPaletteRawImpl(86, "Aquamarine1");
  static const AnsiExtendedColorPaletteRawImpl DarkSlateGray2 = AnsiExtendedColorPaletteRawImpl(87, "DarkSlateGray2");
  static const AnsiExtendedColorPaletteRawImpl DarkRed_2 = AnsiExtendedColorPaletteRawImpl(88, "DarkRed_2");
  static const AnsiExtendedColorPaletteRawImpl DeepPink4_2 = AnsiExtendedColorPaletteRawImpl(89, "DeepPink4_2");
  static const AnsiExtendedColorPaletteRawImpl DarkMagenta = AnsiExtendedColorPaletteRawImpl(90, "DarkMagenta");
  static const AnsiExtendedColorPaletteRawImpl DarkMagenta_2 = AnsiExtendedColorPaletteRawImpl(91, "DarkMagenta_2");
  static const AnsiExtendedColorPaletteRawImpl DarkViolet = AnsiExtendedColorPaletteRawImpl(92, "DarkViolet");
  static const AnsiExtendedColorPaletteRawImpl Purple_2 = AnsiExtendedColorPaletteRawImpl(93, "Purple_2");
  static const AnsiExtendedColorPaletteRawImpl Orange4_2 = AnsiExtendedColorPaletteRawImpl(94, "Orange4_2");
  static const AnsiExtendedColorPaletteRawImpl LightPink4 = AnsiExtendedColorPaletteRawImpl(95, "LightPink4");
  static const AnsiExtendedColorPaletteRawImpl Plum4 = AnsiExtendedColorPaletteRawImpl(96, "Plum4");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple3 = AnsiExtendedColorPaletteRawImpl(97, "MediumPurple3");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple3_2 = AnsiExtendedColorPaletteRawImpl(98, "MediumPurple3_2");
  static const AnsiExtendedColorPaletteRawImpl SlateBlue1 = AnsiExtendedColorPaletteRawImpl(99, "SlateBlue1");
  static const AnsiExtendedColorPaletteRawImpl Yellow4 = AnsiExtendedColorPaletteRawImpl(100, "Yellow4");
  static const AnsiExtendedColorPaletteRawImpl Wheat4 = AnsiExtendedColorPaletteRawImpl(101, "Wheat4");
  static const AnsiExtendedColorPaletteRawImpl Grey53 = AnsiExtendedColorPaletteRawImpl(102, "Grey53");
  static const AnsiExtendedColorPaletteRawImpl LightSlateGrey = AnsiExtendedColorPaletteRawImpl(103, "LightSlateGrey");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple = AnsiExtendedColorPaletteRawImpl(104, "MediumPurple");
  static const AnsiExtendedColorPaletteRawImpl LightSlateBlue = AnsiExtendedColorPaletteRawImpl(105, "LightSlateBlue");
  static const AnsiExtendedColorPaletteRawImpl Yellow4_2 = AnsiExtendedColorPaletteRawImpl(106, "Yellow4_2");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen3 =
      AnsiExtendedColorPaletteRawImpl(107, "DarkOliveGreen3");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen = AnsiExtendedColorPaletteRawImpl(108, "DarkSeaGreen");
  static const AnsiExtendedColorPaletteRawImpl LightSkyBlue3 = AnsiExtendedColorPaletteRawImpl(109, "LightSkyBlue3");
  static const AnsiExtendedColorPaletteRawImpl LightSkyBlue3_2 =
      AnsiExtendedColorPaletteRawImpl(110, "LightSkyBlue3_2");
  static const AnsiExtendedColorPaletteRawImpl SkyBlue2 = AnsiExtendedColorPaletteRawImpl(111, "SkyBlue2");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse2_2 = AnsiExtendedColorPaletteRawImpl(112, "Chartreuse2_2");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen3_2 =
      AnsiExtendedColorPaletteRawImpl(113, "DarkOliveGreen3_2");
  static const AnsiExtendedColorPaletteRawImpl PaleGreen3_2 = AnsiExtendedColorPaletteRawImpl(114, "PaleGreen3_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen3 = AnsiExtendedColorPaletteRawImpl(115, "DarkSeaGreen3");
  static const AnsiExtendedColorPaletteRawImpl DarkSlateGray3 = AnsiExtendedColorPaletteRawImpl(116, "DarkSlateGray3");
  static const AnsiExtendedColorPaletteRawImpl SkyBlue1 = AnsiExtendedColorPaletteRawImpl(117, "SkyBlue1");
  static const AnsiExtendedColorPaletteRawImpl Chartreuse1 = AnsiExtendedColorPaletteRawImpl(118, "Chartreuse1");
  static const AnsiExtendedColorPaletteRawImpl LightGreen = AnsiExtendedColorPaletteRawImpl(119, "LightGreen");
  static const AnsiExtendedColorPaletteRawImpl LightGreen_2 = AnsiExtendedColorPaletteRawImpl(120, "LightGreen_2");
  static const AnsiExtendedColorPaletteRawImpl PaleGreen1 = AnsiExtendedColorPaletteRawImpl(121, "PaleGreen1");
  static const AnsiExtendedColorPaletteRawImpl Aquamarine1_2 = AnsiExtendedColorPaletteRawImpl(122, "Aquamarine1_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSlateGray1 = AnsiExtendedColorPaletteRawImpl(123, "DarkSlateGray1");
  static const AnsiExtendedColorPaletteRawImpl Red3 = AnsiExtendedColorPaletteRawImpl(124, "Red3");
  static const AnsiExtendedColorPaletteRawImpl DeepPink4_3 = AnsiExtendedColorPaletteRawImpl(125, "DeepPink4_3");
  static const AnsiExtendedColorPaletteRawImpl MediumVioletRed =
      AnsiExtendedColorPaletteRawImpl(126, "MediumVioletRed");
  static const AnsiExtendedColorPaletteRawImpl Magenta3 = AnsiExtendedColorPaletteRawImpl(127, "Magenta3");
  static const AnsiExtendedColorPaletteRawImpl DarkViolet_2 = AnsiExtendedColorPaletteRawImpl(128, "DarkViolet_2");
  static const AnsiExtendedColorPaletteRawImpl Purple_3 = AnsiExtendedColorPaletteRawImpl(129, "Purple_3");
  static const AnsiExtendedColorPaletteRawImpl DarkOrange3 = AnsiExtendedColorPaletteRawImpl(130, "DarkOrange3");
  static const AnsiExtendedColorPaletteRawImpl IndianRed = AnsiExtendedColorPaletteRawImpl(131, "IndianRed");
  static const AnsiExtendedColorPaletteRawImpl HotPink3 = AnsiExtendedColorPaletteRawImpl(132, "HotPink3");
  static const AnsiExtendedColorPaletteRawImpl MediumOrchid3 = AnsiExtendedColorPaletteRawImpl(133, "MediumOrchid3");
  static const AnsiExtendedColorPaletteRawImpl MediumOrchid = AnsiExtendedColorPaletteRawImpl(134, "MediumOrchid");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple2 = AnsiExtendedColorPaletteRawImpl(135, "MediumPurple2");
  static const AnsiExtendedColorPaletteRawImpl DarkGoldenrod = AnsiExtendedColorPaletteRawImpl(136, "DarkGoldenrod");
  static const AnsiExtendedColorPaletteRawImpl LightSalmon3 = AnsiExtendedColorPaletteRawImpl(137, "LightSalmon3");
  static const AnsiExtendedColorPaletteRawImpl RosyBrown = AnsiExtendedColorPaletteRawImpl(138, "RosyBrown");
  static const AnsiExtendedColorPaletteRawImpl Grey63 = AnsiExtendedColorPaletteRawImpl(139, "Grey63");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple2_2 =
      AnsiExtendedColorPaletteRawImpl(140, "MediumPurple2_2");
  static const AnsiExtendedColorPaletteRawImpl MediumPurple1 = AnsiExtendedColorPaletteRawImpl(141, "MediumPurple1");
  static const AnsiExtendedColorPaletteRawImpl Gold3 = AnsiExtendedColorPaletteRawImpl(142, "Gold3");
  static const AnsiExtendedColorPaletteRawImpl DarkKhaki = AnsiExtendedColorPaletteRawImpl(143, "DarkKhaki");
  static const AnsiExtendedColorPaletteRawImpl NavajoWhite3 = AnsiExtendedColorPaletteRawImpl(144, "NavajoWhite3");
  static const AnsiExtendedColorPaletteRawImpl Grey69 = AnsiExtendedColorPaletteRawImpl(145, "Grey69");
  static const AnsiExtendedColorPaletteRawImpl LightSteelBlue3 =
      AnsiExtendedColorPaletteRawImpl(146, "LightSteelBlue3");
  static const AnsiExtendedColorPaletteRawImpl LightSteelBlue = AnsiExtendedColorPaletteRawImpl(147, "LightSteelBlue");
  static const AnsiExtendedColorPaletteRawImpl Yellow3 = AnsiExtendedColorPaletteRawImpl(148, "Yellow3");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen3_3 =
      AnsiExtendedColorPaletteRawImpl(149, "DarkOliveGreen3_3");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen3_2 =
      AnsiExtendedColorPaletteRawImpl(150, "DarkSeaGreen3_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen2 = AnsiExtendedColorPaletteRawImpl(151, "DarkSeaGreen2");
  static const AnsiExtendedColorPaletteRawImpl LightCyan3 = AnsiExtendedColorPaletteRawImpl(152, "LightCyan3");
  static const AnsiExtendedColorPaletteRawImpl LightSkyBlue1 = AnsiExtendedColorPaletteRawImpl(153, "LightSkyBlue1");
  static const AnsiExtendedColorPaletteRawImpl GreenYellow = AnsiExtendedColorPaletteRawImpl(154, "GreenYellow");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen2 =
      AnsiExtendedColorPaletteRawImpl(155, "DarkOliveGreen2");
  static const AnsiExtendedColorPaletteRawImpl PaleGreen1_2 = AnsiExtendedColorPaletteRawImpl(156, "PaleGreen1_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen2_2 =
      AnsiExtendedColorPaletteRawImpl(157, "DarkSeaGreen2_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen1 = AnsiExtendedColorPaletteRawImpl(158, "DarkSeaGreen1");
  static const AnsiExtendedColorPaletteRawImpl PaleTurquoise1 = AnsiExtendedColorPaletteRawImpl(159, "PaleTurquoise1");
  static const AnsiExtendedColorPaletteRawImpl Red3_2 = AnsiExtendedColorPaletteRawImpl(160, "Red3_2");
  static const AnsiExtendedColorPaletteRawImpl DeepPink3 = AnsiExtendedColorPaletteRawImpl(161, "DeepPink3");
  static const AnsiExtendedColorPaletteRawImpl DeepPink3_2 = AnsiExtendedColorPaletteRawImpl(162, "DeepPink3_2");
  static const AnsiExtendedColorPaletteRawImpl Magenta3_2 = AnsiExtendedColorPaletteRawImpl(163, "Magenta3_2");
  static const AnsiExtendedColorPaletteRawImpl Magenta3_3 = AnsiExtendedColorPaletteRawImpl(164, "Magenta3_3");
  static const AnsiExtendedColorPaletteRawImpl Magenta2 = AnsiExtendedColorPaletteRawImpl(165, "Magenta2");
  static const AnsiExtendedColorPaletteRawImpl DarkOrange3_2 = AnsiExtendedColorPaletteRawImpl(166, "DarkOrange3_2");
  static const AnsiExtendedColorPaletteRawImpl IndianRed_2 = AnsiExtendedColorPaletteRawImpl(167, "IndianRed_2");
  static const AnsiExtendedColorPaletteRawImpl HotPink3_2 = AnsiExtendedColorPaletteRawImpl(168, "HotPink3_2");
  static const AnsiExtendedColorPaletteRawImpl HotPink2 = AnsiExtendedColorPaletteRawImpl(169, "HotPink2");
  static const AnsiExtendedColorPaletteRawImpl Orchid = AnsiExtendedColorPaletteRawImpl(170, "Orchid");
  static const AnsiExtendedColorPaletteRawImpl MediumOrchid1 = AnsiExtendedColorPaletteRawImpl(171, "MediumOrchid1");
  static const AnsiExtendedColorPaletteRawImpl Orange3 = AnsiExtendedColorPaletteRawImpl(172, "Orange3");
  static const AnsiExtendedColorPaletteRawImpl LightSalmon3_2 = AnsiExtendedColorPaletteRawImpl(173, "LightSalmon3_2");
  static const AnsiExtendedColorPaletteRawImpl LightPink3 = AnsiExtendedColorPaletteRawImpl(174, "LightPink3");
  static const AnsiExtendedColorPaletteRawImpl Pink3 = AnsiExtendedColorPaletteRawImpl(175, "Pink3");
  static const AnsiExtendedColorPaletteRawImpl Plum3 = AnsiExtendedColorPaletteRawImpl(176, "Plum3");
  static const AnsiExtendedColorPaletteRawImpl Violet = AnsiExtendedColorPaletteRawImpl(177, "Violet");
  static const AnsiExtendedColorPaletteRawImpl Gold3_2 = AnsiExtendedColorPaletteRawImpl(178, "Gold3_2");
  static const AnsiExtendedColorPaletteRawImpl LightGoldenrod3 =
      AnsiExtendedColorPaletteRawImpl(179, "LightGoldenrod3");
  static const AnsiExtendedColorPaletteRawImpl Tan = AnsiExtendedColorPaletteRawImpl(180, "Tan");
  static const AnsiExtendedColorPaletteRawImpl MistyRose3 = AnsiExtendedColorPaletteRawImpl(181, "MistyRose3");
  static const AnsiExtendedColorPaletteRawImpl Thistle3 = AnsiExtendedColorPaletteRawImpl(182, "Thistle3");
  static const AnsiExtendedColorPaletteRawImpl Plum2 = AnsiExtendedColorPaletteRawImpl(183, "Plum2");
  static const AnsiExtendedColorPaletteRawImpl Yellow3_2 = AnsiExtendedColorPaletteRawImpl(184, "Yellow3_2");
  static const AnsiExtendedColorPaletteRawImpl Khaki3 = AnsiExtendedColorPaletteRawImpl(185, "Khaki3");
  static const AnsiExtendedColorPaletteRawImpl LightGoldenrod2 =
      AnsiExtendedColorPaletteRawImpl(186, "LightGoldenrod2");
  static const AnsiExtendedColorPaletteRawImpl LightYellow3 = AnsiExtendedColorPaletteRawImpl(187, "LightYellow3");
  static const AnsiExtendedColorPaletteRawImpl Grey84 = AnsiExtendedColorPaletteRawImpl(188, "Grey84");
  static const AnsiExtendedColorPaletteRawImpl LightSteelBlue1 =
      AnsiExtendedColorPaletteRawImpl(189, "LightSteelBlue1");
  static const AnsiExtendedColorPaletteRawImpl Yellow2 = AnsiExtendedColorPaletteRawImpl(190, "Yellow2");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen1 =
      AnsiExtendedColorPaletteRawImpl(191, "DarkOliveGreen1");
  static const AnsiExtendedColorPaletteRawImpl DarkOliveGreen1_2 =
      AnsiExtendedColorPaletteRawImpl(192, "DarkOliveGreen1_2");
  static const AnsiExtendedColorPaletteRawImpl DarkSeaGreen1_2 =
      AnsiExtendedColorPaletteRawImpl(193, "DarkSeaGreen1_2");
  static const AnsiExtendedColorPaletteRawImpl Honeydew2 = AnsiExtendedColorPaletteRawImpl(194, "Honeydew2");
  static const AnsiExtendedColorPaletteRawImpl LightCyan1 = AnsiExtendedColorPaletteRawImpl(195, "LightCyan1");
  static const AnsiExtendedColorPaletteRawImpl Red1 = AnsiExtendedColorPaletteRawImpl(196, "Red1");
  static const AnsiExtendedColorPaletteRawImpl DeepPink2 = AnsiExtendedColorPaletteRawImpl(197, "DeepPink2");
  static const AnsiExtendedColorPaletteRawImpl DeepPink1 = AnsiExtendedColorPaletteRawImpl(198, "DeepPink1");
  static const AnsiExtendedColorPaletteRawImpl DeepPink1_2 = AnsiExtendedColorPaletteRawImpl(199, "DeepPink1_2");
  static const AnsiExtendedColorPaletteRawImpl Magenta2_2 = AnsiExtendedColorPaletteRawImpl(200, "Magenta2_2");
  static const AnsiExtendedColorPaletteRawImpl Magenta1 = AnsiExtendedColorPaletteRawImpl(201, "Magenta1");
  static const AnsiExtendedColorPaletteRawImpl OrangeRed1 = AnsiExtendedColorPaletteRawImpl(202, "OrangeRed1");
  static const AnsiExtendedColorPaletteRawImpl IndianRed1 = AnsiExtendedColorPaletteRawImpl(203, "IndianRed1");
  static const AnsiExtendedColorPaletteRawImpl IndianRed1_2 = AnsiExtendedColorPaletteRawImpl(204, "IndianRed1_2");
  static const AnsiExtendedColorPaletteRawImpl HotPink = AnsiExtendedColorPaletteRawImpl(205, "HotPink");
  static const AnsiExtendedColorPaletteRawImpl HotPink_2 = AnsiExtendedColorPaletteRawImpl(206, "HotPink_2");
  static const AnsiExtendedColorPaletteRawImpl MediumOrchid1_2 =
      AnsiExtendedColorPaletteRawImpl(207, "MediumOrchid1_2");
  static const AnsiExtendedColorPaletteRawImpl DarkOrange = AnsiExtendedColorPaletteRawImpl(208, "DarkOrange");
  static const AnsiExtendedColorPaletteRawImpl Salmon1 = AnsiExtendedColorPaletteRawImpl(209, "Salmon1");
  static const AnsiExtendedColorPaletteRawImpl LightCoral = AnsiExtendedColorPaletteRawImpl(210, "LightCoral");
  static const AnsiExtendedColorPaletteRawImpl PaleVioletRed1 = AnsiExtendedColorPaletteRawImpl(211, "PaleVioletRed1");
  static const AnsiExtendedColorPaletteRawImpl Orchid2 = AnsiExtendedColorPaletteRawImpl(212, "Orchid2");
  static const AnsiExtendedColorPaletteRawImpl Orchid1 = AnsiExtendedColorPaletteRawImpl(213, "Orchid1");
  static const AnsiExtendedColorPaletteRawImpl Orange1 = AnsiExtendedColorPaletteRawImpl(214, "Orange1");
  static const AnsiExtendedColorPaletteRawImpl SandyBrown = AnsiExtendedColorPaletteRawImpl(215, "SandyBrown");
  static const AnsiExtendedColorPaletteRawImpl LightSalmon1 = AnsiExtendedColorPaletteRawImpl(216, "LightSalmon1");
  static const AnsiExtendedColorPaletteRawImpl LightPink1 = AnsiExtendedColorPaletteRawImpl(217, "LightPink1");
  static const AnsiExtendedColorPaletteRawImpl Pink1 = AnsiExtendedColorPaletteRawImpl(218, "Pink1");
  static const AnsiExtendedColorPaletteRawImpl Plum1 = AnsiExtendedColorPaletteRawImpl(219, "Plum1");
  static const AnsiExtendedColorPaletteRawImpl Gold1 = AnsiExtendedColorPaletteRawImpl(220, "Gold1");
  static const AnsiExtendedColorPaletteRawImpl LightGoldenrod2_2 =
      AnsiExtendedColorPaletteRawImpl(221, "LightGoldenrod2_2");
  static const AnsiExtendedColorPaletteRawImpl LightGoldenrod2_3 =
      AnsiExtendedColorPaletteRawImpl(222, "LightGoldenrod2_3");
  static const AnsiExtendedColorPaletteRawImpl NavajoWhite1 = AnsiExtendedColorPaletteRawImpl(223, "NavajoWhite1");
  static const AnsiExtendedColorPaletteRawImpl MistyRose1 = AnsiExtendedColorPaletteRawImpl(224, "MistyRose1");
  static const AnsiExtendedColorPaletteRawImpl Thistle1 = AnsiExtendedColorPaletteRawImpl(225, "Thistle1");
  static const AnsiExtendedColorPaletteRawImpl Yellow1 = AnsiExtendedColorPaletteRawImpl(226, "Yellow1");
  static const AnsiExtendedColorPaletteRawImpl LightGoldenrod1 =
      AnsiExtendedColorPaletteRawImpl(227, "LightGoldenrod1");
  static const AnsiExtendedColorPaletteRawImpl Khaki1 = AnsiExtendedColorPaletteRawImpl(228, "Khaki1");
  static const AnsiExtendedColorPaletteRawImpl Wheat1 = AnsiExtendedColorPaletteRawImpl(229, "Wheat1");
  static const AnsiExtendedColorPaletteRawImpl Cornsilk1 = AnsiExtendedColorPaletteRawImpl(230, "Cornsilk1");
  static const AnsiExtendedColorPaletteRawImpl Grey100 = AnsiExtendedColorPaletteRawImpl(231, "Grey100");
  static const AnsiExtendedColorPaletteRawImpl Grey3 = AnsiExtendedColorPaletteRawImpl(232, "Grey3");
  static const AnsiExtendedColorPaletteRawImpl Grey7 = AnsiExtendedColorPaletteRawImpl(233, "Grey7");
  static const AnsiExtendedColorPaletteRawImpl Grey11 = AnsiExtendedColorPaletteRawImpl(234, "Grey11");
  static const AnsiExtendedColorPaletteRawImpl Grey15 = AnsiExtendedColorPaletteRawImpl(235, "Grey15");
  static const AnsiExtendedColorPaletteRawImpl Grey19 = AnsiExtendedColorPaletteRawImpl(236, "Grey19");
  static const AnsiExtendedColorPaletteRawImpl Grey23 = AnsiExtendedColorPaletteRawImpl(237, "Grey23");
  static const AnsiExtendedColorPaletteRawImpl Grey27 = AnsiExtendedColorPaletteRawImpl(238, "Grey27");
  static const AnsiExtendedColorPaletteRawImpl Grey30 = AnsiExtendedColorPaletteRawImpl(239, "Grey30");
  static const AnsiExtendedColorPaletteRawImpl Grey35 = AnsiExtendedColorPaletteRawImpl(240, "Grey35");
  static const AnsiExtendedColorPaletteRawImpl Grey39 = AnsiExtendedColorPaletteRawImpl(241, "Grey39");
  static const AnsiExtendedColorPaletteRawImpl Grey42 = AnsiExtendedColorPaletteRawImpl(242, "Grey42");
  static const AnsiExtendedColorPaletteRawImpl Grey46 = AnsiExtendedColorPaletteRawImpl(243, "Grey46");
  static const AnsiExtendedColorPaletteRawImpl Grey50 = AnsiExtendedColorPaletteRawImpl(244, "Grey50");
  static const AnsiExtendedColorPaletteRawImpl Grey54 = AnsiExtendedColorPaletteRawImpl(245, "Grey54");
  static const AnsiExtendedColorPaletteRawImpl Grey58 = AnsiExtendedColorPaletteRawImpl(246, "Grey58");
  static const AnsiExtendedColorPaletteRawImpl Grey62 = AnsiExtendedColorPaletteRawImpl(247, "Grey62");
  static const AnsiExtendedColorPaletteRawImpl Grey66 = AnsiExtendedColorPaletteRawImpl(248, "Grey66");
  static const AnsiExtendedColorPaletteRawImpl Grey70 = AnsiExtendedColorPaletteRawImpl(249, "Grey70");
  static const AnsiExtendedColorPaletteRawImpl Grey74 = AnsiExtendedColorPaletteRawImpl(250, "Grey74");
  static const AnsiExtendedColorPaletteRawImpl Grey78 = AnsiExtendedColorPaletteRawImpl(251, "Grey78");
  static const AnsiExtendedColorPaletteRawImpl Grey82 = AnsiExtendedColorPaletteRawImpl(252, "Grey82");
  static const AnsiExtendedColorPaletteRawImpl Grey85 = AnsiExtendedColorPaletteRawImpl(253, "Grey85");
  static const AnsiExtendedColorPaletteRawImpl Grey89 = AnsiExtendedColorPaletteRawImpl(254, "Grey89");
  static const AnsiExtendedColorPaletteRawImpl Grey93 = AnsiExtendedColorPaletteRawImpl(255, "Grey93");
}

/// 0 - 7: standard colors (as in ESC [ 30–37 m).
/// 8 - 15: high intensity colors (as in ESC [ 90–97 m).
/// 16 - 231: 6 × 6 × 6 cube (216 colors): 16 + 36 × r + 6 × g + b (0 ≤ r, g, b ≤ 5).
/// 232 - 255: grayscale from black to white in 24 steps.
///
/// See: https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
/// See: https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
abstract class AnsiExtendedColorPalette {
  int get paletteNumberByte;
}

class AnsiExtendedColorPaletteRawImpl implements AnsiExtendedColorPalette {
  @override
  final int paletteNumberByte;
  final String name;

  const AnsiExtendedColorPaletteRawImpl(
    final this.paletteNumberByte,
    final this.name,
  );
}

String ansiSetTextStyles({
  final bool bold = false,
  final bool underscore = false,
  final bool blink = false,
  final bool inverted = false,
}) =>
    _ansiSelectGraphicsRendition(
      CompositeGraphicsRenditionNode(
        [
          if (bold) const GraphicsRenditionNodeHighlightImpl(),
          if (underscore) const GraphicsRenditionNodeUnderlineImpl(),
          if (blink) const GraphicsRenditionNodeBlinkImpl(),
          if (inverted) const GraphicsRenditionNodeInvertedImpl(),
        ],
      ),
    );

String ansiSetExtendedForegroundColor(
  final AnsiExtendedColorPalette color,
) =>
    _ansiSelectGraphicsRendition(
      GraphicsRenditionNodeExtendedTextColorImpl(color),
    );

String ansiSetExtendedBackgroundColor(
  final AnsiExtendedColorPalette color,
) =>
    _ansiSelectGraphicsRendition(
      GraphicsRenditionNodeExtendedBackgroundColorImpl(color),
    );

String ansiSetTextColor(
  final AnsiForegroundColor color,
) =>
    _ansiSelectGraphicsRendition(
      GraphicsRenditionNodeColorImpl(
        color.foregroundColorCode,
      ),
    );

String ansiSetBackgroundColor(
  final AnsiBackgroundColor color,
) =>
    _ansiSelectGraphicsRendition(
      GraphicsRenditionNodeColorImpl(
        color.backgroundColorCode,
      ),
    );

/// Set graphics rendition mode.
String _ansiSelectGraphicsRendition(
  final GraphicsRenditionNode nodes,
) =>
    controlSequenceIdentifier + nodes.commands.join(";") + "m";

/// Base node for graphics rendition command nodes.
abstract class GraphicsRenditionNode {
  Iterable<String> get commands;
}

/// Reset: turn off all attributes.
class GraphicsRenditionNodeResetImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeResetImpl();

  @override
  Iterable<String> get commands => const ["0"];
}

/// Bold (or bright, it’s up to the terminal and the user config to some extent).
class GraphicsRenditionNodeHighlightImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeHighlightImpl();

  @override
  Iterable<String> get commands => const ["1"];
}

/// Italic.
class GraphicsRenditionNodeItalicImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeItalicImpl();

  @override
  Iterable<String> get commands => const ["3"];
}

/// Underline.
class GraphicsRenditionNodeUnderlineImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeUnderlineImpl();

  @override
  Iterable<String> get commands => const ["4"];
}

/// Blink.
class GraphicsRenditionNodeBlinkImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeBlinkImpl();

  @override
  Iterable<String> get commands => const ["5"];
}

/// Inverted also known as reversed.
///
/// Inverts colors.
class GraphicsRenditionNodeInvertedImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeInvertedImpl();

  @override
  Iterable<String> get commands => const ["7"];
}

/// Set text colour from the basic colour palette of 0–7.
class GraphicsRenditionNodeTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicColor color;

  const GraphicsRenditionNodeTextColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands => ["3" + color.paletteNumberTribit.toString()];
}

/// Set text colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicColor color;

  const GraphicsRenditionNodeBrightTextColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands sync* {
    yield "9" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour.
class GraphicsRenditionNodeBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicColor color;

  const GraphicsRenditionNodeBackgroundColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands sync* {
    yield "4" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicColor color;

  const GraphicsRenditionNodeBrightBackgroundColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands sync* {
    yield "10" + color.paletteNumberTribit.toString();
  }
}

/// Sets text or background color. Bright or normal color.
/// What will be set depends on the value given.
///
/// This is an unsafe operation and should be avoided.
class GraphicsRenditionNodeColorImpl implements GraphicsRenditionNode {
  final String raw;

  const GraphicsRenditionNodeColorImpl(
    final this.raw,
  );

  @override
  Iterable<String> get commands sync* {
    yield raw;
  }
}

/// Set text colour to index n in a 256-colour palette
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedTextColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedTextColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands sync* {
    yield "38";
    yield "5";
    yield color.paletteNumberByte.toString();
  }
}

/// Set background colour to index n in a 256-colour palette.
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedBackgroundColorImpl(
    final this.color,
  );

  @override
  Iterable<String> get commands sync* {
    yield "48";
    yield "5";
    yield color.paletteNumberByte.toString();
  }
}

/// Set text color to an RGB value.
class GraphicsRenditionNodeRGBTextColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBTextColorImpl(
    final this.r,
    final this.g,
    final this.b,
  );

  @override
  Iterable<String> get commands sync* {
    yield "38";
    yield "2";
    yield r.toString();
    yield g.toString();
    yield b.toString();
  }
}

/// Set background colour to an RGB value.
class GraphicsRenditionNodeRGBBackgroundColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBBackgroundColorImpl(
    final this.r,
    final this.g,
    final this.b,
  );

  @override
  Iterable<String> get commands sync* {
    yield "48";
    yield "2";
    yield r.toString();
    yield g.toString();
    yield b.toString();
  }
}

/// Allows you to treat multiple [GraphicsRenditionNode] instances as one.
class CompositeGraphicsRenditionNode implements GraphicsRenditionNode {
  final Iterable<GraphicsRenditionNode> nodes;

  const CompositeGraphicsRenditionNode(
    final this.nodes,
  );

  @override
  Iterable<String> get commands sync* {
    for (final node in nodes) {
      yield* node.commands;
    }
  }
}

const controlSequenceIdentifier = "\x1b[";
