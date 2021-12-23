import '../ansi/ansi.dart';
import '../console/alignment.dart';
import '../console/interface/console.dart';

void runProgressScaffold({
  required final ProgressScaffoldState state,
  required final SneathConsole console,
}) {
  console.hideCursor();
  console.setBackgroundColor(
    const DarkAnsiBackgroundColorAdapter(
      NamedAnsiColorBlueImpl(),
    ),
  );
  console.setForegroundColor(
    const BrightAnsiForegroundColorAdapter(
      NamedAnsiColorWhiteImpl(),
    ),
  );
  console.clearScreen();
  final title = state.title;
  if (title != null) {
    console.writeLine(
      title,
      ConsoleTextAlignments.center,
    );
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

ProgressScaffoldState progressScaffoldStateNow({
  final String? title,
  final String? subtitle,
}) =>
    ProgressScaffoldState(
      title: title,
      subtitle: subtitle,
      startedAt: DateTime.now(),
    );

class ProgressScaffoldState {
  final DateTime startedAt;
  final String? title;
  final String? subtitle;

  const ProgressScaffoldState({
    required final this.startedAt,
    final this.title,
    final this.subtitle,
  });
}
