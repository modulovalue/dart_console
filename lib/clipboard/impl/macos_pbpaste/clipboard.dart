import 'dart:io';

import '../../interface/clipboard.dart';

class SystemClipboardMacosPbpaste implements SystemClipboard {
  const SystemClipboardMacosPbpaste();

  @override
  String getContent() {
    final result = Process.runSync('/usr/bin/pbpaste', []);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/pbpaste', []).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
