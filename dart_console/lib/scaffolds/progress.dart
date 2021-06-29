import 'package:dart_ansi/ansi.dart';

import '../console/alignment.dart';
import '../console/interface/console.dart';

class ProgressScaffold {
  final String? title;
  final String? subtitle;

  int get linesTaken => 3;

  const ProgressScaffold({
    this.title,
    this.subtitle,
  });

  void run(ProgressScaffoldState state, SneathConsole console) {
    console.setBackgroundColor(const DarkAnsiColorAdapter(NamedAnsiColors.blue));
    console.setForegroundColor(const BrightAnsiColorAdapter(NamedAnsiColors.white));
    console.clearScreen();
    if (title != null) console.writeLine(title, ConsoleTextAlignments.center);
    console.writeLine(
        '=== ' + DateTime.now().difference(state.startedAt).toString().split(".").first + ' ===', ConsoleTextAlignments.center);
    if (subtitle != null) console.writeLine(subtitle, ConsoleTextAlignments.center);
  }
}

class ProgressScaffoldState {
  final DateTime startedAt;

  ProgressScaffoldState() : startedAt = DateTime.now();
}
