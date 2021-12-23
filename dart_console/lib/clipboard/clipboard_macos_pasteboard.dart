import 'dart:io';

import 'clipboard.dart';

class SystemClipboardMacosPbpaste implements SystemClipboard {
  static const String _pbpasteLocation = "/usr/bin/pbpaste";
  // static const String _pbcopyLocation = "/usr/bin/pbcopy";

  const SystemClipboardMacosPbpaste();

  @override
  String getClipboardContent() {
    final result = Process.runSync(
      _pbpasteLocation,
      [],
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
  ) {
    Process.start(_pbpasteLocation, []).then(
      (final process) {
        process.stdin.write(content);
        process.stdin.close();
      },
    );
  }
}
