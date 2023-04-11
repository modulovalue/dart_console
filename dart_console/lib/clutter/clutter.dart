import '../console/interface.dart';

// TODO others? is this really it?
void run_clutter({
  required final SneathConsole console,
  required final Clutter clutter,
}) {
  for (final clidget in clutter.clidgets) {
    clidget.match(
      clear: (final a) => console.clear_screen(),
      text: (final a) => console.write(a.text),
    );
  }
}

class Clutter {
  final List<Clidget> clidgets;

  const Clutter({
    required final this.clidgets,
  });
}

abstract class Clidget {
  R match<R>({
    required final R Function(ClidgetClear) clear,
    required final R Function(ClidgetText) text,
  });
}

class ClidgetClear implements Clidget {
  const ClidgetClear();

  @override
  R match<R>({
    required final R Function(ClidgetClear p1) clear,
    required final R Function(ClidgetText p1) text,
  }) {
    return clear(this);
  }
}

class ClidgetText implements Clidget {
  final String text;

  const ClidgetText({
    required final this.text,
  });

  @override
  R match<R>({
    required final R Function(ClidgetClear p1) clear,
    required final R Function(ClidgetText p1) text,
  }) {
    return text(this);
  }
}
