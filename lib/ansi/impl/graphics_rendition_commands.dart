import '../interface/basic_ansi_color.dart';
import '../interface/byte_color.dart';

/// Base node for graphics rendition command nodes.
/// TODO crossed out 9 enable 29 disable.
/// TODO frame 51 enable 54 disable.
/// TODO encircled 52 enable 54 disable.
/// TODO overlined 53 enable 55 disable.
/// TODO what is conceal at 8 and reveal at 28.
abstract class GraphicsRenditionNode {
  Iterable<int> get commands;
}

/// Reset: turn off all attributes.
class GraphicsRenditionNodeResetImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeResetImpl();

  @override
  Iterable<int> get commands => const [0];
}

/// Bold (or bright, it’s up to the terminal and the user config to some extent).
/// TODO disable bold is 22?
class GraphicsRenditionNodeHighlightImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeHighlightImpl();

  @override
  Iterable<int> get commands => const [1];
}

/// Italic.
/// TODO disable italic is 23?
class GraphicsRenditionNodeItalicImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeItalicImpl();

  @override
  Iterable<int> get commands => const [3];
}

/// Underline.
/// TODO disable underline is 24?
class GraphicsRenditionNodeUnderlineImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeUnderlineImpl();

  @override
  Iterable<int> get commands => const [4];
}

/// Blink.
/// TODO disable blink is 25?
class GraphicsRenditionNodeBlinkImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeBlinkImpl();

  @override
  Iterable<int> get commands => const [5];
}

/// Inverted also known as reversed.
///
/// Inverts colors.
/// TODO disable inverted is 27?
class GraphicsRenditionNodeInvertedImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeInvertedImpl();

  @override
  Iterable<int> get commands => const [7];
}

/// Set text colour from the basic colour palette of 0–7.
/// TODO reset text color is 39?
class GraphicsRenditionNodeTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeTextColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 30 + color.paletteNumberTribit;
  }
}

/// Set text colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightTextColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 90 + color.paletteNumberTribit;
  }
}

/// Set background colour.
/// TODO reset BG color is 49?
class GraphicsRenditionNodeBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBackgroundColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 40 + color.paletteNumberTribit;
  }
}

/// Set background colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightBackgroundColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 100 + color.paletteNumberTribit;
  }
}

/// Sets text or background color. Bright or normal color.
/// What will be set depends on the value given.
///
/// This is an unsafe operation and should be avoided.
class GraphicsRenditionNodeColorImpl implements GraphicsRenditionNode {
  final int raw;

  const GraphicsRenditionNodeColorImpl(this.raw);

  @override
  Iterable<int> get commands sync* {
    yield raw;
  }
}

/// Set text colour to index n in a 256-colour palette
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedTextColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedTextColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 38;
    yield 5;
    yield color.paletteNumberByte;
  }
}

/// Set background colour to index n in a 256-colour palette.
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedBackgroundColorImpl(this.color);

  @override
  Iterable<int> get commands sync* {
    yield 48;
    yield 5;
    yield color.paletteNumberByte;
  }
}

/// Set text colour to an RGB value.
class GraphicsRenditionNodeRGBTextColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBTextColorImpl(this.r, this.g, this.b);

  @override
  Iterable<int> get commands sync* {
    yield 38;
    yield 2;
    yield r;
    yield g;
    yield b;
  }
}

/// Set background colour to an RGB value.
class GraphicsRenditionNodeRGBBackgroundColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBBackgroundColorImpl(this.r, this.g, this.b);

  @override
  Iterable<int> get commands sync* {
    yield 48;
    yield 2;
    yield r;
    yield g;
    yield b;
  }
}

/// Allows you to treat multiple [GraphicsRenditionNode] instances as one.
class CompositeGraphicsRenditionNode implements GraphicsRenditionNode {
  final Iterable<GraphicsRenditionNode> nodes;

  const CompositeGraphicsRenditionNode(this.nodes);

  @override
  Iterable<int> get commands sync* {
    for (final node in nodes) {
      yield* node.commands;
    }
  }
}
