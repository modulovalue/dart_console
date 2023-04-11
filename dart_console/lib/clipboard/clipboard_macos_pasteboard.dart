import 'dart:io';

import 'clipboard.dart';

// region public
SystemClipboard clipboard_macos_pbpaste() {
  return const _SystemClipboardMacosPbpasteImpl();
}
// endregion

// region internal
class _SystemClipboardMacosPbpasteImpl implements SystemClipboard {
  static const String _pbpaste_location = "/usr/bin/pbpaste";
  // TODO should we use pbcopy? why? why not?
  // static const String _pbcopyLocation = "/usr/bin/pbcopy";

  const _SystemClipboardMacosPbpasteImpl();

  @override
  String get_clipboard_content() {
    final result = Process.runSync(
      _pbpaste_location,
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
  void set_clipboard_content(
    final String content,
  ) {
    Process.start(_pbpaste_location, []).then(
      (final process) {
        process.stdin.write(content);
        process.stdin.close();
      },
    );
  }
}
// endregion
