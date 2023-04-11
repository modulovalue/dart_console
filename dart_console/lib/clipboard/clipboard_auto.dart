import 'dart:io';

import 'clipboard.dart';
import 'clipboard_macos_pasteboard.dart';
import 'clipboard_unix_xclip.dart';

// region public
AutoClipboardDetectionResult auto_get_clipboard() {
  if (Platform.isMacOS) {
    return _AutoClipboardDetectionResultSuccessImpl(
      clipboard: clipboard_macos_pbpaste(),
    );
  } else {
    if (Platform.isLinux) {
      final clipboard = clipboard_xclip();
      if (clipboard != null) {
        return _AutoClipboardDetectionResultSuccessImpl(
          clipboard: clipboard,
        );
      } else {
        return const _AutoClipboardDetectionResultLinuxXClipNotFoundImpl();
      }
    } else {
      return const _AutoClipboardDetectionResultUnknownSystemOrNotSupportedImpl();
    }
  }
}

abstract class AutoClipboardDetectionResult {
  Z match<Z>({
    required final Z Function(AutoClipboardDetectionResultSuccess) success,
    required final Z Function(AutoClipboardDetectionResultUnknownSystemOrNotSupported) unknownSystem,
    required final Z Function(AutoClipboardDetectionResultLinuxXClipNotFound) linuxxclipNotFound,
  });
}

abstract class AutoClipboardDetectionResultSuccess implements AutoClipboardDetectionResult {
  SystemClipboard get clipboard;
}

abstract class AutoClipboardDetectionResultLinuxXClipNotFound implements AutoClipboardDetectionResult {}

abstract class AutoClipboardDetectionResultUnknownSystemOrNotSupported implements AutoClipboardDetectionResult {}
// endregion

// region internal
class _AutoClipboardDetectionResultSuccessImpl implements AutoClipboardDetectionResultSuccess {
  @override
  final SystemClipboard clipboard;

  const _AutoClipboardDetectionResultSuccessImpl({
    required final this.clipboard,
  });

  @override
  Z match<Z>({
    required final Z Function(AutoClipboardDetectionResultSuccess p1) success,
    required final Z Function(AutoClipboardDetectionResultUnknownSystemOrNotSupported p1) unknownSystem,
    required final Z Function(AutoClipboardDetectionResultLinuxXClipNotFound p1) linuxxclipNotFound,
  }) =>
      success(this);
}

class _AutoClipboardDetectionResultLinuxXClipNotFoundImpl implements AutoClipboardDetectionResultLinuxXClipNotFound {
  const _AutoClipboardDetectionResultLinuxXClipNotFoundImpl();

  @override
  Z match<Z>({
    required final Z Function(AutoClipboardDetectionResultSuccess p1) success,
    required final Z Function(AutoClipboardDetectionResultUnknownSystemOrNotSupported p1) unknownSystem,
    required final Z Function(AutoClipboardDetectionResultLinuxXClipNotFound p1) linuxxclipNotFound,
  }) =>
      linuxxclipNotFound(this);
}

class _AutoClipboardDetectionResultUnknownSystemOrNotSupportedImpl implements AutoClipboardDetectionResultUnknownSystemOrNotSupported {
  const _AutoClipboardDetectionResultUnknownSystemOrNotSupportedImpl();

  @override
  Z match<Z>({
    required final Z Function(AutoClipboardDetectionResultSuccess p1) success,
    required final Z Function(AutoClipboardDetectionResultUnknownSystemOrNotSupported p1) unknownSystem,
    required final Z Function(AutoClipboardDetectionResultLinuxXClipNotFound p1) linuxxclipNotFound,
  }) =>
      unknownSystem(this);
}
// endregion
