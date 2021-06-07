import '../interface/color_types/basic.dart';
import '../interface/color_types/extended.dart';

/// Base node for graphics rendition command nodes.
/// TODO crossed out 9 enable 29 disable.
/// TODO frame 51 enable 54 disable.
/// TODO encircled 52 enable 54 disable.
/// TODO overlined 53 enable 55 disable.
/// TODO what is conceal at 8 and reveal at 28.
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
/// TODO disable bold is 22?
class GraphicsRenditionNodeHighlightImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeHighlightImpl();

  @override
  Iterable<String> get commands => const ["1"];
}

/// Italic.
/// TODO disable italic is 23?
class GraphicsRenditionNodeItalicImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeItalicImpl();

  @override
  Iterable<String> get commands => const ["3"];
}

/// Underline.
/// TODO disable underline is 24?
class GraphicsRenditionNodeUnderlineImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeUnderlineImpl();

  @override
  Iterable<String> get commands => const ["4"];
}

/// Blink.
/// TODO disable blink is 25?
class GraphicsRenditionNodeBlinkImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeBlinkImpl();

  @override
  Iterable<String> get commands => const ["5"];
}

/// Inverted also known as reversed.
///
/// Inverts colors.
/// TODO disable inverted is 27?
class GraphicsRenditionNodeInvertedImpl implements GraphicsRenditionNode {
  const GraphicsRenditionNodeInvertedImpl();

  @override
  Iterable<String> get commands => const ["7"];
}

/// Set text colour from the basic colour palette of 0–7.
/// TODO reset text color is 39?
class GraphicsRenditionNodeTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeTextColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "3" + color.paletteNumberTribit.toString();
  }
}

/// Set text colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightTextColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightTextColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "9" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour.
/// TODO reset BG color is 49?
class GraphicsRenditionNodeBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBackgroundColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "4" + color.paletteNumberTribit.toString();
  }
}

/// Set background colour from the bright colour palette of 0–7.
class GraphicsRenditionNodeBrightBackgroundColorImpl implements GraphicsRenditionNode {
  final AnsiBasicPalette color;

  const GraphicsRenditionNodeBrightBackgroundColorImpl(this.color);

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
  final int raw;

  const GraphicsRenditionNodeColorImpl(this.raw);

  @override
  Iterable<String> get commands sync* {
    yield raw.toString();
  }
}

/// Set text colour to index n in a 256-colour palette
/// See https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg
class GraphicsRenditionNodeExtendedTextColorImpl implements GraphicsRenditionNode {
  final AnsiExtendedColorPalette color;

  const GraphicsRenditionNodeExtendedTextColorImpl(this.color);

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

  const GraphicsRenditionNodeExtendedBackgroundColorImpl(this.color);

  @override
  Iterable<String> get commands sync* {
    yield "48";
    yield "5";
    yield color.paletteNumberByte.toString();
  }
}

/// Set text colour to an RGB value.
class GraphicsRenditionNodeRGBTextColorImpl implements GraphicsRenditionNode {
  final int r;
  final int g;
  final int b;

  const GraphicsRenditionNodeRGBTextColorImpl(this.r, this.g, this.b);

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

  const GraphicsRenditionNodeRGBBackgroundColorImpl(this.r, this.g, this.b);

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

  const CompositeGraphicsRenditionNode(this.nodes);

  @override
  Iterable<String> get commands sync* {
    for (final node in nodes) {
      yield* node.commands;
    }
  }
}
