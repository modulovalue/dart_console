import '../ansi_writer/ansi_writer.dart';
import '../console/interface.dart';

void run_progress_scaffold({
  required final ProgressScaffoldState state,
  required final SneathConsole console,
}) {
  console.hide_cursor();
  console.set_background_color(
    const DarkAnsiBackgroundColorAdapter(
      NamedAnsiColorBlueImpl(),
    ),
  );
  console.set_foreground_color(
    const BrightAnsiForegroundColorAdapter(
      NamedAnsiColorWhiteImpl(),
    ),
  );
  console.clear_screen();
  final title = state.title;
  if (title != null) {
    console.write_line(
      title,
      ConsoleTextAlignments.center,
    );
  }
  console.write_line(
    '=== ' + DateTime.now().difference(state.started_at).toString().split(".").first + ' ===',
    ConsoleTextAlignments.center,
  );
  final subtitle = state.subtitle;
  if (subtitle != null) {
    console.write_line(
      subtitle,
      ConsoleTextAlignments.center,
    );
  }
  console.show_cursor();
}

ProgressScaffoldState progress_scaffold_state_now({
  final String? title,
  final String? subtitle,
}) {
  return ProgressScaffoldState(
    title: title,
    subtitle: subtitle,
    started_at: DateTime.now(),
  );
}

class ProgressScaffoldState {
  final DateTime started_at;
  final String? title;
  final String? subtitle;

  const ProgressScaffoldState({
    required final this.started_at,
    final this.title,
    final this.subtitle,
  });
}
