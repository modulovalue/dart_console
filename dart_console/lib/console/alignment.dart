/// Text alignments for console line output.
abstract class ConsoleTextAlignment {
  String align(
    final String text,
    final int windowWidth,
  );
}

abstract class ConsoleTextAlignments {
  static const ConsoleTextAlignmentLeftImpl left = ConsoleTextAlignmentLeftImpl._();
  static const ConsoleTextAlignmentCenterImpl center = ConsoleTextAlignmentCenterImpl._();
  static const ConsoleTextAlignmentRightImpl right = ConsoleTextAlignmentRightImpl._();
}

class ConsoleTextAlignmentLeftImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentLeftImpl._();

  @override
  String align(
    final String text,
    final int windowWidth,
  ) =>
      text;
}

class ConsoleTextAlignmentCenterImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentCenterImpl._();

  static String alignSingleLine(
    final String text,
    final int windowWidth,
  ) =>
      text
          .padLeft(
            text.length + ((windowWidth - text.length) / 2).round(),
          )
          .padRight(windowWidth);

  @override
  String align(
    final String text,
    final int windowWidth,
  ) =>
      text
          .split("\n")
          .map(
            (final line) => alignSingleLine(line, windowWidth),
          )
          .join("\n");
}

class ConsoleTextAlignmentRightImpl implements ConsoleTextAlignment {
  const ConsoleTextAlignmentRightImpl._();

  @override
  String align(
    final String text,
    final int windowWidth,
  ) =>
      text.padLeft(windowWidth);
}
