/// Text alignments for console line output.
abstract class ConsoleTextAlignment {
  String align(String text, int windowWidth);
}

abstract class ConsoleTextAlignments {
  static const left = ConsoleTextAlignmentLeftImpl._();
  static const center = ConsoleTextAlignmentCenterImpl._();
  static const right = ConsoleTextAlignmentRightImpl._();
}

class ConsoleTextAlignmentLeftImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentLeftImpl._();

  @override
  String align(String text, int windowWidth) => text;
}

class ConsoleTextAlignmentCenterImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentCenterImpl._();

  static String alignSingleLine(String text, int windowWidth) => text //
      .padLeft(text.length + ((windowWidth - text.length) / 2).round())
      .padRight(windowWidth);

  @override
  String align(String text, int windowWidth) => text //
      .split("\n")
      .map((line) => alignSingleLine(line, windowWidth))
      .join("\n");
}

class ConsoleTextAlignmentRightImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentRightImpl._();

  @override
  String align(String text, int windowWidth) => text.padLeft(windowWidth);
}
