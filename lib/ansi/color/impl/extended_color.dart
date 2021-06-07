import '../../spec/extended_palette/range.dart';
import '../../spec/sizes.dart';
import '../interface/color_types/extended.dart';
import '../interface/named/extended.dart';

/// See https://jonasjacek.github.io/colors/
abstract class AnsiExtendedColors implements AnsiExtendedColorPalette {
  static const Black = AnsiExtendedColorPaletteRawImpl(smallestNumberExtendedPalette, "Black");
  static const Maroon = AnsiExtendedColorPaletteRawImpl(1, "Maroon");
  static const Green = AnsiExtendedColorPaletteRawImpl(2, "Green");
  static const Olive = AnsiExtendedColorPaletteRawImpl(3, "Olive");
  static const Navy = AnsiExtendedColorPaletteRawImpl(4, "Navy");
  static const Purple = AnsiExtendedColorPaletteRawImpl(5, "Purple");
  static const Teal = AnsiExtendedColorPaletteRawImpl(6, "Teal");
  static const Silver = AnsiExtendedColorPaletteRawImpl(7, "Silver");
  static const Grey = AnsiExtendedColorPaletteRawImpl(8, "Grey");
  static const Red = AnsiExtendedColorPaletteRawImpl(9, "Red");
  static const Lime = AnsiExtendedColorPaletteRawImpl(10, "Lime");
  static const Yellow = AnsiExtendedColorPaletteRawImpl(11, "Yellow");
  static const Blue = AnsiExtendedColorPaletteRawImpl(12, "Blue");
  static const Fuchsia = AnsiExtendedColorPaletteRawImpl(13, "Fuchsia");
  static const Aqua = AnsiExtendedColorPaletteRawImpl(14, "Aqua");
  static const White = AnsiExtendedColorPaletteRawImpl(15, "White");
  static const Grey0 = AnsiExtendedColorPaletteRawImpl(16, "Grey0");
  static const NavyBlue = AnsiExtendedColorPaletteRawImpl(17, "NavyBlue");
  static const DarkBlue = AnsiExtendedColorPaletteRawImpl(18, "DarkBlue");
  static const Blue3 = AnsiExtendedColorPaletteRawImpl(19, "Blue3");
  static const Blue3_2 = AnsiExtendedColorPaletteRawImpl(20, "Blue3_2");
  static const Blue1 = AnsiExtendedColorPaletteRawImpl(21, "Blue1");
  static const DarkGreen = AnsiExtendedColorPaletteRawImpl(22, "DarkGreen");
  static const DeepSkyBlue4 = AnsiExtendedColorPaletteRawImpl(23, "DeepSkyBlue4");
  static const DeepSkyBlue4_2 = AnsiExtendedColorPaletteRawImpl(24, "DeepSkyBlue4_2");
  static const DeepSkyBlue4_3 = AnsiExtendedColorPaletteRawImpl(25, "DeepSkyBlue4_3");
  static const DodgerBlue3 = AnsiExtendedColorPaletteRawImpl(26, "DodgerBlue3");
  static const DodgerBlue2 = AnsiExtendedColorPaletteRawImpl(27, "DodgerBlue2");
  static const Green4 = AnsiExtendedColorPaletteRawImpl(28, "Green4");
  static const SpringGreen4 = AnsiExtendedColorPaletteRawImpl(29, "SpringGreen4");
  static const Turquoise4 = AnsiExtendedColorPaletteRawImpl(30, "Turquoise4");
  static const DeepSkyBlue3 = AnsiExtendedColorPaletteRawImpl(31, "DeepSkyBlue3");
  static const DeepSkyBlue3_2 = AnsiExtendedColorPaletteRawImpl(32, "DeepSkyBlue3_2");
  static const DodgerBlue1 = AnsiExtendedColorPaletteRawImpl(33, "DodgerBlue1");
  static const Green3 = AnsiExtendedColorPaletteRawImpl(34, "Green3");
  static const SpringGreen3 = AnsiExtendedColorPaletteRawImpl(35, "SpringGreen3");
  static const DarkCyan = AnsiExtendedColorPaletteRawImpl(36, "DarkCyan");
  static const LightSeaGreen = AnsiExtendedColorPaletteRawImpl(37, "LightSeaGreen");
  static const DeepSkyBlue2 = AnsiExtendedColorPaletteRawImpl(38, "DeepSkyBlue2");
  static const DeepSkyBlue1 = AnsiExtendedColorPaletteRawImpl(39, "DeepSkyBlue1");
  static const Green3_2 = AnsiExtendedColorPaletteRawImpl(40, "Green3_2");
  static const SpringGreen3_2 = AnsiExtendedColorPaletteRawImpl(41, "SpringGreen3_2");
  static const SpringGreen2 = AnsiExtendedColorPaletteRawImpl(42, "SpringGreen2");
  static const Cyan3 = AnsiExtendedColorPaletteRawImpl(43, "Cyan3");
  static const DarkTurquoise = AnsiExtendedColorPaletteRawImpl(44, "DarkTurquoise");
  static const Turquoise2 = AnsiExtendedColorPaletteRawImpl(45, "Turquoise2");
  static const Green1 = AnsiExtendedColorPaletteRawImpl(46, "Green1");
  static const SpringGreen2_2 = AnsiExtendedColorPaletteRawImpl(47, "SpringGreen2_2");
  static const SpringGreen1 = AnsiExtendedColorPaletteRawImpl(48, "SpringGreen1");
  static const MediumSpringGreen = AnsiExtendedColorPaletteRawImpl(49, "MediumSpringGreen");
  static const Cyan2 = AnsiExtendedColorPaletteRawImpl(50, "Cyan2");
  static const Cyan1 = AnsiExtendedColorPaletteRawImpl(51, "Cyan1");
  static const DarkRed = AnsiExtendedColorPaletteRawImpl(52, "DarkRed");
  static const DeepPink4 = AnsiExtendedColorPaletteRawImpl(53, "DeepPink4");
  static const Purple4 = AnsiExtendedColorPaletteRawImpl(54, "Purple4");
  static const Purple4_2 = AnsiExtendedColorPaletteRawImpl(55, "Purple4_2");
  static const Purple3 = AnsiExtendedColorPaletteRawImpl(56, "Purple3");
  static const BlueViolet = AnsiExtendedColorPaletteRawImpl(57, "BlueViolet");
  static const Orange4 = AnsiExtendedColorPaletteRawImpl(58, "Orange4");
  static const Grey37 = AnsiExtendedColorPaletteRawImpl(59, "Grey37");
  static const MediumPurple4 = AnsiExtendedColorPaletteRawImpl(60, "MediumPurple4");
  static const SlateBlue3 = AnsiExtendedColorPaletteRawImpl(61, "SlateBlue3");
  static const SlateBlue3_2 = AnsiExtendedColorPaletteRawImpl(62, "SlateBlue3_2");
  static const RoyalBlue1 = AnsiExtendedColorPaletteRawImpl(63, "RoyalBlue1");
  static const Chartreuse4 = AnsiExtendedColorPaletteRawImpl(64, "Chartreuse4");
  static const DarkSeaGreen4 = AnsiExtendedColorPaletteRawImpl(65, "DarkSeaGreen4");
  static const PaleTurquoise4 = AnsiExtendedColorPaletteRawImpl(66, "PaleTurquoise4");
  static const SteelBlue = AnsiExtendedColorPaletteRawImpl(67, "SteelBlue");
  static const SteelBlue3 = AnsiExtendedColorPaletteRawImpl(68, "SteelBlue3");
  static const CornflowerBlue = AnsiExtendedColorPaletteRawImpl(69, "CornflowerBlue");
  static const Chartreuse3 = AnsiExtendedColorPaletteRawImpl(70, "Chartreuse3");
  static const DarkSeaGreen4_2 = AnsiExtendedColorPaletteRawImpl(71, "DarkSeaGreen4_2");
  static const CadetBlue = AnsiExtendedColorPaletteRawImpl(72, "CadetBlue");
  static const CadetBlue_2 = AnsiExtendedColorPaletteRawImpl(73, "CadetBlue_2");
  static const SkyBlue3 = AnsiExtendedColorPaletteRawImpl(74, "SkyBlue3");
  static const SteelBlue1 = AnsiExtendedColorPaletteRawImpl(75, "SteelBlue1");
  static const Chartreuse3_2 = AnsiExtendedColorPaletteRawImpl(76, "Chartreuse3_2");
  static const PaleGreen3 = AnsiExtendedColorPaletteRawImpl(77, "PaleGreen3");
  static const SeaGreen3 = AnsiExtendedColorPaletteRawImpl(78, "SeaGreen3");
  static const Aquamarine3 = AnsiExtendedColorPaletteRawImpl(79, "Aquamarine3");
  static const MediumTurquoise = AnsiExtendedColorPaletteRawImpl(80, "MediumTurquoise");
  static const SteelBlue1_2 = AnsiExtendedColorPaletteRawImpl(81, "SteelBlue1_2");
  static const Chartreuse2 = AnsiExtendedColorPaletteRawImpl(82, "Chartreuse2");
  static const SeaGreen2 = AnsiExtendedColorPaletteRawImpl(83, "SeaGreen2");
  static const SeaGreen1 = AnsiExtendedColorPaletteRawImpl(84, "SeaGreen1");
  static const SeaGreen1_2 = AnsiExtendedColorPaletteRawImpl(85, "SeaGreen1_2");
  static const Aquamarine1 = AnsiExtendedColorPaletteRawImpl(86, "Aquamarine1");
  static const DarkSlateGray2 = AnsiExtendedColorPaletteRawImpl(87, "DarkSlateGray2");
  static const DarkRed_2 = AnsiExtendedColorPaletteRawImpl(88, "DarkRed_2");
  static const DeepPink4_2 = AnsiExtendedColorPaletteRawImpl(89, "DeepPink4_2");
  static const DarkMagenta = AnsiExtendedColorPaletteRawImpl(90, "DarkMagenta");
  static const DarkMagenta_2 = AnsiExtendedColorPaletteRawImpl(91, "DarkMagenta_2");
  static const DarkViolet = AnsiExtendedColorPaletteRawImpl(92, "DarkViolet");
  static const Purple_2 = AnsiExtendedColorPaletteRawImpl(93, "Purple_2");
  static const Orange4_2 = AnsiExtendedColorPaletteRawImpl(94, "Orange4_2");
  static const LightPink4 = AnsiExtendedColorPaletteRawImpl(95, "LightPink4");
  static const Plum4 = AnsiExtendedColorPaletteRawImpl(96, "Plum4");
  static const MediumPurple3 = AnsiExtendedColorPaletteRawImpl(97, "MediumPurple3");
  static const MediumPurple3_2 = AnsiExtendedColorPaletteRawImpl(98, "MediumPurple3_2");
  static const SlateBlue1 = AnsiExtendedColorPaletteRawImpl(99, "SlateBlue1");
  static const Yellow4 = AnsiExtendedColorPaletteRawImpl(100, "Yellow4");
  static const Wheat4 = AnsiExtendedColorPaletteRawImpl(101, "Wheat4");
  static const Grey53 = AnsiExtendedColorPaletteRawImpl(102, "Grey53");
  static const LightSlateGrey = AnsiExtendedColorPaletteRawImpl(103, "LightSlateGrey");
  static const MediumPurple = AnsiExtendedColorPaletteRawImpl(104, "MediumPurple");
  static const LightSlateBlue = AnsiExtendedColorPaletteRawImpl(105, "LightSlateBlue");
  static const Yellow4_2 = AnsiExtendedColorPaletteRawImpl(106, "Yellow4_2");
  static const DarkOliveGreen3 = AnsiExtendedColorPaletteRawImpl(107, "DarkOliveGreen3");
  static const DarkSeaGreen = AnsiExtendedColorPaletteRawImpl(108, "DarkSeaGreen");
  static const LightSkyBlue3 = AnsiExtendedColorPaletteRawImpl(109, "LightSkyBlue3");
  static const LightSkyBlue3_2 = AnsiExtendedColorPaletteRawImpl(110, "LightSkyBlue3_2");
  static const SkyBlue2 = AnsiExtendedColorPaletteRawImpl(111, "SkyBlue2");
  static const Chartreuse2_2 = AnsiExtendedColorPaletteRawImpl(112, "Chartreuse2_2");
  static const DarkOliveGreen3_2 = AnsiExtendedColorPaletteRawImpl(113, "DarkOliveGreen3_2");
  static const PaleGreen3_2 = AnsiExtendedColorPaletteRawImpl(114, "PaleGreen3_2");
  static const DarkSeaGreen3 = AnsiExtendedColorPaletteRawImpl(115, "DarkSeaGreen3");
  static const DarkSlateGray3 = AnsiExtendedColorPaletteRawImpl(116, "DarkSlateGray3");
  static const SkyBlue1 = AnsiExtendedColorPaletteRawImpl(117, "SkyBlue1");
  static const Chartreuse1 = AnsiExtendedColorPaletteRawImpl(118, "Chartreuse1");
  static const LightGreen = AnsiExtendedColorPaletteRawImpl(119, "LightGreen");
  static const LightGreen_2 = AnsiExtendedColorPaletteRawImpl(120, "LightGreen_2");
  static const PaleGreen1 = AnsiExtendedColorPaletteRawImpl(121, "PaleGreen1");
  static const Aquamarine1_2 = AnsiExtendedColorPaletteRawImpl(122, "Aquamarine1_2");
  static const DarkSlateGray1 = AnsiExtendedColorPaletteRawImpl(123, "DarkSlateGray1");
  static const Red3 = AnsiExtendedColorPaletteRawImpl(124, "Red3");
  static const DeepPink4_3 = AnsiExtendedColorPaletteRawImpl(125, "DeepPink4_3");
  static const MediumVioletRed = AnsiExtendedColorPaletteRawImpl(126, "MediumVioletRed");
  static const Magenta3 = AnsiExtendedColorPaletteRawImpl(127, "Magenta3");
  static const DarkViolet_2 = AnsiExtendedColorPaletteRawImpl(128, "DarkViolet_2");
  static const Purple_3 = AnsiExtendedColorPaletteRawImpl(129, "Purple_3");
  static const DarkOrange3 = AnsiExtendedColorPaletteRawImpl(130, "DarkOrange3");
  static const IndianRed = AnsiExtendedColorPaletteRawImpl(131, "IndianRed");
  static const HotPink3 = AnsiExtendedColorPaletteRawImpl(132, "HotPink3");
  static const MediumOrchid3 = AnsiExtendedColorPaletteRawImpl(133, "MediumOrchid3");
  static const MediumOrchid = AnsiExtendedColorPaletteRawImpl(134, "MediumOrchid");
  static const MediumPurple2 = AnsiExtendedColorPaletteRawImpl(135, "MediumPurple2");
  static const DarkGoldenrod = AnsiExtendedColorPaletteRawImpl(136, "DarkGoldenrod");
  static const LightSalmon3 = AnsiExtendedColorPaletteRawImpl(137, "LightSalmon3");
  static const RosyBrown = AnsiExtendedColorPaletteRawImpl(138, "RosyBrown");
  static const Grey63 = AnsiExtendedColorPaletteRawImpl(139, "Grey63");
  static const MediumPurple2_2 = AnsiExtendedColorPaletteRawImpl(140, "MediumPurple2_2");
  static const MediumPurple1 = AnsiExtendedColorPaletteRawImpl(141, "MediumPurple1");
  static const Gold3 = AnsiExtendedColorPaletteRawImpl(142, "Gold3");
  static const DarkKhaki = AnsiExtendedColorPaletteRawImpl(143, "DarkKhaki");
  static const NavajoWhite3 = AnsiExtendedColorPaletteRawImpl(144, "NavajoWhite3");
  static const Grey69 = AnsiExtendedColorPaletteRawImpl(145, "Grey69");
  static const LightSteelBlue3 = AnsiExtendedColorPaletteRawImpl(146, "LightSteelBlue3");
  static const LightSteelBlue = AnsiExtendedColorPaletteRawImpl(147, "LightSteelBlue");
  static const Yellow3 = AnsiExtendedColorPaletteRawImpl(148, "Yellow3");
  static const DarkOliveGreen3_3 = AnsiExtendedColorPaletteRawImpl(149, "DarkOliveGreen3_3");
  static const DarkSeaGreen3_2 = AnsiExtendedColorPaletteRawImpl(150, "DarkSeaGreen3_2");
  static const DarkSeaGreen2 = AnsiExtendedColorPaletteRawImpl(151, "DarkSeaGreen2");
  static const LightCyan3 = AnsiExtendedColorPaletteRawImpl(152, "LightCyan3");
  static const LightSkyBlue1 = AnsiExtendedColorPaletteRawImpl(153, "LightSkyBlue1");
  static const GreenYellow = AnsiExtendedColorPaletteRawImpl(154, "GreenYellow");
  static const DarkOliveGreen2 = AnsiExtendedColorPaletteRawImpl(155, "DarkOliveGreen2");
  static const PaleGreen1_2 = AnsiExtendedColorPaletteRawImpl(156, "PaleGreen1_2");
  static const DarkSeaGreen2_2 = AnsiExtendedColorPaletteRawImpl(157, "DarkSeaGreen2_2");
  static const DarkSeaGreen1 = AnsiExtendedColorPaletteRawImpl(158, "DarkSeaGreen1");
  static const PaleTurquoise1 = AnsiExtendedColorPaletteRawImpl(159, "PaleTurquoise1");
  static const Red3_2 = AnsiExtendedColorPaletteRawImpl(160, "Red3_2");
  static const DeepPink3 = AnsiExtendedColorPaletteRawImpl(161, "DeepPink3");
  static const DeepPink3_2 = AnsiExtendedColorPaletteRawImpl(162, "DeepPink3_2");
  static const Magenta3_2 = AnsiExtendedColorPaletteRawImpl(163, "Magenta3_2");
  static const Magenta3_3 = AnsiExtendedColorPaletteRawImpl(164, "Magenta3_3");
  static const Magenta2 = AnsiExtendedColorPaletteRawImpl(165, "Magenta2");
  static const DarkOrange3_2 = AnsiExtendedColorPaletteRawImpl(166, "DarkOrange3_2");
  static const IndianRed_2 = AnsiExtendedColorPaletteRawImpl(167, "IndianRed_2");
  static const HotPink3_2 = AnsiExtendedColorPaletteRawImpl(168, "HotPink3_2");
  static const HotPink2 = AnsiExtendedColorPaletteRawImpl(169, "HotPink2");
  static const Orchid = AnsiExtendedColorPaletteRawImpl(170, "Orchid");
  static const MediumOrchid1 = AnsiExtendedColorPaletteRawImpl(171, "MediumOrchid1");
  static const Orange3 = AnsiExtendedColorPaletteRawImpl(172, "Orange3");
  static const LightSalmon3_2 = AnsiExtendedColorPaletteRawImpl(173, "LightSalmon3_2");
  static const LightPink3 = AnsiExtendedColorPaletteRawImpl(174, "LightPink3");
  static const Pink3 = AnsiExtendedColorPaletteRawImpl(175, "Pink3");
  static const Plum3 = AnsiExtendedColorPaletteRawImpl(176, "Plum3");
  static const Violet = AnsiExtendedColorPaletteRawImpl(177, "Violet");
  static const Gold3_2 = AnsiExtendedColorPaletteRawImpl(178, "Gold3_2");
  static const LightGoldenrod3 = AnsiExtendedColorPaletteRawImpl(179, "LightGoldenrod3");
  static const Tan = AnsiExtendedColorPaletteRawImpl(180, "Tan");
  static const MistyRose3 = AnsiExtendedColorPaletteRawImpl(181, "MistyRose3");
  static const Thistle3 = AnsiExtendedColorPaletteRawImpl(182, "Thistle3");
  static const Plum2 = AnsiExtendedColorPaletteRawImpl(183, "Plum2");
  static const Yellow3_2 = AnsiExtendedColorPaletteRawImpl(184, "Yellow3_2");
  static const Khaki3 = AnsiExtendedColorPaletteRawImpl(185, "Khaki3");
  static const LightGoldenrod2 = AnsiExtendedColorPaletteRawImpl(186, "LightGoldenrod2");
  static const LightYellow3 = AnsiExtendedColorPaletteRawImpl(187, "LightYellow3");
  static const Grey84 = AnsiExtendedColorPaletteRawImpl(188, "Grey84");
  static const LightSteelBlue1 = AnsiExtendedColorPaletteRawImpl(189, "LightSteelBlue1");
  static const Yellow2 = AnsiExtendedColorPaletteRawImpl(190, "Yellow2");
  static const DarkOliveGreen1 = AnsiExtendedColorPaletteRawImpl(191, "DarkOliveGreen1");
  static const DarkOliveGreen1_2 = AnsiExtendedColorPaletteRawImpl(192, "DarkOliveGreen1_2");
  static const DarkSeaGreen1_2 = AnsiExtendedColorPaletteRawImpl(193, "DarkSeaGreen1_2");
  static const Honeydew2 = AnsiExtendedColorPaletteRawImpl(194, "Honeydew2");
  static const LightCyan1 = AnsiExtendedColorPaletteRawImpl(195, "LightCyan1");
  static const Red1 = AnsiExtendedColorPaletteRawImpl(196, "Red1");
  static const DeepPink2 = AnsiExtendedColorPaletteRawImpl(197, "DeepPink2");
  static const DeepPink1 = AnsiExtendedColorPaletteRawImpl(198, "DeepPink1");
  static const DeepPink1_2 = AnsiExtendedColorPaletteRawImpl(199, "DeepPink1_2");
  static const Magenta2_2 = AnsiExtendedColorPaletteRawImpl(200, "Magenta2_2");
  static const Magenta1 = AnsiExtendedColorPaletteRawImpl(201, "Magenta1");
  static const OrangeRed1 = AnsiExtendedColorPaletteRawImpl(202, "OrangeRed1");
  static const IndianRed1 = AnsiExtendedColorPaletteRawImpl(203, "IndianRed1");
  static const IndianRed1_2 = AnsiExtendedColorPaletteRawImpl(204, "IndianRed1_2");
  static const HotPink = AnsiExtendedColorPaletteRawImpl(205, "HotPink");
  static const HotPink_2 = AnsiExtendedColorPaletteRawImpl(206, "HotPink_2");
  static const MediumOrchid1_2 = AnsiExtendedColorPaletteRawImpl(207, "MediumOrchid1_2");
  static const DarkOrange = AnsiExtendedColorPaletteRawImpl(208, "DarkOrange");
  static const Salmon1 = AnsiExtendedColorPaletteRawImpl(209, "Salmon1");
  static const LightCoral = AnsiExtendedColorPaletteRawImpl(210, "LightCoral");
  static const PaleVioletRed1 = AnsiExtendedColorPaletteRawImpl(211, "PaleVioletRed1");
  static const Orchid2 = AnsiExtendedColorPaletteRawImpl(212, "Orchid2");
  static const Orchid1 = AnsiExtendedColorPaletteRawImpl(213, "Orchid1");
  static const Orange1 = AnsiExtendedColorPaletteRawImpl(214, "Orange1");
  static const SandyBrown = AnsiExtendedColorPaletteRawImpl(215, "SandyBrown");
  static const LightSalmon1 = AnsiExtendedColorPaletteRawImpl(216, "LightSalmon1");
  static const LightPink1 = AnsiExtendedColorPaletteRawImpl(217, "LightPink1");
  static const Pink1 = AnsiExtendedColorPaletteRawImpl(218, "Pink1");
  static const Plum1 = AnsiExtendedColorPaletteRawImpl(219, "Plum1");
  static const Gold1 = AnsiExtendedColorPaletteRawImpl(220, "Gold1");
  static const LightGoldenrod2_2 = AnsiExtendedColorPaletteRawImpl(221, "LightGoldenrod2_2");
  static const LightGoldenrod2_3 = AnsiExtendedColorPaletteRawImpl(222, "LightGoldenrod2_3");
  static const NavajoWhite1 = AnsiExtendedColorPaletteRawImpl(223, "NavajoWhite1");
  static const MistyRose1 = AnsiExtendedColorPaletteRawImpl(224, "MistyRose1");
  static const Thistle1 = AnsiExtendedColorPaletteRawImpl(225, "Thistle1");
  static const Yellow1 = AnsiExtendedColorPaletteRawImpl(226, "Yellow1");
  static const LightGoldenrod1 = AnsiExtendedColorPaletteRawImpl(227, "LightGoldenrod1");
  static const Khaki1 = AnsiExtendedColorPaletteRawImpl(228, "Khaki1");
  static const Wheat1 = AnsiExtendedColorPaletteRawImpl(229, "Wheat1");
  static const Cornsilk1 = AnsiExtendedColorPaletteRawImpl(230, "Cornsilk1");
  static const Grey100 = AnsiExtendedColorPaletteRawImpl(231, "Grey100");
  static const Grey3 = AnsiExtendedColorPaletteRawImpl(232, "Grey3");
  static const Grey7 = AnsiExtendedColorPaletteRawImpl(233, "Grey7");
  static const Grey11 = AnsiExtendedColorPaletteRawImpl(234, "Grey11");
  static const Grey15 = AnsiExtendedColorPaletteRawImpl(235, "Grey15");
  static const Grey19 = AnsiExtendedColorPaletteRawImpl(236, "Grey19");
  static const Grey23 = AnsiExtendedColorPaletteRawImpl(237, "Grey23");
  static const Grey27 = AnsiExtendedColorPaletteRawImpl(238, "Grey27");
  static const Grey30 = AnsiExtendedColorPaletteRawImpl(239, "Grey30");
  static const Grey35 = AnsiExtendedColorPaletteRawImpl(240, "Grey35");
  static const Grey39 = AnsiExtendedColorPaletteRawImpl(241, "Grey39");
  static const Grey42 = AnsiExtendedColorPaletteRawImpl(242, "Grey42");
  static const Grey46 = AnsiExtendedColorPaletteRawImpl(243, "Grey46");
  static const Grey50 = AnsiExtendedColorPaletteRawImpl(244, "Grey50");
  static const Grey54 = AnsiExtendedColorPaletteRawImpl(245, "Grey54");
  static const Grey58 = AnsiExtendedColorPaletteRawImpl(246, "Grey58");
  static const Grey62 = AnsiExtendedColorPaletteRawImpl(247, "Grey62");
  static const Grey66 = AnsiExtendedColorPaletteRawImpl(248, "Grey66");
  static const Grey70 = AnsiExtendedColorPaletteRawImpl(249, "Grey70");
  static const Grey74 = AnsiExtendedColorPaletteRawImpl(250, "Grey74");
  static const Grey78 = AnsiExtendedColorPaletteRawImpl(251, "Grey78");
  static const Grey82 = AnsiExtendedColorPaletteRawImpl(252, "Grey82");
  static const Grey85 = AnsiExtendedColorPaletteRawImpl(253, "Grey85");
  static const Grey89 = AnsiExtendedColorPaletteRawImpl(254, "Grey89");
  static const Grey93 = AnsiExtendedColorPaletteRawImpl(biggestNumberExtendedPalette, "Grey93");

  static const all = [
    Black,
    Maroon,
    Green,
    Olive,
    Navy,
    Purple,
    Teal,
    Silver,
    Grey,
    Red,
    Lime,
    Yellow,
    Blue,
    Fuchsia,
    Aqua,
    White,
    Grey0,
    NavyBlue,
    DarkBlue,
    Blue3,
    Blue3_2,
    Blue1,
    DarkGreen,
    DeepSkyBlue4,
    DeepSkyBlue4_2,
    DeepSkyBlue4_3,
    DodgerBlue3,
    DodgerBlue2,
    Green4,
    SpringGreen4,
    Turquoise4,
    DeepSkyBlue3,
    DeepSkyBlue3_2,
    DodgerBlue1,
    Green3,
    SpringGreen3,
    DarkCyan,
    LightSeaGreen,
    DeepSkyBlue2,
    DeepSkyBlue1,
    Green3_2,
    SpringGreen3_2,
    SpringGreen2,
    Cyan3,
    DarkTurquoise,
    Turquoise2,
    Green1,
    SpringGreen2_2,
    SpringGreen1,
    MediumSpringGreen,
    Cyan2,
    Cyan1,
    DarkRed,
    DeepPink4,
    Purple4,
    Purple4_2,
    Purple3,
    BlueViolet,
    Orange4,
    Grey37,
    MediumPurple4,
    SlateBlue3,
    SlateBlue3_2,
    RoyalBlue1,
    Chartreuse4,
    DarkSeaGreen4,
    PaleTurquoise4,
    SteelBlue,
    SteelBlue3,
    CornflowerBlue,
    Chartreuse3,
    DarkSeaGreen4_2,
    CadetBlue,
    CadetBlue_2,
    SkyBlue3,
    SteelBlue1,
    Chartreuse3_2,
    PaleGreen3,
    SeaGreen3,
    Aquamarine3,
    MediumTurquoise,
    SteelBlue1_2,
    Chartreuse2,
    SeaGreen2,
    SeaGreen1,
    SeaGreen1_2,
    Aquamarine1,
    DarkSlateGray2,
    DarkRed_2,
    DeepPink4_2,
    DarkMagenta,
    DarkMagenta_2,
    DarkViolet,
    Purple_2,
    Orange4_2,
    LightPink4,
    Plum4,
    MediumPurple3,
    MediumPurple3_2,
    SlateBlue1,
    Yellow4,
    Wheat4,
    Grey53,
    LightSlateGrey,
    MediumPurple,
    LightSlateBlue,
    Yellow4_2,
    DarkOliveGreen3,
    DarkSeaGreen,
    LightSkyBlue3,
    LightSkyBlue3_2,
    SkyBlue2,
    Chartreuse2_2,
    DarkOliveGreen3_2,
    PaleGreen3_2,
    DarkSeaGreen3,
    DarkSlateGray3,
    SkyBlue1,
    Chartreuse1,
    LightGreen,
    LightGreen_2,
    PaleGreen1,
    Aquamarine1_2,
    DarkSlateGray1,
    Red3,
    DeepPink4_3,
    MediumVioletRed,
    Magenta3,
    DarkViolet_2,
    Purple_3,
    DarkOrange3,
    IndianRed,
    HotPink3,
    MediumOrchid3,
    MediumOrchid,
    MediumPurple2,
    DarkGoldenrod,
    LightSalmon3,
    RosyBrown,
    Grey63,
    MediumPurple2_2,
    MediumPurple1,
    Gold3,
    DarkKhaki,
    NavajoWhite3,
    Grey69,
    LightSteelBlue3,
    LightSteelBlue,
    Yellow3,
    DarkOliveGreen3_3,
    DarkSeaGreen3_2,
    DarkSeaGreen2,
    LightCyan3,
    LightSkyBlue1,
    GreenYellow,
    DarkOliveGreen2,
    PaleGreen1_2,
    DarkSeaGreen2_2,
    DarkSeaGreen1,
    PaleTurquoise1,
    Red3_2,
    DeepPink3,
    DeepPink3_2,
    Magenta3_2,
    Magenta3_3,
    Magenta2,
    DarkOrange3_2,
    IndianRed_2,
    HotPink3_2,
    HotPink2,
    Orchid,
    MediumOrchid1,
    Orange3,
    LightSalmon3_2,
    LightPink3,
    Pink3,
    Plum3,
    Violet,
    Gold3_2,
    LightGoldenrod3,
    Tan,
    MistyRose3,
    Thistle3,
    Plum2,
    Yellow3_2,
    Khaki3,
    LightGoldenrod2,
    LightYellow3,
    Grey84,
    LightSteelBlue1,
    Yellow2,
    DarkOliveGreen1,
    DarkOliveGreen1_2,
    DarkSeaGreen1_2,
    Honeydew2,
    LightCyan1,
    Red1,
    DeepPink2,
    DeepPink1,
    DeepPink1_2,
    Magenta2_2,
    Magenta1,
    OrangeRed1,
    IndianRed1,
    IndianRed1_2,
    HotPink,
    HotPink_2,
    MediumOrchid1_2,
    DarkOrange,
    Salmon1,
    LightCoral,
    PaleVioletRed1,
    Orchid2,
    Orchid1,
    Orange1,
    SandyBrown,
    LightSalmon1,
    LightPink1,
    Pink1,
    Plum1,
    Gold1,
    LightGoldenrod2_2,
    LightGoldenrod2_3,
    NavajoWhite1,
    MistyRose1,
    Thistle1,
    Yellow1,
    LightGoldenrod1,
    Khaki1,
    Wheat1,
    Cornsilk1,
    Grey100,
    Grey3,
    Grey7,
    Grey11,
    Grey15,
    Grey19,
    Grey23,
    Grey27,
    Grey30,
    Grey35,
    Grey39,
    Grey42,
    Grey46,
    Grey50,
    Grey54,
    Grey58,
    Grey62,
    Grey66,
    Grey70,
    Grey74,
    Grey78,
    Grey82,
    Grey85,
    Grey89,
    Grey93,
  ];
}

class AnsiExtendedColorPaletteRawImpl implements NamedAnsiExtendedColor {
  @override
  final int paletteNumberByte;
  @override
  final String name;

  const AnsiExtendedColorPaletteRawImpl(this.paletteNumberByte, this.name)
      : assert(
          paletteNumberByte >= byteStart && paletteNumberByte <= byteSize,
          'Color must be a value between 0 and 255.',
        );
}
