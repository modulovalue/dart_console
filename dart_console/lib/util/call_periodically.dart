import 'dart:async';

/// Calls the given [routine] every [period].
void callPeriodically({
  required final void Function() routine,
  final Duration period = const Duration(milliseconds: 1000),
}) =>
    callPeriodicallyWithHotReload(
      routine: routine,
      wrapper: (final a) => a(),
      period: period,
    );

/// Same as [callPeriodically], but meant to be
/// used with hot reload. Inject your hot
/// reload implementation via [wrapper].
void callPeriodicallyWithHotReload({
  required final void Function() routine,
  required final void Function(void Function()) wrapper,
  final Duration period = const Duration(milliseconds: 1000),
}) {
  StreamSubscription<dynamic>? _subscription;
  wrapper(
    () {
      _subscription?.cancel();
      _subscription = Stream<dynamic>.periodic(period).listen(
        (dynamic _) => routine(),
      );
    },
  );
}
