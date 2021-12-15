import 'package:dart_ansi/ansi.dart';

import '../console/alignment.dart';
import '../console/interface/console.dart';

void runProgressScaffold({
  required final ProgressScaffoldState state,
  required final SneathConsole console,
}) {
  console.hideCursor();
  console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.blue));
  console.setForegroundColor(const BrightAnsiColorAdapter(NamedAnsiColors.white));
  console.clearScreen();
  final title = state.title;
  if (title != null) {
    console.writeLine(title, ConsoleTextAlignments.center);
  }
  console.writeLine(
    '=== ' + DateTime.now().difference(state.startedAt).toString().split(".").first + ' ===',
    ConsoleTextAlignments.center,
  );
  final subtitle = state.subtitle;
  if (subtitle != null) {
    console.writeLine(
      subtitle,
      ConsoleTextAlignments.center,
    );
  }
  console.showCursor();
}

class ProgressScaffoldState {
  final DateTime startedAt;
  final String? title;
  final String? subtitle;

  ProgressScaffoldState({
    final this.title,
    final this.subtitle,
  }) : startedAt = DateTime.now();
}
