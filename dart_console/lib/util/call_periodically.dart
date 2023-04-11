import 'dart:async';

/// Calls the given [routine] every [period].
void call_periodically({
  required final void Function() routine,
  final Duration period = const Duration(
    milliseconds: 1000,
  ),
}) {
  call_periodically_with_hot_reload(
    routine: routine,
    wrapper: (final a) => a(),
    period: period,
  );
}

/// Same as [call_periodically], but meant to be
/// used with hot reload. Inject your hot
/// reload implementation via [wrapper].
void call_periodically_with_hot_reload({
  required final void Function() routine,
  required final void Function(void Function()) wrapper,
  final Duration period = const Duration(
    milliseconds: 1000,
  ),
}) {
  StreamSubscription<dynamic>? _subscription;
  wrapper(
    () {
      _subscription?.cancel();
      _subscription = Stream<dynamic>.periodic(
        period,
      ).listen(
        (final dynamic _) => routine(),
      );
    },
  );
}
