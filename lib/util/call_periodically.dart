import 'dart:async';

/// Calls the given [routine] every [period].
void callPeriodically({
  required void Function() routine,
  Duration period = const Duration(milliseconds: 1000),
}) =>
    callPeriodicallyWithHotReload(routine: routine, wrapper: (a) => a(), period: period);

/// Same as [callPeriodically], but meant to be
/// used with hot reload. Inject your hot
/// reload implementation via [wrapper].
void callPeriodicallyWithHotReload({
  required void Function() routine,
  required void Function(void Function()) wrapper,
  Duration period = const Duration(milliseconds: 1000),
}) {
  StreamSubscription<dynamic>? _subscription;
  wrapper(() {
    _subscription?.cancel();
    _subscription = Stream<dynamic>.periodic(period).listen(
      (dynamic _) => routine(),
    );
  });
}
