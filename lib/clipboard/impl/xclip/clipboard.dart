import 'dart:io';

import '../../interface/clipboard.dart';

class SystemClipboardXClipImpl implements SystemClipboard {
  const SystemClipboardXClipImpl();

  @override
  String getContent() {
    final result = Process.runSync('/usr/bin/xclip', ['-selection', 'clipboard', '-o']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/xclip', ['-selection', 'clipboard']).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
