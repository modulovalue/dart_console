import '../ansi/ansi.dart';
import '../console/interface/console.dart';
import '../console/interface/text_alignments.dart';

class ProgressScaffold {
  final String? title;
  final String? subtitle;

  int get linesTaken => 3;

  const ProgressScaffold({
    this.title,
    this.subtitle,
  });

  void run(ProgressScaffoldState state, SneathConsole console) {
    console.setBackgroundColor(NamedAnsiColor.blue);
    console.setForegroundColor(NamedAnsiColor.white);
    console.setTextStyle(bold: true);
    console.clearScreen();
    console.writeLine(title, TextAlignment.center);
    console.writeLine('=== ' + DateTime.now().difference(state.startedAt).toString().split(".").first + ' ===', TextAlignment.center);
    console.writeLine(subtitle, TextAlignment.center);
  }
}

class ProgressScaffoldState {
  final DateTime startedAt;

  ProgressScaffoldState() : startedAt = DateTime.now();
}
