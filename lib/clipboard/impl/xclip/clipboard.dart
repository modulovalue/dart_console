import 'dart:io';

import '../../interface/clipboard.dart';

class SystemClipboardXClipImpl implements SystemClipboard {
  static const String xclipLocation = '/usr/bin/xclip';

  const SystemClipboardXClipImpl();

  @override
  String getContent() {
    final result = Process.runSync(xclipLocation, ['-selection', 'clipboard', '-o']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content. ${result.exitCode}');
    } else {
      return result.stdout.toString();
    }
  }

  @override
  void setContent(String content) {
    Process.start(xclipLocation, ['-selection', 'clipboard']).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
