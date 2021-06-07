import 'dart:io';

import '../../interface/clipboard.dart';

class SystemClipboardMacosPbpaste implements SystemClipboard {
  static const String pbpasteLocation = "/usr/bin/pbpaste";
  static const String pbcopyLocation = "/usr/bin/pbcopy";

  const SystemClipboardMacosPbpaste();

  @override
  String getContent() {
    final result = Process.runSync(pbpasteLocation, []);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content. ${result.exitCode}');
    } else {
      return result.stdout.toString();
    }
  }

  @override
  void setContent(String content) {
    Process.start(pbpasteLocation, []).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
