import 'dart:io';

import 'clipboard.dart';
import 'clipboard_macos_pasteboard.dart';
import 'clipboard_unix_xclip.dart';

AutoClipboardResult autoGetClipboard() {
  if (Platform.isMacOS) {
    return const AutoClipboardResultSuccess(
      SystemClipboardMacosPbpaste(),
    );
  } else if (Platform.isLinux) {
    if (File(SystemClipboardXClipImpl.xclipLocation).existsSync()) {
      return const AutoClipboardResultSuccess(
        SystemClipboardXClipImpl(),
      );
    } else {
      return const AutoClipboardResultLinuxXClipNotFoundSystem();
    }
  } else {
    return const AutoClipboardResultUnknownSystemOrNotSupported();
  }
}

abstract class AutoClipboardResult {
  Z match<Z>({
    required Z Function(AutoClipboardResultSuccess) success,
    required Z Function(AutoClipboardResultUnknownSystemOrNotSupported) unknownSystem,
    required Z Function(AutoClipboardResultLinuxXClipNotFoundSystem) linuxxclipNotFound,
  });
}

class AutoClipboardResultSuccess implements AutoClipboardResult {
  final SystemClipboard clipboard;

  const AutoClipboardResultSuccess(
    final this.clipboard,
  );

  @override
  Z match<Z>({
    required Z Function(AutoClipboardResultSuccess p1) success,
    required Z Function(AutoClipboardResultUnknownSystemOrNotSupported p1) unknownSystem,
    required Z Function(AutoClipboardResultLinuxXClipNotFoundSystem p1) linuxxclipNotFound,
  }) =>
      success(this);
}

class AutoClipboardResultUnknownSystemOrNotSupported implements AutoClipboardResult {
  const AutoClipboardResultUnknownSystemOrNotSupported();

  @override
  Z match<Z>({
    required Z Function(AutoClipboardResultSuccess p1) success,
    required Z Function(AutoClipboardResultUnknownSystemOrNotSupported p1) unknownSystem,
    required Z Function(AutoClipboardResultLinuxXClipNotFoundSystem p1) linuxxclipNotFound,
  }) =>
      unknownSystem(this);
}

class AutoClipboardResultLinuxXClipNotFoundSystem implements AutoClipboardResult {
  const AutoClipboardResultLinuxXClipNotFoundSystem();

  @override
  Z match<Z>({
    required Z Function(AutoClipboardResultSuccess p1) success,
    required Z Function(AutoClipboardResultUnknownSystemOrNotSupported p1) unknownSystem,
    required Z Function(AutoClipboardResultLinuxXClipNotFoundSystem p1) linuxxclipNotFound,
  }) =>
      linuxxclipNotFound(this);
}
