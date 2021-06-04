import '../interface/byte_color.dart';
import 'ansi.dart';

/// TODO do the extended colors have a name? if so, be explicit about each color.
/// A [AnsiExtendedColorPalette] from a raw byte.
class AnsiExtendedColorPaletteRawImpl implements AnsiExtendedColorPalette {
  @override
  final int paletteNumberByte;

  const AnsiExtendedColorPaletteRawImpl(this.paletteNumberByte)
      : assert(
          paletteNumberByte >= AnsiConstants.byteStart && paletteNumberByte <= AnsiConstants.byteSize,
          'Color must be a value between 0 and 255.',
        );
}
