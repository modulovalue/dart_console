import 'dart:io';

import 'clipboard.dart';

// region public
SystemClipboard? clipboard_xclip() {
  if (File(_SystemClipboardXClipImpl.xclip_location).existsSync()) {
    return const _SystemClipboardXClipImpl();
  } else {
    return null;
  }
}
// endregion

// region internal
class _SystemClipboardXClipImpl implements SystemClipboard {
  static const String xclip_location = '/usr/bin/xclip';

  const _SystemClipboardXClipImpl();

  @override
  String get_clipboard_content() {
    final result = Process.runSync(
      xclip_location,
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
  void set_clipboard_content(
    final String content,
  ) {
    Process.start(xclip_location, ['-selection', 'clipboard']).then(
      (final process) {
        process.stdin.write(content);
        process.stdin.close();
      },
    );
  }
}
// endregion
