// ignore_for_file: avoid_private_typedef_functions

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'terminal_lib.dart';

// region public
SneathTerminal auto_unix_sneath_terminal() {
  // This assumes that all other platforms that dart
  // can run on are unix based and have the libs needed
  // by the unix implementation, which may not always
  // be the case.
  if (Platform.isMacOS) {
    return auto_unix_macos_sneath_terminal();
  } else {
    return auto_unix_generic_sneath_terminal();
  }
}

SneathTerminal auto_unix_generic_sneath_terminal() {
  return make_sneath_terminal_unix(
    stdlib: DynamicLibrary.open('libc.so.6'),
    IOCTL_TIOCGWINSZ: 0x5413,
  );
}

SneathTerminal auto_unix_macos_sneath_terminal() {
  return make_sneath_terminal_unix(
    stdlib: DynamicLibrary.open('/usr/lib/libSystem.dylib'),
    IOCTL_TIOCGWINSZ: 0x40087468,
  );
}

_SneathTerminalUnixImpl make_sneath_terminal_unix({
  required final DynamicLibrary stdlib,
  required final int IOCTL_TIOCGWINSZ,
}) {
  final _tcgetattr =
      stdlib.lookupFunction<_TERMIOS_tcgetattrNative, _TERMIOS_tcgetattrDart>(
    'tcgetattr',
  );
  final _orig_term_ios_pointer = calloc<_TermIOS>();
  _tcgetattr(
    _UnistdConstants.STDIN_FILENO,
    _orig_term_ios_pointer,
  );
  return _SneathTerminalUnixImpl._(
    stdlib: stdlib,
    orig_term_ios_pointer: _orig_term_ios_pointer,
    ioctl: stdlib.lookupFunction<_IOCTL_Native, _IOCTL_Dart>(
      'ioctl',
    ),
    tcgetattr: _tcgetattr,
    tcsetattr:
        stdlib.lookupFunction<_TERMIOS_tcsetattrNative, _TERMIOS_tcsetattrDart>(
      'tcsetattr',
    ),
    IOCTL_TIOCGWINSZ: IOCTL_TIOCGWINSZ,
  );
}
// endregion

// region internal
/// glibc-dependent library for interrogating and manipulating the console.
///
/// This class provides raw wrappers for the underlying terminal system calls
/// that are not available through ANSI mode control sequences, and is not
/// designed to be called directly.
class _SneathTerminalUnixImpl implements SneathTerminal {
  final DynamicLibrary stdlib;
  final Pointer<_TermIOS> orig_term_ios_pointer;
  final _IOCTL_Dart ioctl;
  final _TERMIOS_tcgetattrDart tcgetattr;
  final _TERMIOS_tcsetattrDart tcsetattr;
  final int IOCTL_TIOCGWINSZ;

  const _SneathTerminalUnixImpl._({
    required final this.stdlib,
    required final this.orig_term_ios_pointer,
    required final this.ioctl,
    required final this.tcgetattr,
    required final this.tcsetattr,
    required final this.IOCTL_TIOCGWINSZ,
  });

  @override
  int get_window_height() {
    final win_size_pointer = calloc<_IOCTL_WinSize>();
    final result = ioctl(
      _UnistdConstants.STDOUT_FILENO,
      IOCTL_TIOCGWINSZ,
      win_size_pointer.cast(),
    );
    if (result == -1) {
      return -1;
    } else {
      final win_size = win_size_pointer.ref;
      if (win_size.ws_row == 0) {
        return -1;
      } else {
        final result = win_size.ws_row;
        calloc.free(win_size_pointer);
        return result;
      }
    }
  }

  @override
  int get_window_width() {
    final win_size_pointer = calloc<_IOCTL_WinSize>();
    final result = ioctl(
      _UnistdConstants.STDOUT_FILENO,
      IOCTL_TIOCGWINSZ,
      win_size_pointer.cast(),
    );
    if (result == -1) {
      return -1;
    } else {
      final win_size = win_size_pointer.ref;
      if (win_size.ws_col == 0) {
        return -1;
      } else {
        final result = win_size.ws_col;
        calloc.free(win_size_pointer);
        return result;
      }
    }
  }

  @override
  void enable_raw_mode() {
    final _orig_term_ios = orig_term_ios_pointer.ref;
    final new_term_ios_pointer = calloc<_TermIOS>();
    final new_term_ios = new_term_ios_pointer.ref;
    new_term_ios.c_iflag = _orig_term_ios.c_iflag &
        ~(_TermiosConstants.BRKINT |
            _TermiosConstants.ICRNL |
            _TermiosConstants.INPCK |
            _TermiosConstants.ISTRIP |
            _TermiosConstants.IXON);
    new_term_ios.c_oflag = _orig_term_ios.c_oflag & ~_TermiosConstants.OPOST;
    new_term_ios.c_cflag = _orig_term_ios.c_cflag | _TermiosConstants.CS8;
    new_term_ios.c_lflag = _orig_term_ios.c_lflag &
        ~(_TermiosConstants.ECHO |
            _TermiosConstants.ICANON |
            _TermiosConstants.IEXTEN |
            _TermiosConstants.ISIG);
    new_term_ios.c_cc0 = _orig_term_ios.c_cc0;
    new_term_ios.c_cc1 = _orig_term_ios.c_cc1;
    new_term_ios.c_cc2 = _orig_term_ios.c_cc2;
    new_term_ios.c_cc3 = _orig_term_ios.c_cc3;
    new_term_ios.c_cc4 = _orig_term_ios.c_cc4;
    new_term_ios.c_cc5 = _orig_term_ios.c_cc5;
    new_term_ios.c_cc6 = _orig_term_ios.c_cc6;
    new_term_ios.c_cc7 = _orig_term_ios.c_cc7;
    new_term_ios.c_cc8 = _orig_term_ios.c_cc8;
    new_term_ios.c_cc9 = _orig_term_ios.c_cc9;
    new_term_ios.c_cc10 = _orig_term_ios.c_cc10;
    new_term_ios.c_cc11 = _orig_term_ios.c_cc11;
    new_term_ios.c_cc12 = _orig_term_ios.c_cc12;
    new_term_ios.c_cc13 = _orig_term_ios.c_cc13;
    new_term_ios.c_cc14 = _orig_term_ios.c_cc14;
    new_term_ios.c_cc15 = _orig_term_ios.c_cc15;
    new_term_ios.c_cc16 = 0; // VMIN -- return each byte, or 0 for timeout
    new_term_ios.c_cc17 = 1; // VTIME -- 100ms timeout (unit is 1/10s)
    new_term_ios.c_cc18 = _orig_term_ios.c_cc18;
    new_term_ios.c_cc19 = _orig_term_ios.c_cc19;
    new_term_ios.c_ispeed = _orig_term_ios.c_ispeed;
    new_term_ios.c_oflag = _orig_term_ios.c_ospeed;
    tcsetattr(
      _UnistdConstants.STDIN_FILENO,
      _TermiosConstants.TCSAFLUSH,
      new_term_ios_pointer,
    );
    calloc.free(new_term_ios_pointer);
  }

  @override
  void disable_raw_mode() {
    if (nullptr != orig_term_ios_pointer.cast()) {
      tcsetattr(
        _UnistdConstants.STDIN_FILENO,
        _TermiosConstants.TCSAFLUSH,
        orig_term_ios_pointer,
      );
    }
  }

  @override
  void clear_screen() {
    stdout.write(
      '\x1b' + "[" + '2J' + '\x1b' + "[" + 'H',
    );
  }

  @override
  void set_cursor_position(
    final int col,
    final int row,
  ) {
    stdout.write(
      '\x1b' + "[" + (row + 1).toString() + ";" + (col + 1).toString() + "H",
    );
  }
}

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class _IOCTL_WinSize extends Struct {
  _IOCTL_WinSize();

  @Int16()
  external int ws_row;
  @Int16()
  external int ws_col;
  @Int16()
  external int ws_xpixel;
  @Int16()
  external int ws_ypixel;
}

// int ioctl(int, unsigned long, ...);
typedef _IOCTL_Native = Int32 Function(Int32, Int64, Pointer<Void>);
typedef _IOCTL_Dart = int Function(int, int, Pointer<Void>);

abstract class _TermiosConstants {
  // INPUT FLAGS
  // static const int IGNBRK = 0x00000001; // ignore BREAK condition
  static const int BRKINT = 0x00000002; // map BREAK to SIGINTR
  // static const int IGNPAR = 0x00000004; // ignore (discard) parity errors
  // static const int PARMRK = 0x00000008; // mark parity and framing errors
  static const int INPCK = 0x00000010; // enable checking of parity errors
  static const int ISTRIP = 0x00000020; // strip 8th bit off chars
  // static const int INLCR = 0x00000040; // map NL into CR
  // static const int IGNCR = 0x00000080; // ignore CR
  static const int ICRNL = 0x00000100; // map CR to NL (ala CRMOD)
  static const int IXON = 0x00000200; // enable output flow control
  // static const int IXOFF = 0x00000400; // enable input flow control
  // static const int IXANY = 0x00000800; // any char will restart after stop
  // static const int IMAXBEL = 0x00002000; // ring bell on input queue full
  // static const int IUTF8 = 0x00004000; // maintain state for UTF-8 VERASE
  // OUTPUT FLAGS
  static const int OPOST = 0x00000001; // enable following output processing
  // static const int ONLCR = 0x00000002; // map NL to CR-NL (ala CRMOD)
  // static const int OXTABS = 0x00000004; // expand tabs to spaces
  // static const int ONOEOT = 0x00000008; // discard EOT's (^D) on output)
  // CONTROL FLAGS
  // static const int CIGNORE = 0x00000001; // ignore control flags
  // static const int CSIZE = 0x00000300; // character size mask
  // static const int CS5 = 0x00000000; // 5 bits (pseudo)
  // static const int CS6 = 0x00000100; // 6 bits
  // static const int CS7 = 0x00000200; // 7 bits
  static const int CS8 = 0x00000300; // 8 bits
  // LOCAL FLAGS
  // static const int ECHOKE = 0x00000001; // visual erase for line kill
  // static const int ECHOE = 0x00000002; // visually erase chars
  // static const int ECHOK = 0x00000004; // echo NL after line kill
  static const int ECHO = 0x00000008; // enable echoing
  // static const int ECHONL = 0x00000010; // echo NL even if ECHO is off
  // static const int ECHOPRT = 0x00000020; // visual erase mode for hardcopy
  // static const int ECHOCTL = 0x00000040; // echo control chars as ^(Char)
  static const int ISIG = 0x00000080; // enable signals INTR, QUIT, [D]SUSP
  static const int ICANON = 0x00000100; // canonicalize input lines
  // static const int ALTWERASE = 0x00000200; // use alternate WERASE algorithm
  static const int IEXTEN = 0x00000400; // enable DISCARD and LNEXT
  // static const int EXTPROC = 0x00000800; // external processing
  // static const int TOSTOP = 0x00400000; // stop background jobs from output
  // static const int FLUSHO = 0x00800000; // output being flushed (state)
  // static const int NOKERNINFO = 0x02000000; // no kernel output from VSTATUS
  // static const int PENDIN = 0x20000000; // XXX retype pending input (state)
  // static const int NOFLSH = 0x80000000; // don't flush after interrupt
  // static const int TCSANOW = 0; // make change immediate
  // static const int TCSADRAIN = 1; // drain output, then change
  static const int TCSAFLUSH = 2; // drain output, flush input
// static const int VMIN = 16; // minimum number of characters to receive
// static const int VTIME = 17; // time in 1/10s before returning
}

// typedef unsigned long   tcflag_t;
// typedef unsigned char   cc_t;
// typedef unsigned long   speed_t;
// #define NCCS            20

// struct termios {
// 	tcflag_t        c_iflag;        /* input flags */
// 	tcflag_t        c_oflag;        /* output flags */
// 	tcflag_t        c_cflag;        /* control flags */
// 	tcflag_t        c_lflag;        /* local flags */
// 	cc_t            c_cc[NCCS];     /* control chars */
// 	speed_t         c_ispeed;       /* input speed */
// 	speed_t         c_ospeed;       /* output speed */
// };
class _TermIOS extends Struct {
  _TermIOS();

  @Int64()
  external int c_iflag;
  @Int64()
  external int c_oflag;
  @Int64()
  external int c_cflag;
  @Int64()
  external int c_lflag;

  // This replaces c_cc[20]
  @Int8()
  external int c_cc0;
  @Int8()
  external int c_cc1;
  @Int8()
  external int c_cc2;
  @Int8()
  external int c_cc3;
  @Int8()
  external int c_cc4;
  @Int8()
  external int c_cc5;
  @Int8()
  external int c_cc6;
  @Int8()
  external int c_cc7;
  @Int8()
  external int c_cc8;
  @Int8()
  external int c_cc9;
  @Int8()
  external int c_cc10;
  @Int8()
  external int c_cc11;
  @Int8()
  external int c_cc12;
  @Int8()
  external int c_cc13;
  @Int8()
  external int c_cc14;
  @Int8()
  external int c_cc15;
  @Int8()
  external int c_cc16; // VMIN
  @Int8()
  external int c_cc17; // VTIME
  @Int8()
  external int c_cc18;
  @Int8()
  external int c_cc19;
  @Int64()
  external int c_ispeed;
  @Int64()
  external int c_ospeed;
}

// int tcgetattr(int, struct termios *);
typedef _TERMIOS_tcgetattrNative = Int32 Function(
    Int32 fildes, Pointer<_TermIOS> termios);
typedef _TERMIOS_tcgetattrDart = int Function(
    int fildes, Pointer<_TermIOS> termios);

// int tcsetattr(int, int, const struct termios *);
typedef _TERMIOS_tcsetattrNative = Int32 Function(
    Int32 fildes, Int32 optional_actions, Pointer<_TermIOS> termios);
typedef _TERMIOS_tcsetattrDart = int Function(
    int fildes, int optional_actions, Pointer<_TermIOS> termios);

abstract class _UnistdConstants {
  static const int STDIN_FILENO = 0;
  static const int STDOUT_FILENO = 1;
// static const int STDERR_FILENO = 2;
}
// endregion
