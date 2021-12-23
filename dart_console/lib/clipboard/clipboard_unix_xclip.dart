import 'dart:io';

import 'clipboard.dart';

class SystemClipboardXClipImpl implements SystemClipboard {
  static const String xclipLocation = '/usr/bin/xclip';

  const SystemClipboardXClipImpl();

  @override
  String getClipboardContent() {
    final result = Process.runSync(
      xclipLocation,
      [
        '-selection',
        'clipboard',
        '-o',
      ],
    );
    if (result.exitCode != 0) {
      throw Exception(
        'Failed to get clipboard content. ' + result.exitCode.toString(),
      );
    } else {
      return result.stdout.toString();
    }
  }

  @override
  void setClipboardContent(
    final String content,
  ) =>
      Process.start(xclipLocation, ['-selection', 'clipboard']).then(
        (final process) {
          process.stdin.write(content);
          process.stdin.close();
        },
      );
}
